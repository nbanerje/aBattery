//
//  aBatteryAppDelegate.h
//  aBattery
//
//  Created by Neel Banerjee on 3/26/09.
//  Copyright Om Design LLC 2009. All rights reserved.
//

@class MainViewController;

@interface aBatteryAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    //MainViewController *mainViewController;
	UITabBarController *tabController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabController;

@end

