//
//  SettingsViewController.m
//  aBattery
//
//  Created by Neel Banerjee on 5/18/09.
//  Copyright 2009 Om Design LLC. All rights reserved.
//

#import "SettingsViewController.h"
#import "SaveData.h"

@implementation SettingsViewController

@synthesize settingsDictionary;
@synthesize switchKeys;
@synthesize batteryHistory;
- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.tableView.allowsSelection = NO;
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    /*self.tabBarItem = [[UITabBarItem alloc] 
					   initWithTabBarSystemItem:UITabBarSystemItemMore
					   tag:0]; */
	self.tabBarItem.title         = @"Settings";
	self.tabBarItem.image	      = [UIImage imageNamed:@"setting_tab.png"];
	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait ||
			interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ||
			interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
			interfaceOrientation == UIInterfaceOrientationLandscapeRight
			);
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


////////////////////////////////////////
////   UITableDataSource methods  /////
//////////////////////////////////////

// Optional method, defaults to 1 if not implemented 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
	return 1;	
}
// Required method 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
	if(tableView == self.tableView) {
		return 3;
	}
	else {
		return 0;
	}
	return 0;
}
/*
Display Times: When ON, shows all time on battery tab. Default is OFF.
Disable Sleep: When ON, Keeps your iPhone / iPod Touch from going
 to sleep. This is helpful if you want to keep iBattery running
 and capturing data. Default: OFF 

 
===== NOT IMPLEMENTED ===== 
 
 Local Capture Only: If the battery capture feature is active 
 you can turn on Local capture only. By turning this on, you
 turn off the ability to send your battery data to our servers.
 If you do that then you won't get access to your latest battery
 levels online. Default: OFF
 
Reminders: If the battery capture feature is active you can turn
 off the reminders if you find them disturbing. Default: ON

Disable Sleep while Charging: When ON, Keeps your iPhone / iPod 
 Touch from going to sleep while your device is charging. Default: ON
*/
 - (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
	 if (cell == nil) {
		 cell = [[[UITableViewCell alloc] 
				  initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"ButtonCell"] autorelease]; 
		 if(cell.accessoryView == nil) {
			 if(indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
				 cell.accessoryView = [[[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
			     [(UISwitch*)cell.accessoryView addTarget:self action:@selector(switchToggled:event:) forControlEvents:UIControlEventValueChanged];
			 }
		 }
		 //Display Times
		 if (indexPath.section == 0 && indexPath.row == 0) {
			cell.textLabel.text = [switchKeys objectAtIndex:indexPath.row];
			 if(settingsDictionary != nil && [[settingsDictionary allKeys] containsObject:[switchKeys objectAtIndex:indexPath.row]]){
			    ((UISwitch*)cell.accessoryView).on = [(NSNumber*)[settingsDictionary objectForKey:[switchKeys objectAtIndex:indexPath.row]] boolValue];
			 }
			 else {
				 ((UISwitch*)cell.accessoryView).on = NO;
			 }
			 ((UISwitch*)cell.accessoryView).tag = indexPath.row;
		 }
		 //Disable Sleep
		 else if (indexPath.section == 0 && indexPath.row == 1) {
			 cell.textLabel.text = [switchKeys objectAtIndex:indexPath.row];
			 if(settingsDictionary != nil && [[settingsDictionary allKeys] containsObject:[switchKeys objectAtIndex:indexPath.row]]){
				 ((UISwitch*)cell.accessoryView).on = [(NSNumber*)[settingsDictionary objectForKey:[switchKeys objectAtIndex:indexPath.row]] boolValue];
			 }
			 else {
				 ((UISwitch*)cell.accessoryView).on = YES;
			 }
			 ((UISwitch*)cell.accessoryView).tag = indexPath.row;
		 }
		 //Max 20 samples
		 else if (indexPath.section == 0 && indexPath.row == 2) {
			 cell.textLabel.text = [switchKeys objectAtIndex:indexPath.row];
			 if(settingsDictionary != nil && [[settingsDictionary allKeys] containsObject:[switchKeys objectAtIndex:indexPath.row]]){
				 ((UISwitch*)cell.accessoryView).on = [(NSNumber*)[settingsDictionary objectForKey:[switchKeys objectAtIndex:indexPath.row]] boolValue];
			 }
			 else {
				 ((UISwitch*)cell.accessoryView).on = YES;
			 }
			 ((UISwitch*)cell.accessoryView).tag = indexPath.row;
		 }
		 else {
			 //assert;
		 }
	 }
     return cell; 
		
}
-(void) switchToggled:(UISwitch*) sender event:(UIControlEvents) event {
	//NSLog(@"In switchToggled");
	//NSLog([sender description]);
	//NSLog([NSString stringWithFormat:@"tag = %d",sender.tag]);
    [settingsDictionary setValue:[NSNumber numberWithBool:sender.on] forKey:[switchKeys objectAtIndex:sender.tag]];		
	if(sender.tag == 0) {
		//NSLog(@"Setting Display Times to %d",sender.on);
	}
	else if(sender.tag == 1) {
		//NSLog(@"Setting Disable Timer to %d",sender.on);
		[UIApplication sharedApplication].idleTimerDisabled = sender.on;
		//NSLog(@"Disable Timer is set to %d",[UIApplication sharedApplication].idleTimerDisabled);
		
	}
	else if(sender.tag == 2) {
		//NSLog(@"20 sample max");
		if(sender.on) {
			batteryHistory.maxEntries = 20;
		}
		else {
			batteryHistory.maxEntries = 0;
		}
	}

}

//////

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	NSString *line1 = [NSString stringWithFormat:@"Display Times: Shows all time remaining for Talk (iPhone Only), Internet, Audio, Video, and Standby usage on the Battery tab.\nDefault: OFF"];
    NSString *line2 = [NSString stringWithFormat:@"Disable Sleep: Setting this to ON disables the sleep function when this application is running."];
    NSString *line3 = [NSString stringWithFormat:@"This is particulary helpful when recording battery charge and discharge times.\nDefault: ON"];
	NSString *line4 = [NSString stringWithFormat:@"20 Sample Max: Setting this to ON will limit the total number of samples to 20. For each new sample added, the oldest sample will be deleted. Turn ON for faster response and performance. Set to OFF when capturing battery data for extended periods of time.\nDefault: ON"];
	return [NSString stringWithFormat:@"%@\n\n%@ %@\n\n%@",line1, line2,line3,line4];
}

- (void)dealloc {
	//[switchKeys        release];
	[super             dealloc];
}


@end
