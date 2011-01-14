//
//  MainViewController.m
//  aBattery
//
//  Created by Neel Banerjee on 3/26/09.
//  Copyright Om Design LLC 2009. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "aBatteryAppDelegate.h"
#import "MainViewController.h"
#import "MainView.h"
#import "SaveData.h"
#import "HistoryData.h"

//#define batteryImageWidth 288*1.5
//#define batteryImageHeight 216*1.75

//Expand width by 50%
//Expand height by 75%

#define w 0.90
#define h 1
#define debug YES;

#define reflectionFraction 0.35
#define reflectionOpacity 0.5

@implementation MainViewController

@synthesize delegate;

@synthesize batteryLabel;
@synthesize batteryStateLabel;
@synthesize batteryTimeLabel;
@synthesize settingsDictionary;
@synthesize switchKeys;
@synthesize batteryHistory;

@synthesize talk2G;
@synthesize talk3G;
@synthesize internet3G;
@synthesize internetWifi;
@synthesize audio;
@synthesize video;
@synthesize standby;

//@synthesize allInfoView;

@synthesize batteryView;
@synthesize batteryOutlineLayer;
@synthesize batteryFillLayer;
@synthesize batteryOutline;
@synthesize batteryFillImage;
@synthesize reflectionView;
/////////////////////////////////////////
// SAVE DATA INFORMATION
/////////////////////////////////////////
// This view only saves the state information about what to 
// display inside of the battery upon application termination.
//   key: currentState
// All setting information is saved in the SettingsViewController
// upon application termination, but all off the settings are load here.
//   key: 
/////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        delegate = (aBatteryAppDelegate *)[[UIApplication sharedApplication]delegate];
		// Custom initialization
	    self.tabBarItem.image         = [UIImage imageNamed:@"battery_tab3.png"];
		self.tabBarItem.title         = @"Battery";
		
		//Connect battery to app delegate
		battery = delegate.battery;
		//Turn on notifications
		[battery on];
		
		batteryHistory = delegate.batteryHistory;
		
		//Setup notifications to update the display on a currentDevice change
		
		
		[[NSNotificationCenter defaultCenter] addObserver: self 
												 selector: @selector(changeDisplay) 
													 name: UIDeviceBatteryLevelDidChangeNotification
												   object: [UIDevice currentDevice]];
		
		[[NSNotificationCenter defaultCenter] addObserver: self 
												 selector: @selector(changeDisplay) 
													 name: UIDeviceBatteryStateDidChangeNotification
												   object: [UIDevice currentDevice]];
		
		[[NSNotificationCenter defaultCenter] addObserver: self 
												 selector: @selector(saveBatteryData) 
													 name:  UIDeviceBatteryLevelDidChangeNotification
												   object: [UIDevice currentDevice]];
		
		[[NSNotificationCenter defaultCenter] addObserver: self 
												 selector: @selector(saveBatteryData) 
													 name: UIDeviceBatteryStateDidChangeNotification
												   object: [UIDevice currentDevice]];
		//Initalize the batteryView
		
		batteryLabel                  = [[UILabel alloc] init];
		batteryTimeLabel              = [[UILabel alloc] init];
		batteryStateLabel             = [[UILabel alloc] init];
		batteryTalkTime2GLabel        = [[UILabel alloc] init];
		batteryTalkTime3GLabel        = [[UILabel alloc] init];
		batteryStandbyTimeLabel       = [[UILabel alloc] init];
		batteryInternet3GTimeLabel    = [[UILabel alloc] init];
		batteryInternetWifiTimeLabel  = [[UILabel alloc] init];
		batteryVideoTimeLabel         = [[UILabel alloc] init];
		batteryAudioTimeLabel         = [[UILabel alloc] init];
		settingsDictionary            = delegate.settingsDictionary;
		switchKeys                    = delegate.switchKeys;
	    loadedState                   = NO;
		
    }
	//
	return self;
}

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	 //NSLog(@"MainViewController::viewDidLoad");
	 NSDictionary *tmp;
	 NSNumber *currentStateNum;
	 tmp = [SaveData applicationPlistFromFile:@"Data.plist"];
	 currentStateNum = (NSNumber*)[tmp objectForKey:@"currentState"];

	 if (tmp != nil && currentStateNum != nil) {
		//NSLog(@"Loading setting dict");
		//reload current state
		currentState = [((NSNumber*)[tmp objectForKey:@"currentState"]) intValue];
		//NSLog([NSString stringWithFormat:@"currentState: %i",currentState]);
		[settingsDictionary addEntriesFromDictionary:tmp];
	 	 
	 }
	 else {
		 //NSLog(@"No Settings Found!");
		 currentState = 0;
	 }
	 
	 //[tmp release];
	 
	 
	 //[self batteryViewSetup];
     [self setUserPrefs];
	 
	 [self setFrames];
}
- (void) batteryViewSetup {
	if(batteryView == nil) {
		batteryView = [[UIView alloc] init];
	}
	else {
		[batteryView release];
		batteryView = [[UIView alloc] init];
	}
	tabBarHeight = ((aBatteryAppDelegate*)[UIApplication sharedApplication].delegate).tabController.tabBar.frame.size.height;
	
	batteryOutline                = [UIImage imageNamed:@"battery outline2.png"];
	//[batteryOutline retain];
	batteryOutlineLayer           = [CALayer layer];
	//[batteryOutlineLayer retain];
	batteryOutlineLayer.contents  = (UIImage *) batteryOutline.CGImage;
	batteryOutlineLayer.frame     = CGRectMake ((self.view.frame.size.width-[batteryOutline size].width*w)/2.0,
												(self.view.frame.size.height-tabBarHeight-[batteryOutline size].height*h)/2.0,
												[batteryOutline size].width*w,
												[batteryOutline size].height*h);
	
	[batteryView.layer addSublayer:batteryOutlineLayer];
	//batteryOutlineLayer.backgroundColor = [UIColor clearColor].CGColor;
	
	batteryFillImage             = [UIImage imageNamed:@"battery green fill2.png"];
	//[batteryFillImage retain];
	batteryFillLayer             = [CALayer layer];
	//[batteryFillLayer retain];
	batteryFillLayer.anchorPoint = CGPointMake(0,0.5);
	batteryFillLayer.frame       = CGRectMake ((self.view.frame.size.width-[batteryFillImage size].width*w)/2.0,
											   (self.view.frame.size.height-tabBarHeight-[batteryFillImage size].height*h)/2.0,
											   [batteryFillImage size].width*w,
											   [batteryFillImage size].height*h);
	
	
	//[batteryView.layer insertSublayer:batteryFillLayer above:batteryOutlineLayer];
	[batteryView.layer insertSublayer:batteryFillLayer below:batteryOutlineLayer];
	//[batteryView.layer insertSublayer:batteryFillLayer above:batteryOutlineLayer];
	batteryView.layer.anchorPoint = CGPointMake(0.0,0.5);
	
	batteryLabel.frame                 = batteryOutlineLayer.frame;
	batteryTimeLabel.frame             = batteryOutlineLayer.frame;
	batteryStateLabel.frame            = batteryOutlineLayer.frame;
	batteryTalkTime2GLabel.frame       = batteryOutlineLayer.frame;
	batteryTalkTime3GLabel.frame       = batteryOutlineLayer.frame;
	batteryStandbyTimeLabel.frame      = batteryOutlineLayer.frame;
	batteryInternet3GTimeLabel.frame   = batteryOutlineLayer.frame;
	batteryInternetWifiTimeLabel.frame = batteryOutlineLayer.frame;
	batteryVideoTimeLabel.frame        = batteryOutlineLayer.frame;
	batteryAudioTimeLabel.frame        = batteryOutlineLayer.frame;   
	
	batteryLabel.textAlignment                 = UITextAlignmentCenter;
	batteryTimeLabel.textAlignment             = UITextAlignmentCenter;
	batteryStateLabel.textAlignment            = UITextAlignmentCenter;
	batteryTalkTime2GLabel.textAlignment       = UITextAlignmentCenter;
	batteryTalkTime3GLabel.textAlignment       = UITextAlignmentCenter;
	batteryStandbyTimeLabel.textAlignment      = UITextAlignmentCenter;
	batteryInternet3GTimeLabel.textAlignment   = UITextAlignmentCenter;
	batteryInternetWifiTimeLabel.textAlignment = UITextAlignmentCenter;
	batteryVideoTimeLabel.textAlignment        = UITextAlignmentCenter;
	batteryAudioTimeLabel.textAlignment        = UITextAlignmentCenter;  
	
	batteryLabel.textColor                     = [UIColor darkGrayColor];
	batteryTimeLabel.textColor                 = [UIColor darkGrayColor];
	batteryStateLabel.textColor                = [UIColor darkGrayColor];
	batteryTalkTime2GLabel.textColor           = [UIColor darkGrayColor];
	batteryTalkTime3GLabel.textColor           = [UIColor darkGrayColor];
	batteryStandbyTimeLabel.textColor          = [UIColor darkGrayColor];
	batteryInternet3GTimeLabel.textColor       = [UIColor darkGrayColor];
	batteryInternetWifiTimeLabel.textColor     = [UIColor darkGrayColor];
	batteryVideoTimeLabel.textColor            = [UIColor darkGrayColor];
	batteryAudioTimeLabel.textColor            = [UIColor darkGrayColor];
	
	batteryLabel.backgroundColor      = [UIColor colorWithWhite:0 alpha:0];
	batteryTimeLabel.backgroundColor  = [UIColor colorWithWhite:0 alpha:0];
	batteryStateLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
	batteryTalkTime2GLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
	batteryTalkTime3GLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
	batteryStandbyTimeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
	batteryInternet3GTimeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
	batteryInternetWifiTimeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
	batteryVideoTimeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
	batteryAudioTimeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0]; 
	
	[batteryView insertSubview:batteryLabel aboveSubview:batteryView];
	[batteryView insertSubview:batteryTimeLabel aboveSubview:batteryView];
	[batteryView insertSubview:batteryStateLabel aboveSubview:batteryView];
	[batteryView insertSubview:batteryTalkTime2GLabel aboveSubview:batteryView];
	[batteryView insertSubview:batteryTalkTime3GLabel aboveSubview:batteryView];
	[batteryView insertSubview:batteryStandbyTimeLabel aboveSubview:batteryView];
	[batteryView insertSubview:batteryInternet3GTimeLabel aboveSubview:batteryView];
	[batteryView insertSubview:batteryInternetWifiTimeLabel aboveSubview:batteryView];
	[batteryView insertSubview:batteryVideoTimeLabel aboveSubview:batteryView];
	[batteryView insertSubview:batteryAudioTimeLabel aboveSubview:batteryView];
		
	[self.view addSubview:batteryView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [batteryView removeFromSuperview];
}

