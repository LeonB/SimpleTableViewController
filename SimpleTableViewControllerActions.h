//
//  UITableViewControllerCustom.h
//  ADB2
//
//  Created by Leon Bogaert on 03-06-10.
//  Copyright 2010 Tim_online. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController Extended.h"

@class SimpleTableViewControllerActions;

@interface SimpleTableViewControllerActions : UITableViewController {
	UIViewController *childController;
}

@property (retain, nonatomic) UIViewController *childController;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath inBackground:(Boolean)background;
- (void)loadViewControllerInBackground:(NSString *)controllerName;
//- (void)loadViewController:(NSInvocation *)invocation withCell:(UITableViewCell *)cell;
- (void)loadViewControllerInBackground:(NSInvocation *)invocation withCell:(UITableViewCell *)cell;
- (void)performSelectorInBackground:(SEL)aSelector withValues:(void *)context, ... ;

//Protected methods
- (void)showIndicator:(UITableViewCell *)cell;
- (void)hideIndicator:(UITableViewCell *)cell;
@end
