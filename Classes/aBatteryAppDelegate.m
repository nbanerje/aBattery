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

<<<<<<< HEAD
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
	
=======
- (void)applicationDidFinishLaunching:(UIApplication *)application {
>>>>>>> f235fa75b139b611a1541b68dd888d68ec0b3616
	
	tabController = [[UITabBarController alloc] init];
	
	MainViewController *mainViewController =  
	[[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	
	BatteryGraphViewController *graphViewController =  
	[[BatteryGraphViewController alloc] initWithNibName:@"BatteryGraphViewController" bundle:nil];
	
	graphViewController.view.frame = [UIScreen mainScreen].applicationFrame;	
<<<<<<< HEAD
	graphViewController.dataForPlot =  batteryHistory;
=======
	graphViewController.dataForPlot =  mainViewController.batteryHistory;
>>>>>>> f235fa75b139b611a1541b68dd888d68ec0b3616
	 
	HistoryViewController *historyViewController =  
	[[HistoryViewController alloc] initWithStyle:UITableViewStyleGrouped];
	historyViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	
	//Make connection for the History Data
<<<<<<< HEAD
	historyViewController.batteryHistory = batteryHistory;
=======
	historyViewController.batteryHistory = mainViewController.batteryHistory;
>>>>>>> f235fa75b139b611a1541b68dd888d68ec0b3616
	
	SettingsViewController *settingsViewController =  
	[[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	settingsViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	
	//Make connection for the settings dictionary
<<<<<<< HEAD
	settingsViewController.settingsDictionary = settingsDictionary;
	settingsViewController.switchKeys = switchKeys;
	
	//Make connection for the History Data
	settingsViewController.batteryHistory = batteryHistory;
=======
	settingsViewController.settingsDictionary = mainViewController.settingsDictionary;
	settingsViewController.switchKeys = mainViewController.switchKeys;
	
	//Make connection for the History Data
	settingsViewController.batteryHistory = mainViewController.batteryHistory;
>>>>>>> f235fa75b139b611a1541b68dd888d68ec0b3616
	
    
	
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
<<<<<<< HEAD
	 [batteryHistory saveDataToDisk];
=======
	 //[[NSUserDefaults standardUserDefaults] registerDefaults:mainViewController.userDefaults];
	 //[[NSUserDefaults standardUserDefaults] synchronize]; 
>>>>>>> f235fa75b139b611a1541b68dd888d68ec0b3616
}

- (void)dealloc {
	[window release];
<<<<<<< HEAD
	[settingsDictionary release];
	[battery release];
	[switchKeys release];
	[batteryHistory release];
=======
>>>>>>> f235fa75b139b611a1541b68dd888d68ec0b3616
    [super dealloc];
}



@end
