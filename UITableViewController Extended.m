//
//  UITableViewController Extended.m
//  SimpleTableViewController
//
//  Created by Leon Bogaert on 31-10-10.
//  Copyright 2010 Tim_online. All rights reserved.
//

#import "UITableViewController Extended.h"

@implementation UITableViewController (Extended)

- (UIViewController *)childController
{
	return childController;
}

- (void)setChildController:(UIViewController *)controller
{
	childController = controller;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath inBackground:(Boolean)background {
	NSLog(@"tableView: didSelectRowAtIndexPath: inBackground:");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"SimpleTableViewControllerActions: tableView didSelectRowAtIndexPath");
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self showIndicator:cell];
	cell.userInteractionEnabled = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[self performSelectorInBackground:@selector(setupCell:indexPath:) withValues:tableView, indexPath];
}

- (void)setupCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
	NSLog(@"setupCell");
	NSAutoreleasePool * pool;
	pool = [[NSAutoreleasePool alloc] init];
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	NSNumber *accessoryType = [NSNumber numberWithInt:cell.accessoryType];
	
	[self tableView:tableView didSelectRowAtIndexPath:indexPath inBackground:YES];
	[self performSelectorOnMainThread:@selector(hideIndicator:) withObject:cell waitUntilDone:YES];
	
	//REset old accessoryType
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(resetAccessoryType:withAccessoryType:)]];
	[invocation setTarget:self];
	[invocation setSelector:@selector(resetAccessoryType:withAccessoryType:)];
	[invocation setArgument:&cell atIndex:2];
	[invocation setArgument:&accessoryType atIndex:3];
	[invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:YES];
	
	[self performSelectorOnMainThread:@selector(enableUserInteraction:) withObject:cell waitUntilDone:YES];
	
	[[UIApplication sharedApplication] performSelectorOnMainThread:@selector(setNetworkActivityIndicatorVisible:) withObject:NO waitUntilDone:YES];
	
	[pool drain];
}

- (void)resetAccessoryType:(UITableViewCell *)cell withAccessoryType:(NSNumber *)accessoryType
{
	NSLog(@"accessoryType: %@", accessoryType);
	cell.accessoryType = [accessoryType integerValue];
}

- (void)showIndicator:(UITableViewCell *)cell {
	NSLog(@"showIndicator");
	
	if (!cell || cell == nil) {
		return;
	}
	
	UIActivityIndicatorView *activityIndicator =  [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activityIndicator startAnimating];
	[cell setAccessoryView:activityIndicator];
	[activityIndicator release];
}

- (void)enableUserInteraction:(UITableViewCell *)cell {
	NSLog(@"enableUserInteraction");
	
	if (!cell || cell == nil) {
		return;
	}
	
	cell.userInteractionEnabled = YES;
	[cell setUserInteractionEnabled:YES];
}

- (void)hideIndicator:(UITableViewCell *)cell {
	//	for (UIView *view in cell.subviews) {
	//		NSLog(@"subView: %@", view);
	//	}
	
	//TODO: activityIndicator uit de cell vissen!
	//	[activityIndicator stopAnimating];
	//	[activityIndicator release];
	
	if (!cell || cell == nil) {
		return;
	}
	
	cell.accessoryView = nil;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)dealloc {
	NSLog(@"Deallocating SimpleTableViewControllerActions");
    [super dealloc];
}

- (void)performSelectorInBackground:(SEL)aSelector withValues:(void *)context, ... {	// See if we were even passed any context.
	if (context) {
		// We'll need an NSInvocation, since it lets us define arguments
		// for multiple parameters.
		NSMethodSignature *theSignature = [self methodSignatureForSelector:aSelector];
		NSInvocation *theInvocation = [NSInvocation invocationWithMethodSignature:theSignature];
		[theInvocation retainArguments];
		
		// Now for the real automagic fun!  We will loop through our arugment list,
		// and match up each parameter with the corresponding index value.
		
		// Since Objective-C actually converts messages into C methods:
		NSUInteger argumentCount = [theSignature numberOfArguments] - 2;
		
		[theInvocation setTarget:self];			// There's our index 0.
		[theInvocation setSelector:aSelector];	// There's our index 1.
		
		// Use the va_* macros to retrieve the arguments.
		va_list arguments;
		
		// Tell it where the optional args start.
		// Since the first parameter, the selector
		// Isn't optional, tell it to start with 'context'.
		va_start (arguments, context);
		
		// Now for arguments 2+
		NSUInteger i, count = argumentCount;
		void* currentValue = context;
		for (i = 0; i < count; i++) {
			// If we run out of arguments, then we pass nil
			// to the remaining parameters.
			[theInvocation setArgument:&currentValue atIndex:(i + 2)]; // The +2 represents self and cmd offsets
			currentValue = va_arg(arguments, void*); // Read the next argument in the list.
			
			// We should also handle the case where we have
			// *more* arguments than parameters.  This will
			// let us cover cases where we are invoking
			// other variadic methods (like arrayWithObjects:).
		}
		// Dispose of our C byte-array.
		va_end (arguments);
		
		// Invoke on our custom worker thread.
		[theInvocation performSelectorInBackground:@selector(invoke) withObject:nil];
		
		// Our NSInvocation is already autoreleased, so we're done.
		
	} else {
		// Since we were not given any context arguments,
		// just do a non-blocking invocation on a background thread.
		// We really would want to check to see that the selector
		// is valid, takes no arguments, etc., but that is left
		// as an exercise for the reader.
		[self performSelectorInBackground:aSelector withObject:nil];
	}
}

/*
 * Oude stuff
 */

- (void)loadViewControllerInBackground:(NSString *)controllerName {
	NSLog(@"loadViewControllerInBackground");
	NSLog(@"controllerName: %@", controllerName);
	
	[self performSelectorInBackground:@selector(loadViewController:) withObject:controllerName];
}

- (void)loadViewControllerInBackground:(NSInvocation *)invocation withCell:(UITableViewCell *)cell {
	NSLog(@"loadViewControllerInBackground withCell");
	
	[self showIndicator:cell];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self performSelectorInBackground:@selector(loadViewController:withCell:) withValues:invocation, cell];
}

//- (void)loadViewController:(NSInvocation *)invocation withCell:(UITableViewCell *)cell {
//	NSLog(@"Hello!");
//	NSAutoreleasePool * pool;
//	pool = [[NSAutoreleasePool alloc] init];
//	
//	UIViewController *controller;
//	[invocation invoke];
//	[invocation getReturnValue:&controller];
//	
//	//[self hideIndicator:cell];
//	[self performSelectorOnMainThread:@selector(hideIndicator:) withObject:cell waitUntilDone:YES];
//	[self performSelectorOnMainThread:@selector(enableUserInteraction:) withObject:cell waitUntilDone:YES];
//	
//	NSLog(@"class: %@", [controller class]);
//	if (controller != nil) {
//		self.childController = controller;
//		[self.navigationController pushViewC‰ontroller:controller animated:YES];
//	}
//	[pool drain];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end
