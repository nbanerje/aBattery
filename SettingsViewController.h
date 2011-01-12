//
//  SettingsViewController.h
//  aBattery
//
//  Created by Neel Banerjee on 5/18/09.
//  Copyright 2009 Om Design LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryData.h"

@interface SettingsViewController : UITableViewController <UITableViewDataSource>  {

	NSMutableDictionary *settingsDictionary;
	NSArray *switchKeys;
	HistoryData *batteryHistory;
}

@property (retain, nonatomic) NSMutableDictionary *settingsDictionary;
@property (nonatomic, retain) NSArray *switchKeys;
@property (nonatomic, retain) HistoryData *batteryHistory;

//- (void) saveUserDefaults;
-(void) switchToggled:(UISwitch*) sender event:(UIControlEvents) event;
//-(void) buttonPressed:(UISwitch*) sender event:(UIControlEvents) event;

@end
