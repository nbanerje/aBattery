//
//  MainViewController.h
//  aBattery
//
//  Created by Neel Banerjee on 3/26/09.
//  Copyright Om Design LLC 2009. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CoreFoundation/CoreFoundation.h"
#import "aBatteryAppDelegate.h"
#import "MainViewController.h"
#import "MainView.h"
#import "Battery.h"
#import "HistoryData.h"

typedef enum {
	HIDE=0,
    SHOW_BATTERY_LEFT, 
	SHOW_BATTERY_TALK_TIME_3G, 
	SHOW_BATTERY_TALK_TIME_2G,
	SHOW_STANDBY_TIME,
	SHOW_INTERNET_3G_TIME,
	SHOW_INTERNET_WIFI_TIME,
	SHOW_VIDEO_TIME,
	SHOW_AUDIO_TIME,
    SHOW_BATTERY_STATE } BatteryStates;

@interface MainViewController : UIViewController <UITextFieldDelegate> {
	aBatteryAppDelegate *delegate;
	
	NSMutableDictionary *settingsDictionary;
	
	UILabel *batteryLabel;
	UILabel *batteryTimeLabel;
	UILabel *batteryStateLabel;
	UILabel *batteryTalkTime2GLabel;
	UILabel *batteryTalkTime3GLabel;
	UILabel *batteryStandbyTimeLabel;
	UILabel *batteryInternet3GTimeLabel;
	UILabel *batteryInternetWifiTimeLabel;
	UILabel *batteryVideoTimeLabel;
	UILabel *batteryAudioTimeLabel;
	
	//UIView  *allInfoView;
	UILabel *talk2G;
	UILabel *talk3G;
	UILabel *internet3G;
	UILabel *internetWifi;
	UILabel *audio;
	UILabel *video;
	UILabel *standby;
	
	UIView *batteryView;
	CALayer *batteryOutlineLayer;
	CALayer *batteryFillLayer;
	UIImage *batteryOutline;
	UIImage *batteryFillImage;
	
	UIImageView *reflectionView;
	
	CGFloat tabBarHeight;
	
	
	NSTimer *updateTimer;
	
	
    
	
	BatteryStates currentState;
	BatteryStates nextState;
	
	Battery *battery;
	
	NSArray *switchKeys;
	HistoryData *batteryHistory;
	BOOL loadedState;	
}

@property (nonatomic, retain) aBatteryAppDelegate *delegate;

@property (nonatomic, retain) IBOutlet UILabel *talk2G;
@property (nonatomic, retain) IBOutlet UILabel *talk3G;
@property (nonatomic, retain) IBOutlet UILabel *internet3G;
@property (nonatomic, retain) IBOutlet UILabel *internetWifi;
@property (nonatomic, retain) IBOutlet UILabel *audio;
@property (nonatomic, retain) IBOutlet UILabel *video;
@property (nonatomic, retain) IBOutlet UILabel *standby;

@property (nonatomic, retain) IBOutlet UILabel *batteryLabel;
@property (nonatomic, retain) IBOutlet UILabel *batteryTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *batteryStateLabel;

@property (nonatomic, retain) NSMutableDictionary *settingsDictionary;
@property (nonatomic, retain) NSArray *switchKeys;
@property (nonatomic, retain) HistoryData *batteryHistory;

@property (nonatomic, retain) UIView *batteryView;
@property (nonatomic, retain) CALayer *batteryOutlineLayer;
@property (nonatomic, retain) CALayer *batteryFillLayer;
@property (nonatomic, retain) UIImage *batteryOutline;
@property (nonatomic, retain) UIImage *batteryFillImage;

@property (nonatomic, retain) UIImageView *reflectionView;
-(void) batteryViewSetup;

-(void) setFrames;
-(void) hideBatteryLabelState;
-(void) showBatteryLabelState;
-(void) updateTime;
-(void) changeTimeTimer;

-(void) setUserPrefs;

-(void) setLandscapeView;
-(void) setPortraitView;

- (void) updateBatteryLabelState;
- (void) changeDisplay;
- (void) saveBatteryData;
- (void) saveUserDefaults;

-(NSString*) stringHMSFromHours:(double)hours;
-(void) showAllTimes;
-(void) hideAllTimes;

@end
