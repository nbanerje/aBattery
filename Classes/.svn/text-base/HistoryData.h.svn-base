//
//  HistoryData.h
//  aBattery
//
//  Created by Neel Banerjee on 5/10/09.
//  Copyright 2009 Om Design LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HistoryData : NSObject {
    NSInteger maxEntries;
	NSMutableDictionary *history;
	NSString *defaultFileName;
	NSArray  *dictKeys;
	NSMutableArray *sortedKeyArray; 
	NSDateFormatter *formatter;
	NSDateFormatter *formatter2;
	
}
@property (nonatomic) NSInteger maxEntries;
@property (nonatomic, readonly) NSMutableDictionary* history;
@property (nonatomic, readonly) NSArray* sortedKeyArray;
@property (nonatomic, readonly) NSNumber* range;
-(void)setBatteryLevel:(float)batteryLevel batteryState:(NSString*)batteryState;
-(BOOL)saveDataToDisk;
-(void)loadDataFromPath:(NSString*) path;
-(void)loadDataFromDefault;
-(void)loadDataFromURL:(NSString*)url;
-(NSString*)getDateFromIndex:(int)index;
-(NSNumber*)getNSNumberDateFromIndex:(int)index;
-(NSString*)getDatePercentStateFromIndex:(int)index;
-(NSString*)getCSVDatePercentStateFromIndex:(int)index;
-(NSNumber*)getPercentFromIndex:(int)index;
-(NSString*)getStateFromIndex:(int) index;
-(NSData*)getHistoryData;
-(NSData*)getCSVHistoryData;
-(NSNumber*)range;
-(void)updateSortedKeys;
-(void) clearHistory;


@end