-(void) viewWillAppear:(BOOL)animated {
	//NSLog(@"MainViewController::View Will Appear");
	[self batteryViewSetup];
	[self setFrames];
	[self setUserPrefs];
	
}

-(void) setUserPrefs {
	//Setup idle timer disable
	if(settingsDictionary != nil && [[settingsDictionary allKeys] containsObject:[switchKeys objectAtIndex:1]]){
		[UIApplication sharedApplication].idleTimerDisabled = [(NSNumber*)[settingsDictionary objectForKey:[switchKeys objectAtIndex:1]] boolValue];
		//NSLog(@"Idle timer loaded from settings: %d",[UIApplication sharedApplication].idleTimerDisabled);
	}
	else {
		[UIApplication sharedApplication].idleTimerDisabled = YES;
		[settingsDictionary setObject:[NSNumber numberWithBool:YES] forKey:[switchKeys objectAtIndex:1]];
	}
	//Setup "All Times"
	if(settingsDictionary != nil && [[settingsDictionary allKeys] containsObject:[switchKeys objectAtIndex:0]]){
		if([(NSNumber*)[settingsDictionary objectForKey:[switchKeys objectAtIndex:0]] boolValue])
			[self showAllTimes];
		else
			[self hideAllTimes];
	}
	else {
		[self hideAllTimes];
	}
	//Setup "20 max Samples"
	if(settingsDictionary != nil && [[settingsDictionary allKeys] containsObject:[switchKeys objectAtIndex:2]]){
		if([(NSNumber*)[settingsDictionary objectForKey:[switchKeys objectAtIndex:2]] boolValue])
			batteryHistory.maxEntries = 20;
		else
			batteryHistory.maxEntries = 0;
	}
	else {
		batteryHistory.maxEntries = 20;
	}
	//This has to be done after the maxEntries is set
	if(!loadedState) {
		[self saveBatteryData];
		//NSLog(@"Loaded Battery info on 1st entry");
		loadedState = YES;
	}
	
}
-(void) viewDidAppear:(BOOL)animated {
	//NSLog(@"MainViewController::View Did Appear");
	
   	UIDeviceOrientation interfaceOrientation = self.interfaceOrientation;
	if ( interfaceOrientation == UIDeviceOrientationPortrait ||
	     interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
	    [self setPortraitView];
	}
	else if (interfaceOrientation == UIDeviceOrientationLandscapeLeft ||
			 interfaceOrientation == UIDeviceOrientationLandscapeRight) {
	    [self setLandscapeView];
	}
	else {
	   //Do nothing for all other cases.
	}
	//[self setFrames];
	[self changeDisplay];
}
-(void)setFrames {
	[self updateBatteryLabelState];
    [self changeDisplay];
	[self changeTimeTimer];
	
}
 
