//
//  aBatteryAppDelegate.h
//  aBattery
//
//  Created by Neel Banerjee on 3/26/09.
//  Copyright Om Design LLC 2009. All rights reserved.
//
#import "Battery.h"
#import "HistoryData.h"

@class MainViewController;

@interface aBatteryAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITabBarController *tabController;
	
	NSMutableDictionary *settingsDictionary;
	Battery *battery;
	NSArray *switchKeys;
	HistoryData *batteryHistory;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabController;
@property (nonatomic, retain) NSMutableDictionary *settingsDictionary;
@property (nonatomic, retain) Battery *battery;
@property (nonatomic, retain) NSArray *switchKeys;
@property (nonatomic, retain) HistoryData *batteryHistory;

@end

