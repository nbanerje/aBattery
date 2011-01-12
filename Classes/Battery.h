//
//  Battery.h
//  aBattery
//
//  Created by Neel Banerjee on 4/28/09.
//  Copyright 2009 Om Design LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryData.h"
@interface Battery : NSObject {
	UIDevice *myDevice;
	NSDictionary *batteryTimes;
	NSString *deviceName;
}
@property (readonly, retain, nonatomic) NSString *deviceName;
//Returns the percent of battery that is left in the device
@property (readonly) float percentLeft;

//Returns the time left in the battery in seconds
@property (readonly) NSNumber* talkTime2G;
@property (readonly) NSNumber* talkTime3G;
@property (readonly) NSNumber* standbyTime;
@property (readonly) NSNumber* internet3G;
@property (readonly) NSNumber* internetWifi;
@property (readonly) NSNumber* videoTime;
@property (readonly) NSNumber* audioTime;

//Returns the State of the Battery
@property (readonly)  NSString *batteryState;

//Returns the voltage of the Battery
@property (readonly) float voltage;

//Returns the current of the Battery
@property (readonly) float current;

//Returns the temperature of the Battery
@property (readonly) float temperature;

-(void) on;
-(void) off;

+(NSString*)dischargingString;
+(NSString*)fullString;
+(NSString*)chargingString;
+(NSString*)unknownString;
+(BOOL)inDict:(NSDictionary *) dict key:(NSObject *) key;

@end