-(void)changeTimeTimer {
	
	updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self 
												 selector:@selector(updateTime) userInfo:nil repeats:YES];
}


-(void)updateTime {
	//Get Date
	CFGregorianDate date =  CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent (),
														   CFTimeZoneCopyDefault ());
	NSString *batteryTimeString = [NSString stringWithFormat:@"%d:%02.2d:%02.0f", 
			                       date.hour%12,date.minute,date.second
								   ];
	batteryTimeLabel.text = batteryTimeString;
}
-(NSString*) stringHMSFromHours:(double)hours {
	float hoursRes = hours - (int)hours;
	float min      = hoursRes * 60.0;
	//float minRes   = min - (int)min;
	//int sec      = minRes * 60.0;
	//NSLog(@"hours, hoursRes, min, minRes, sec");
	//NSLog([NSString stringWithFormat:@"%f %f %f %f %d",hours,hoursRes,min,minRes,sec]);
   	return [NSString stringWithFormat:@"%2.0f:%02.0f",hours,min];
}


-(IBAction) changeDisplay {
	
	float batLeft = battery.percentLeft;
	
	NSString *batteryStateString = battery.batteryState;
	
	NSString *batteryTalkTime2GHMS            = [self stringHMSFromHours:[battery.talkTime2G doubleValue] * batLeft];
	NSString *batteryTalkTime3GHMS            = [self stringHMSFromHours:[battery.talkTime3G doubleValue] * batLeft];
	NSString *batteryStandbyTimeLabelHMS      = [self stringHMSFromHours:[battery.standbyTime doubleValue] * batLeft];
	NSString *batteryInternet3GTimeLabelHMS   = [self stringHMSFromHours:[battery.internet3G doubleValue] * batLeft];
	NSString *batteryInternetWifiTimeLabelHMS = [self stringHMSFromHours:[battery.internetWifi doubleValue] * batLeft];
	NSString *batteryVideoTimeLabelHMS        = [self stringHMSFromHours:[battery.videoTime doubleValue] * batLeft];
	NSString *batteryAudioTimeLabelHMS        = [self stringHMSFromHours:[battery.audioTime doubleValue] * batLeft];
	
	
	
	NSString *batteryLeftString = [NSString stringWithFormat:@"%.0f%%",batLeft*100];
	batteryLabel.text = batteryLeftString;
	batteryStateLabel.text = batteryStateString;
	batteryTalkTime2GLabel.text = [NSString stringWithFormat:@"Talk 2G %@ ",batteryTalkTime2GHMS];
	batteryTalkTime3GLabel.text = [NSString stringWithFormat:@"Talk 3G %@ ",batteryTalkTime3GHMS];
	batteryStandbyTimeLabel.text = [NSString stringWithFormat:@"Standby %@ ",batteryStandbyTimeLabelHMS];
	batteryInternet3GTimeLabel.text= [NSString stringWithFormat:@"Internet 3G %@ ",batteryInternet3GTimeLabelHMS];
	batteryInternetWifiTimeLabel.text= [NSString stringWithFormat:@"Wifi %@ ",batteryInternetWifiTimeLabelHMS];
	batteryVideoTimeLabel.text = [NSString stringWithFormat:@"Video %@ ",batteryVideoTimeLabelHMS];
	batteryAudioTimeLabel.text = [NSString stringWithFormat:@"Audio %@ ",batteryAudioTimeLabelHMS];
	
	talk2G.text       = batteryTalkTime2GHMS;
	talk3G.text       = batteryTalkTime3GHMS;
	internet3G.text   = batteryInternet3GTimeLabelHMS;
	internetWifi.text = batteryInternetWifiTimeLabelHMS;
	audio.text        = batteryAudioTimeLabelHMS;
	video.text        = batteryVideoTimeLabelHMS;
	standby.text      = batteryStandbyTimeLabelHMS;	
	
	
	float myLevel=batLeft;	
	//[batteryFillImage release];
	if(myLevel>0.5)
		batteryFillImage  = [UIImage imageNamed:@"battery green fill2.png"];
    else if(myLevel<=0.5 && myLevel>0.25)
		batteryFillImage  = [UIImage imageNamed:@"battery yellow fill2.png"];
	else
		batteryFillImage     = [UIImage imageNamed:@"battery red fill2.png"];
	//[batteryFillImage retain];
	batteryFillLayer.contents = (UIImage *)batteryFillImage.CGImage;
	
	
	
	batteryFillLayer.bounds =			CGRectMake (
											0,
											0,
											myLevel* [batteryFillImage size].width*w,
											[batteryFillImage size].height*h
											);
	batteryFillLayer.contentsRect	=	CGRectMake (
											0,
											0,
											myLevel,
											1.0
											);

	
}	

