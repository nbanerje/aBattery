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


@synthesize settingsDictionary;
@synthesize battery;
@synthesize switchKeys;
@synthesize batteryHistory;

- (void)applicationDidFinishLaunching:(UIApplication *)application {

	settingsDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
	
	//Initalize battery object
	battery        = [[Battery alloc] init];
	
	switchKeys = [[NSArray alloc] initWithObjects:@"Display Times",  @"Disable Sleep", @"20 Sample Max", nil];
		
	batteryHistory = [[HistoryData alloc] init];
	
	
	tabController = [[UITabBarController alloc] init];
	
	MainViewController *mainViewController =  
	[[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	
	BatteryGraphViewController *graphViewController =  
	[[BatteryGraphViewController alloc] initWithNibName:@"BatteryGraphViewController" bundle:nil];
	
	graphViewController.view.frame = [UIScreen mainScreen].applicationFrame;	
	graphViewController.dataForPlot =  batteryHistory;
	 
	HistoryViewController *historyViewController =  
	[[HistoryViewController alloc] initWithStyle:UITableViewStyleGrouped];
	historyViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	
	//Make connection for the History Data
	historyViewController.batteryHistory = batteryHistory;
	
	SettingsViewController *settingsViewController =  
	[[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	settingsViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	
	//Make connection for the settings dictionary
	settingsViewController.settingsDictionary = settingsDictionary;
	settingsViewController.switchKeys = switchKeys;
	
	//Make connection for the History Data
	settingsViewController.batteryHistory = batteryHistory;

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
	 [batteryHistory saveDataToDisk];

}

- (void)dealloc {
	[window release];
	[settingsDictionary release];
	[battery release];
	[switchKeys release];
	[batteryHistory release];
    [super dealloc];
}



@end
