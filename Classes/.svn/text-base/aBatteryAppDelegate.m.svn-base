//
//  aBatteryAppDelegate.m
//  aBattery
//
//  Created by Neel Banerjee on 3/26/09.
//  Copyright Om Design LLC 2009. All rights reserved.
//

#import "aBatteryAppDelegate.h"
#import "MainViewController.h"
#import "BatteryGraphViewController.h"
#import "HistoryViewController.h"
#import "SettingsViewController.h"
@implementation aBatteryAppDelegate


@synthesize window;
@synthesize tabController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	tabController = [[UITabBarController alloc] init];
	
	MainViewController *mainViewController =  
	[[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	
	BatteryGraphViewController *graphViewController =  
	[[BatteryGraphViewController alloc] initWithNibName:@"BatteryGraphViewController" bundle:nil];
	
	graphViewController.view.frame = [UIScreen mainScreen].applicationFrame;	
	graphViewController.dataForPlot =  mainViewController.batteryHistory;
	 
	HistoryViewController *historyViewController =  
	[[HistoryViewController alloc] initWithStyle:UITableViewStyleGrouped];
	historyViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	
	//Make connection for the History Data
	historyViewController.batteryHistory = mainViewController.batteryHistory;
	
	SettingsViewController *settingsViewController =  
	[[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	settingsViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	
	//Make connection for the settings dictionary
	settingsViewController.settingsDictionary = mainViewController.settingsDictionary;
	settingsViewController.switchKeys = mainViewController.switchKeys;
	
	//Make connection for the History Data
	settingsViewController.batteryHistory = mainViewController.batteryHistory;
	
    
	
	NSArray *tabArray = [NSArray arrayWithObjects:mainViewController,
						                          graphViewController,
						                          historyViewController,
						                          settingsViewController,
						                          nil];
	
	[mainViewController release];
	[graphViewController release];
	[historyViewController release];
	[settingsViewController release];
	
	tabController.viewControllers = tabArray;
	[window addSubview:tabController.view];
	[window makeKeyAndVisible];
	
    
}
- (void)applicationWillTerminate:(UIApplication *)application {
	 [(MainViewController*)[tabController.viewControllers objectAtIndex:0]  saveUserDefaults];
	 //[[NSUserDefaults standardUserDefaults] registerDefaults:mainViewController.userDefaults];
	 //[[NSUserDefaults standardUserDefaults] synchronize]; 
}

- (void)dealloc {
	[window release];
    [super dealloc];
}



@end
