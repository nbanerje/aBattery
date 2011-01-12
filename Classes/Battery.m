//
//  Battery.m
//  aBattery
//
//  Created by Neel Banerjee on 4/28/09.
//  Copyright 2009 Om Design LLC. All rights reserved.
//

#import "Battery.h"
#import "HistoryData.h"
#import "UIDeviceHardware.h"
#import "SaveData.h"
@implementation Battery
@synthesize deviceName;
-(id) init {
	if(self = [super init]) {
		myDevice = [UIDevice currentDevice];
		batteryTimes = (NSDictionary*)[SaveData applicationPlistFromBundleFile:@"batteryTimes.plist"];
		[batteryTimes retain];
		deviceName   = [UIDeviceHardware platformString];
		
	}
	return self;
}
//Returns the percent of battery that is left in the device
-(float) percentLeft {
	//[self on];
	//We don't want to see the -1 when the battery state is unknown
	float level = fabs([myDevice batteryLevel]);
	//[self off];
    return level;
}

//Returns the time left in the battery in seconds
-(NSNumber*) talkTime2G {
	if([Battery inDict:batteryTimes key:deviceName]) return (NSNumber*)[[batteryTimes objectForKey:deviceName] objectForKey:@"talkTime2G"];
	return [NSNumber numberWithFloat:0.0f];
}

-(NSNumber*) talkTime3G {
	if([Battery inDict:batteryTimes key:deviceName]) return (NSNumber*)[[batteryTimes objectForKey:deviceName] objectForKey:@"talkTime3G"];
    return [NSNumber numberWithFloat:0.0f];
}

-(NSNumber*) standbyTime {
	if([Battery inDict:batteryTimes key:deviceName]) return (NSNumber*)[[batteryTimes objectForKey:deviceName] objectForKey:@"standbyTime"];
	return [NSNumber numberWithFloat:0.0f];
}

-(NSNumber*) internet3G {
	if([Battery inDict:batteryTimes key:deviceName]) return (NSNumber*)[[batteryTimes objectForKey:deviceName] objectForKey:@"internet3G"];
	return [NSNumber numberWithFloat:0.0f];
}

-(NSNumber*) internetWifi {
	if([Battery inDict:batteryTimes key:deviceName]) return (NSNumber*)[[batteryTimes objectForKey:deviceName] objectForKey:@"internetWifi"];
	return [NSNumber numberWithFloat:0.0f];
}

-(NSNumber*) videoTime {
	if([Battery inDict:batteryTimes key:deviceName]) return (NSNumber*)[[batteryTimes objectForKey:deviceName] objectForKey:@"videoTime"];
	return [NSNumber numberWithFloat:0.0f];
}

-(NSNumber*) audioTime {
	if([Battery inDict:batteryTimes key:deviceName]) return (NSNumber*)[[batteryTimes objectForKey:deviceName] objectForKey:@"audioTime"];
	return [NSNumber numberWithFloat:0.0f];
}


//Returns the State of the Battery
-(NSString*) batteryState {
	//[self on];
	UIDeviceBatteryState status = [myDevice batteryState];
	NSString *batteryStateString;
    if(status == UIDeviceBatteryStateUnknown)
		batteryStateString = [NSString stringWithString:@"Unknown"];
	else if(status == UIDeviceBatteryStateUnplugged)
		batteryStateString = [NSString stringWithString:@"Discharging"];
    else if(status == UIDeviceBatteryStateCharging) 
		batteryStateString = [NSString stringWithString:@"Charging"];
	else if(status == UIDeviceBatteryStateFull)
	     batteryStateString = [NSString stringWithString:@"Full"];
	else
		batteryStateString = nil;
	//[self off];
	return batteryStateString;
}

//Returns the voltage of the Battery
-(float) voltage {
	return 0.0;
}

//Returns the current of the Battery
- (float) current {
	return 0.0;
}

//Returns the temperature of the Battery
-(float) temperature{
    return 0.0;
}

-(void) dealloc {
	[batteryTimes release];
	[super dealloc];
}

-(void) on {
   [myDevice setBatteryMonitoringEnabled:YES];
}

-(void) off {
	[myDevice setBatteryMonitoringEnabled:NO];
}

+(NSString*)dischargingString {
   return @"Discharging";
}
+(NSString*)fullString {
   return @"Full";
}
+(NSString*)chargingString{
   return @"Charging";
}
+(NSString*)unknownString{
   return @"Unknown";
}
+(BOOL)inDict:(NSDictionary *) dict key:(NSObject *) key {
   return ([dict objectForKey:key] != nil);
}

@end
