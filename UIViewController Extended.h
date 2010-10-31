//
//  UiViewControllerExtended.h
//  ADB2
//
//  Created by Leon Bogaert on 06-06-10.
//  Copyright 2010 Tim_online. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewController (Extended) 

- (void)pushViewControllerOnMainThread:(UIViewController *)controller animated:(Boolean)animated;

//Protected methods
- (void)pushViewController:(UIViewController *)controller animated:(Boolean)animated;

@end