- (void) saveBatteryData {
	float batLeft = battery.percentLeft;
	NSString *batteryStateString = battery.batteryState;
	[batteryHistory setBatteryLevel:batLeft batteryState:batteryStateString];
    [batteryHistory saveDataToDisk];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	//[batteryView removeFromSuperview];
	[self hideBatteryLabelState];
	
}
-(void) setPortraitView {
	//NSLog(@"setPortraitView");
	batteryFillLayer.frame = CGRectMake ((self.view.frame.size.width-[batteryFillImage size].width*w)/2.0,
										 (self.view.frame.size.height-[batteryFillImage size].height*h)/2.0,
										 [batteryFillImage size].width*w,
										 [batteryFillImage size].height*h);
	batteryOutlineLayer.frame = CGRectMake ((self.view.frame.size.width-[batteryOutline size].width*w)/2.0,
											(self.view.frame.size.height-[batteryOutline size].height*h)/2.0,
											[batteryOutline size].width*w,
											[batteryOutline size].height*h);
	batteryLabel.frame      = batteryOutlineLayer.frame;
	batteryTimeLabel.frame  = batteryOutlineLayer.frame;
	batteryStateLabel.frame = batteryOutlineLayer.frame;
	batteryTalkTime2GLabel.frame       = batteryOutlineLayer.frame;
	batteryTalkTime3GLabel.frame       = batteryOutlineLayer.frame;
	batteryStandbyTimeLabel.frame      = batteryOutlineLayer.frame;
	batteryInternet3GTimeLabel.frame   = batteryOutlineLayer.frame;
	batteryInternetWifiTimeLabel.frame = batteryOutlineLayer.frame;
	batteryVideoTimeLabel.frame        = batteryOutlineLayer.frame;
	batteryAudioTimeLabel.frame        = batteryOutlineLayer.frame;   
}
-(void) setLandscapeView {
	//NSLog(@"setLandscapeView");
	batteryFillLayer.frame = CGRectMake ((self.view.frame.size.width-[batteryFillImage size].width*w)/2.0,
										 (self.view.frame.size.height-[batteryFillImage size].height*h)/2.0,
										 [batteryFillImage size].width*w,
										 [batteryFillImage size].height*h);
	batteryOutlineLayer.frame = CGRectMake ((self.view.frame.size.width-[batteryOutline size].width*w)/2.0,
											(self.view.frame.size.height-[batteryOutline size].height*h)/2.0,
											[batteryOutline size].width*w,
											[batteryOutline size].height*h);
	batteryLabel.frame      = batteryOutlineLayer.frame;
	batteryTimeLabel.frame  = batteryOutlineLayer.frame;
	batteryStateLabel.frame = batteryOutlineLayer.frame;
	batteryTalkTime2GLabel.frame       = batteryOutlineLayer.frame;
	batteryTalkTime3GLabel.frame       = batteryOutlineLayer.frame;
	batteryStandbyTimeLabel.frame      = batteryOutlineLayer.frame;
	batteryInternet3GTimeLabel.frame   = batteryOutlineLayer.frame;
	batteryInternetWifiTimeLabel.frame = batteryOutlineLayer.frame;
	batteryVideoTimeLabel.frame        = batteryOutlineLayer.frame;
	batteryAudioTimeLabel.frame        = batteryOutlineLayer.frame;   
}
// Sent to the view controller after autorotation ends.
// When this method is invoked, the interfaceOrientation property is set to the new orientation. 
// The old orientation is passed as an argument to this method.


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
   tabBarHeight = ((aBatteryAppDelegate*)[UIApplication sharedApplication].delegate).tabController.tabBar.frame.size.height;
	
	if(self.interfaceOrientation == UIInterfaceOrientationPortrait ||
	   self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
		//[self batteryViewSetup];
		[self setPortraitView];
	}
	else if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
	        self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
		//[self batteryViewSetup];
		[self setLandscapeView];
	}

	[self showBatteryLabelState];
	//Update the fills
	[self changeDisplay];
	
}
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    /*UITouch       *touch = [touches anyObject];
	NSLog([[touch view] description]);
	if([touch view] == batteryView) {
        currentState = nextState;
		[self updateBatteryLabelState];
		
		//NSLog([[touch view] description]);
    }*/
	
		
	CGPoint location = [[touches anyObject] locationInView:self.view];
    CALayer *hitLayer = [[self.view layer] hitTest:[self.view convertPoint:location fromView:self.view]];
	
    if (hitLayer == batteryView.layer || hitLayer == batteryOutlineLayer ||
		hitLayer == batteryFillLayer  || hitLayer == batteryLabel.layer  || 
		hitLayer == batteryTimeLabel.layer || hitLayer == batteryStateLabel.layer ||
		hitLayer == batteryTalkTime2GLabel.layer ||
		hitLayer == batteryTalkTime3GLabel.layer ||
		hitLayer == batteryStandbyTimeLabel.layer ||
		hitLayer == batteryInternet3GTimeLabel.layer ||
		hitLayer == batteryInternetWifiTimeLabel.layer ||
		hitLayer == batteryVideoTimeLabel.layer ||
		hitLayer == batteryAudioTimeLabel.layer  ) {
		currentState = nextState;
		
		[self updateBatteryLabelState];

    }
}
/*
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	
	if(
        currentState = nextState;
		[self updateBatteryLabelState];
}
*/
- (void)updateBatteryLabelState {
	
	//NSLog(@"In update battery");
	batteryLabel.hidden = YES;
	batteryTimeLabel. hidden = YES;	
	batteryStateLabel.hidden = YES;
	batteryTalkTime2GLabel.hidden = YES;
	batteryTalkTime3GLabel.hidden = YES;
	batteryStandbyTimeLabel.hidden = YES;
	batteryInternet3GTimeLabel.hidden = YES;
	batteryInternetWifiTimeLabel.hidden = YES;
	batteryVideoTimeLabel.hidden = YES;
	batteryAudioTimeLabel.hidden = YES;
	if([[battery deviceName] isEqualToString:@"iPhone 3G"] || [[battery deviceName] isEqualToString:@"iPhone 3GS"]) {
		//NSLog(@"iPhone");
		switch (currentState) {
			case HIDE:
				nextState = SHOW_BATTERY_LEFT;
				break;
			case SHOW_BATTERY_LEFT:
				batteryLabel.hidden = NO;
				nextState = SHOW_BATTERY_TALK_TIME_3G;
				break;
			
			case SHOW_BATTERY_TALK_TIME_3G:
				batteryTalkTime3GLabel.hidden = NO;
				nextState = SHOW_BATTERY_TALK_TIME_2G;
				break;
				
			case SHOW_BATTERY_TALK_TIME_2G:
				batteryTalkTime2GLabel.hidden = NO;
				nextState = SHOW_STANDBY_TIME;
				break;
				
			case SHOW_STANDBY_TIME:
				batteryStandbyTimeLabel.hidden = NO;
				nextState = SHOW_INTERNET_3G_TIME;
				break;
				
			case SHOW_INTERNET_3G_TIME:
				batteryInternet3GTimeLabel.hidden = NO;
				nextState = SHOW_INTERNET_WIFI_TIME;
				break;
				
			case SHOW_INTERNET_WIFI_TIME:
				batteryInternetWifiTimeLabel.hidden = NO;
				nextState = SHOW_VIDEO_TIME;
				break;
				
			case SHOW_VIDEO_TIME:
				batteryVideoTimeLabel.hidden = NO;
				nextState = SHOW_AUDIO_TIME;
				break;
			
			case SHOW_AUDIO_TIME:
				batteryAudioTimeLabel.hidden = NO;
				nextState = SHOW_BATTERY_STATE;
				break;
			
			case SHOW_BATTERY_STATE:
				batteryStateLabel.hidden = NO;
				nextState = HIDE;
				break;
				
			default:
				nextState = HIDE;
				break;
		}
		
	}
	else if([[battery deviceName] isEqualToString:@"iPhone 1G"])
		switch (currentState) {
			case HIDE:
				nextState = SHOW_BATTERY_LEFT;
				break;
			case SHOW_BATTERY_LEFT:
				batteryLabel.hidden = NO;
				nextState = SHOW_BATTERY_TALK_TIME_2G;
				break;
				
			case SHOW_BATTERY_TALK_TIME_2G:
				batteryTalkTime2GLabel.hidden = NO;
				nextState = SHOW_STANDBY_TIME;
				break;
				
			case SHOW_STANDBY_TIME:
				batteryStandbyTimeLabel.hidden = NO;
				nextState = SHOW_INTERNET_WIFI_TIME;
				break;
				
			case SHOW_INTERNET_WIFI_TIME:
				batteryInternetWifiTimeLabel.hidden = NO;
				nextState = SHOW_VIDEO_TIME;
				break;
				
			case SHOW_VIDEO_TIME:
				batteryVideoTimeLabel.hidden = NO;
				nextState = SHOW_AUDIO_TIME;
				break;
				
			case SHOW_AUDIO_TIME:
				batteryAudioTimeLabel.hidden = NO;
				nextState = SHOW_BATTERY_STATE;
				break;
				
			case SHOW_BATTERY_STATE:
				batteryStateLabel.hidden = NO;
				nextState = HIDE;
				break;
				
			default:
				nextState = HIDE;
				break;
		}
	else if([[battery deviceName] isEqualToString:@"iPod Touch 1G"] || [[battery deviceName] isEqualToString:@"iPod Touch 2G"]) {
		//NSLog(@"iPod");
		switch (currentState) {
			case HIDE:
				nextState = SHOW_BATTERY_LEFT;
				break;
				
			case SHOW_BATTERY_LEFT:
				batteryLabel.hidden = NO;
				nextState = SHOW_INTERNET_WIFI_TIME;
				break;
				
			case SHOW_INTERNET_WIFI_TIME:
				batteryInternetWifiTimeLabel.hidden = NO;
				nextState = SHOW_VIDEO_TIME;
				break;
				
			case SHOW_VIDEO_TIME:
				batteryVideoTimeLabel.hidden = NO;
				nextState = SHOW_AUDIO_TIME;
				break;
				
			case SHOW_AUDIO_TIME:
				batteryAudioTimeLabel.hidden = NO;
				nextState = SHOW_BATTERY_STATE;
				break;
				
			case SHOW_BATTERY_STATE:
				batteryStateLabel.hidden = NO;
				nextState = HIDE;
				break;
				
			default:
				nextState = HIDE;
				break;
		}
	}
	else {
		//NSLog(@"else");
		switch (currentState) {
			case HIDE:
				nextState = SHOW_BATTERY_LEFT;
				break;
			case SHOW_BATTERY_LEFT:
				batteryLabel.hidden = NO;
				nextState = SHOW_BATTERY_TALK_TIME_3G;
				break;
				
			case SHOW_BATTERY_TALK_TIME_3G:
				batteryTalkTime3GLabel.hidden = NO;
				nextState = SHOW_BATTERY_TALK_TIME_2G;
				break;
				
			case SHOW_BATTERY_TALK_TIME_2G:
				batteryTalkTime2GLabel.hidden = NO;
				nextState = SHOW_STANDBY_TIME;
				break;
				
			case SHOW_STANDBY_TIME:
				batteryStandbyTimeLabel.hidden = NO;
				nextState = SHOW_INTERNET_3G_TIME;
				break;
				
			case SHOW_INTERNET_3G_TIME:
				batteryInternet3GTimeLabel.hidden = NO;
				nextState = SHOW_INTERNET_WIFI_TIME;
				break;
				
			case SHOW_INTERNET_WIFI_TIME:
				batteryInternetWifiTimeLabel.hidden = NO;
				nextState = SHOW_VIDEO_TIME;
				break;
				
			case SHOW_VIDEO_TIME:
				batteryVideoTimeLabel.hidden = NO;
				nextState = SHOW_AUDIO_TIME;
				break;
				
			case SHOW_AUDIO_TIME:
				batteryAudioTimeLabel.hidden = NO;
				nextState = SHOW_BATTERY_STATE;
				break;
				
			case SHOW_BATTERY_STATE:
				batteryStateLabel.hidden = NO;
				nextState = HIDE;
				break;
				
			default:
				nextState = HIDE;
				break;
		}
	}
	/*
	if (currentState == HIDE) {
		//Next state it to show the battery left amount
		//batteryLabel.hidden = YES;
		//batteryTimeLabel. hidden = YES;	
		//batteryStateLabel.hidden = YES;
		nextState = SHOW_BATTERY_LEFT;
	}
	else if (currentState == SHOW_BATTERY_LEFT) {
		//Next state is to show the time remaining for the battery
		batteryLabel.hidden = NO;
		//batteryTimeLabel. hidden = YES;
		//batteryStateLabel.hidden = YES;
		nextState = SHOW_BATTERY_TIME;
	}
	else if (currentState == SHOW_BATTERY_TIME) {
		//batteryLabel.hidden = YES;
		batteryTimeLabel.hidden = NO;
		//batteryStateLabel.hidden = YES;
		nextState = SHOW_BATTERY_STATE;
	}
	else if (currentState == SHOW_BATTERY_STATE) {
		//batteryLabel.hidden = YES;
		//batteryTimeLabel.hidden = YES;
		batteryStateLabel.hidden = NO;
		nextState = HIDE;
	}
	else {
		//Unknown State
		//batteryLabel.hidden = YES;
		//batteryTimeLabel. hidden = YES;	
		//batteryStateLabel.hidden = YES;
		nextState = SHOW_BATTERY_LEFT;
	}*/
	[self.view setNeedsDisplay];
}
- (void)hideBatteryLabelState {
	/*
	if (currentState == SHOW_BATTERY_LEFT)
		//Next state is to show the time remaining for the battery
		batteryLabel.hidden = YES;
	else if (currentState == SHOW_BATTERY_TIME) 
		batteryTimeLabel.hidden = YES;
	else if (currentState == SHOW_BATTERY_STATE)
		batteryStateLabel.hidden = YES;
	*/
	switch (currentState) {
		case SHOW_BATTERY_LEFT:
			batteryLabel.hidden = YES;
			break;
			
		case SHOW_BATTERY_TALK_TIME_3G:
			batteryTalkTime3GLabel.hidden = YES;
			break;
			
		case SHOW_BATTERY_TALK_TIME_2G:
			batteryTalkTime2GLabel.hidden = YES;
			break;
			
		case SHOW_STANDBY_TIME:
			batteryStandbyTimeLabel.hidden = YES;
			break;
			
		case SHOW_INTERNET_3G_TIME:
			batteryInternet3GTimeLabel.hidden = YES;
			break;
			
		case SHOW_INTERNET_WIFI_TIME:
			batteryInternetWifiTimeLabel.hidden = YES;
			break;
			
		case SHOW_VIDEO_TIME:
			batteryVideoTimeLabel.hidden = YES;
			break;
			
		case SHOW_AUDIO_TIME:
			batteryAudioTimeLabel.hidden = YES;
			break;
		
		case SHOW_BATTERY_STATE:
			batteryStateLabel.hidden = YES;
			break;
	}
	[self.view setNeedsDisplay];
}
- (void)showBatteryLabelState {
	/*if (currentState == SHOW_BATTERY_LEFT)
		//Next state is to show the time remaining for the battery
		batteryLabel.hidden = NO;
	else if (currentState == SHOW_BATTERY_TIME)
		batteryTimeLabel.hidden = NO;
	else if (currentState == SHOW_BATTERY_STATE)
		batteryStateLabel.hidden = NO;*/
	
	switch (currentState) {
		case SHOW_BATTERY_LEFT:
			batteryLabel.hidden = NO;
			break;
			
		case SHOW_BATTERY_TALK_TIME_3G:
			batteryTalkTime3GLabel.hidden = NO;
			break;
			
		case SHOW_BATTERY_TALK_TIME_2G:
			batteryTalkTime2GLabel.hidden = NO;
			break;
			
		case SHOW_STANDBY_TIME:
			batteryStandbyTimeLabel.hidden = NO;
			break;
			
		case SHOW_INTERNET_3G_TIME:
			batteryInternet3GTimeLabel.hidden = NO;
			break;
			
		case SHOW_INTERNET_WIFI_TIME:
			batteryInternetWifiTimeLabel.hidden = NO;
			break;
			
		case SHOW_VIDEO_TIME:
			batteryVideoTimeLabel.hidden = NO;
			break;

		case SHOW_AUDIO_TIME:
			batteryAudioTimeLabel.hidden = NO;
			break;
			
		case SHOW_BATTERY_STATE:
			batteryStateLabel.hidden = NO;
			break;
	}
	[self.view setNeedsDisplay];
}

