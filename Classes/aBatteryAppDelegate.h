//
//  aBatteryAppDelegate.h
//  aBattery
//
//  Created by Neel Banerjee on 3/26/09.
//  Copyright Om Design LLC 2009. All rights reserved.
//
<<<<<<< HEAD
#import "Battery.h"
#import "HistoryData.h"
=======
>>>>>>> f235fa75b139b611a1541b68dd888d68ec0b3616

@class MainViewController;

@interface aBatteryAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
<<<<<<< HEAD
    UITabBarController *tabController;
	
	NSMutableDictionary *settingsDictionary;
	Battery *battery;
	NSArray *switchKeys;
	HistoryData *batteryHistory;
=======
    //MainViewController *mainViewController;
	UITabBarController *tabController;
>>>>>>> f235fa75b139b611a1541b68dd888d68ec0b3616
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabController;
<<<<<<< HEAD
@property (nonatomic, retain) NSMutableDictionary *settingsDictionary;
@property (nonatomic, retain) Battery *battery;
@property (nonatomic, retain) NSArray *switchKeys;
@property (nonatomic, retain) HistoryData *batteryHistory;
=======
>>>>>>> f235fa75b139b611a1541b68dd888d68ec0b3616

@end

