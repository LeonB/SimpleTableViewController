//
//  UiViewControllerExtended.m
//  ADB2
//
//  Created by Leon Bogaert on 06-06-10.
//  Copyright 2010 Tim_online. All rights reserved.
//

#import "UIViewController Extended.h"

@implementation UIViewController (Extended)

- (void)pushViewControllerOnMainThread:(UIViewController *)controller animated:(Boolean)animated {
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(pushViewController:animated:)]];
	[invocation setTarget:self];
	[invocation setSelector:@selector(pushViewController:animated:)];
	[invocation setArgument:&controller atIndex:2];
	[invocation setArgument:&animated atIndex:3];
	
	[invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:YES];
	//[invocation invoke];
}

- (void)pushViewController:(UIViewController *)controller animated:(Boolean)animated {
	[self.navigationController pushViewController:controller animated:animated];
}

@end