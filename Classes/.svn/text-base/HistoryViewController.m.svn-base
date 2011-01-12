//
//  HistoryViewController.m
//  aBattery
//
//  Created by Neel Banerjee on 5/11/09.
//  Copyright 2009 Om Design LLC. All rights reserved.
//

#import "HistoryViewController.h"


@implementation HistoryViewController
@synthesize batteryHistory;
@synthesize toolbar;
- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		
		
		clearHistoryAlert = [[UIAlertView alloc]
							 initWithTitle:@"Clear History?" 
							 message:@"This will permenantly delete the battery history. This action is undoable." 
							 delegate:self 
							 cancelButtonTitle:@"Cancel" 
							 otherButtonTitles:@"Clear!",nil];
		clearHistoryAlert.tag = 0;
		
		mailHistoryAlert = [[UIAlertView alloc]
							 initWithTitle:@"Mail Status" 
							 message:nil
							 delegate:self 
							 cancelButtonTitle:nil 
							 otherButtonTitles:@"OK",nil];
		mailHistoryAlert.tag = 1;
		
		[[NSNotificationCenter defaultCenter] addObserver: self 
												 selector: @selector(updateTable) 
													 name:  UIDeviceBatteryLevelDidChangeNotification
												   object: [UIDevice currentDevice]];
		
		[[NSNotificationCenter defaultCenter] addObserver: self 
												 selector: @selector(updateTable) 
													 name: UIDeviceBatteryStateDidChangeNotification
												   object: [UIDevice currentDevice]];
		
		
	}
	return self;
}
-(void) setToolbarAndTable {
	self.tableView.allowsSelection = NO;
	if(self.toolbar == nil) {
		CGRect toolbarRect = CGRectMake(0, 0,  self.view.frame.size.width, 49);
		UIToolbar *aToolbar = [[UIToolbar alloc] initWithFrame:toolbarRect];
		self.toolbar = aToolbar;
		[aToolbar release];
		//[[self.view window] addSubview:toolbar];
		self.tableView.tableHeaderView = self.toolbar;
		//[window addSubview:toolbar];
		
		// Allows User to e-mail history
		UIBarButtonItem *mailHistory = [[UIBarButtonItem alloc] initWithTitle:@"E-mail History" style:UIBarButtonItemStyleBordered target:self action:@selector(emailHistory)];
		mailHistory.width = self.view.frame.size.width*0.58;
		mailHistory.tag = 0;
		// Allows the user to clear the history from the device permanently
		UIBarButtonItem *clearHistory = [[UIBarButtonItem alloc] initWithTitle:@"Clear History" style:UIBarButtonItemStyleBordered target:self action:@selector(clearHistory)];
		clearHistory.width = self.view.frame.size.width*(1-0.58)-20;
		clearHistory.tag = 1;
		if(![MFMailComposeViewController canSendMail]) {
			mailHistory.enabled = NO;
		}
		// Collect the items in a temporary array.
		NSArray *items = [NSArray arrayWithObjects:mailHistory, clearHistory, nil];
		[mailHistory release];
		[clearHistory release];
		
		// Pass the items to the toolbar.
		[toolbar setItems:items];
	}
	
}
-(void) emailHistory{
	[self displayComposerSheet];
}
// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	
	NSString *dateTime  =  [dateFormatter stringFromDate:[NSDate date]];
	[dateFormatter release];
	[picker setSubject:[NSString stringWithFormat:@"Battery History %@",dateTime]];
	
	// Attach an image to the email
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
    //NSData *myData = [NSData dataWithContentsOfFile:path];
	//[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
	
	// Add History Data to e-mail
	[picker addAttachmentData:[batteryHistory getCSVHistoryData] mimeType:@"text/csv" fileName:@"HistoryData.csv"];
	
	// Fill out the email body text
	NSString *emailBody = [NSString stringWithFormat:@"Here is your battery History as of: %@",dateTime];
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			mailHistoryAlert.title = @"Mail canceled!";
			break;
		case MFMailComposeResultSaved:
			mailHistoryAlert.title = @"Mail saved.";
			break;
		case MFMailComposeResultSent:
			mailHistoryAlert.title = @"Mail sent.";
			break;
		case MFMailComposeResultFailed:
			mailHistoryAlert.title = @"Mail failed. Sorry, check connection to Internet.";
			break;
		default:
			mailHistoryAlert.title= @"Mail not sent";
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
	[mailHistoryAlert show];
}

-(void) clearHistory{
	[clearHistoryAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView.tag == 0  && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Clear!"]) {
		[batteryHistory clearHistory];
		[self updateTable];
	}
	else if (alertView.tag == 1 && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"]){	
	    [mailHistoryAlert dismissWithClickedButtonIndex:0 animated:YES];
	}
}

-(void)updateTable {
	[batteryHistory updateSortedKeys];
	[self.tableView reloadData];
}
- (void)viewDidLoad {
	//NSLog(@"viewDidLoad");
    [super viewDidLoad];
    self.tabBarItem = [[UITabBarItem alloc] 
	 initWithTabBarSystemItem:UITabBarSystemItemHistory
	 tag:0];
	
	self.tabBarItem.title         = @"History";

}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self setToolbarAndTable];
	[self setToolbarSize];
	[batteryHistory updateSortedKeys];

	//NSLog(@"viewWillAppear");

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
	[super viewDidUnload];
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
		if([batteryHistory sortedKeyArray] == nil || [[batteryHistory sortedKeyArray] count] == 0) {
			//NSLog(@"nil or zero count");
			return 1;
		}
		else {
			//NSLog(@"count available");
		    return [[batteryHistory sortedKeyArray] count] ;
		}
	}
	else {
		return 0;
	}
	return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
	    if (cell == nil) {
		    cell = [[[UITableViewCell alloc] 
				 initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"HistoryCell"] autorelease];
		
		}
		else {
			//assert;
		}
	if([batteryHistory sortedKeyArray] == nil || [[batteryHistory sortedKeyArray] count] == 0) {
			cell.textLabel.text = @"No History Data Found.";
	}
    else {
	   	cell.textLabel.text = [NSString stringWithFormat:@"%d) %@",indexPath.row+1,[batteryHistory getDatePercentStateFromIndex:indexPath.row]];
	}
	
	//cell.textLabel.numberOfLines = 0;
	return cell; 
	
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	//NSLog(@"RotatedTable");
	[self setToolbarSize];
}

-(void)setToolbarSize {
	//NSLog(@"setToolbarSize");
	[self.toolbar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
	for(UIBarButtonItem *item in [toolbar items]) {
		if (item.tag == 0) {
			item.width = self.view.frame.size.width*0.58;
		}
		else if (item.tag == 1) {
			item.width = self.view.frame.size.width*(1-0.58) - 20;
		}
	}
}

- (void)dealloc {
	[clearHistoryAlert release];
	[mailHistoryAlert release];
	[super dealloc];
}


@end
