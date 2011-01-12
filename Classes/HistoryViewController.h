//
//  HistoryViewController.h
//  aBattery
//
//  Created by Neel Banerjee on 5/11/09.
//  Copyright 2009 Om Design LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryData.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface HistoryViewController: UITableViewController <UITableViewDataSource,
                                                         UIAlertViewDelegate,
                                                         MFMailComposeViewControllerDelegate>  {
	
	HistoryData *batteryHistory;
	UIToolbar *toolbar;
	
	UIAlertView *clearHistoryAlert;
	UIAlertView *mailHistoryAlert;
											
}

@property (retain, nonatomic) HistoryData *batteryHistory;
@property (retain, nonatomic) UIToolbar *toolbar;

-(void)updateTable;
-(void)displayComposerSheet;
-(void)setToolbarSize;
-(void)setToolbarAndTable;
@end
