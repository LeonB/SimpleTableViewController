//
//  UITableViewController Extended.h
//  SimpleTableViewController
//
//  Created by Leon Bogaert on 31-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITableViewController (Extended)

UIViewController *childController;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath inBackground:(Boolean)background;
- (void)loadViewControllerInBackground:(NSString *)controllerName;
- (void)loadViewControllerInBackground:(NSInvocation *)invocation withCell:(UITableViewCell *)cell;
- (void)performSelectorInBackground:(SEL)aSelector withValues:(void *)context, ... ;

- (UIViewController *)childController;
- (void)setChildController:(UIViewController *)childController;

//Protected methods
- (void)showIndicator:(UITableViewCell *)cell;
- (void)hideIndicator:(UITableViewCell *)cell;
- (void)resetAccessoryType:(UITableViewCell *)cell withAccessoryType:(NSNumber *)accessoryType;

@end