-(void) showAllTimes {
	if(battery != nil) {
		if([[battery deviceName] isEqualToString:@"iPhone 3G"] || [[battery deviceName] isEqualToString:@"iPhone 3GS"]) {
			for(NSInteger i = 1; i <= 9; i++) {
			   ((UILabel*)[self.view viewWithTag:i]).hidden = NO;
			}
			talk2G.hidden       = NO;
			talk3G.hidden       = NO;
			internet3G.hidden   = NO;
			internetWifi.hidden = NO;
			audio.hidden        = NO;
			video.hidden        = NO;
			standby.hidden      = NO;
		}
		else if([[battery deviceName] isEqualToString:@"iPhone 1G"]) {
			for(NSInteger i = 1; i <= 9; i++) {
				if(i==5 || i==6)
					((UILabel*)[self.view viewWithTag:i]).hidden = YES;
				else
					((UILabel*)[self.view viewWithTag:i]).hidden = NO;
			}
			talk2G.hidden       = NO;
			talk3G.hidden       = YES;
			internet3G.hidden   = YES;
			internetWifi.hidden = NO;
			audio.hidden        = NO;
			video.hidden        = NO;
			standby.hidden      = NO;
		}
			
		else if([[battery deviceName] isEqualToString:@"iPod Touch 1G"] || [[battery deviceName] isEqualToString:@"iPod Touch 2G"]) {
			for(NSInteger i = 1; i <= 9; i++) {
				if(i==5 || i==6 || i==1 || i==2 || i==5 || i==6)
					((UILabel*)[self.view viewWithTag:i]).hidden = YES;
				else
					((UILabel*)[self.view viewWithTag:i]).hidden = NO;
			}
			talk2G.hidden       = YES;
			talk3G.hidden       = YES;
			internet3G.hidden   = YES;
			internetWifi.hidden = NO;
			audio.hidden        = NO;
			video.hidden        = NO;
			standby.hidden      = NO;
		}
		else {
			for(NSInteger i = 1; i <= 9; i++) {
				((UILabel*)[self.view viewWithTag:i]).hidden = NO;
			}
			talk2G.hidden       = NO;
			talk3G.hidden       = NO;
			internet3G.hidden   = NO;
			internetWifi.hidden = NO;
			audio.hidden        = NO;
			video.hidden        = NO;
			standby.hidden      = NO;
		}
	}
}

-(void) hideAllTimes {
	for(int i = 1; i <= 9; i++) {
		((UILabel*)[self.view viewWithTag:i]).hidden = YES;
	}
	talk2G.hidden       = YES;
	talk3G.hidden       = YES;
	internet3G.hidden   = YES;
	internetWifi.hidden = YES;
	audio.hidden        = YES;
	video.hidden        = YES;
	standby.hidden      = YES;
	
}

- (void) saveUserDefaults {
	[settingsDictionary setObject:[NSNumber numberWithInt:currentState] forKey:@"currentState"];
	[SaveData writeApplicationPlist:settingsDictionary toFile:@"Data.plist"];
	[batteryHistory saveDataToDisk]; 
}	

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[batteryView release];
	[batteryLabel release];
	[batteryTimeLabel release];
	[batteryStateLabel release];
    [super dealloc];
}

@end
