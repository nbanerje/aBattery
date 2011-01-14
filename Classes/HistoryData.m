//
//  HistoryData.m
//  aBattery
//
//  Created by Neel Banerjee on 5/10/09.
//  Copyright 2009 Om Design LLC. All rights reserved.
//

#import "HistoryData.h"
#import "SaveData.h"

NSInteger compareDateString(id date1String, id date2String, void *context);

@implementation HistoryData
@synthesize history;
@synthesize sortedKeyArray;
@synthesize range;
@synthesize maxEntries;
/*
// Documents directory 
NSArray *paths = 
NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                    NSUserDomainMask, YES); 
NSString *documentsPath = [paths objectAtIndex:0]; 
// <Application Home>/Documents/foo.plist 
NSString *fooPath = 
[documentsPath stringByAppendingPathComponent:@“foo.plist”];
*/

// history is a Dict of Dict
-(id)init {
	if(self = [super init]) {
		history = [[NSMutableDictionary alloc] initWithCapacity:10];
		defaultFileName = @"History.plist";
		
		dictKeys = [[NSArray alloc] initWithObjects:@"batteryLevel", @"batteryState",nil];
		sortedKeyArray = [[NSMutableArray alloc] init];
		[self loadDataFromDefault];
		
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
		formatter = [[NSDateFormatter alloc] init] ;
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
		
		formatter2 = [[NSDateFormatter alloc] init];
		[formatter2 setDateStyle:NSDateFormatterShortStyle];
		[formatter2 setTimeStyle:NSDateFormatterShortStyle];
		
		maxEntries = 20; // 20 default
		
	}
	return self;
}

-(void)setBatteryLevel:(float)batteryLevel batteryState:(NSString*)batteryState{
	
	NSDictionary *entry        = [[NSDictionary alloc] initWithObjectsAndKeys:
					                 [NSNumber numberWithFloat:batteryLevel],[dictKeys objectAtIndex:0],
						             batteryState,                           [dictKeys objectAtIndex:1], 
								     nil];
	
	NSDate *date               = [NSDate date];
   
	
	[history    setObject:entry forKey:[date description]];
	
	// format: YYYY-MM-DD HH:MM:SS ±HHMM
	if(maxEntries>0 && [history count] > maxEntries) {
		//NSLog(@"HistoryData::setBatteryLevel");
		[self updateSortedKeys];
		NSInteger count = [sortedKeyArray count];
		for (int i = 0; i < count - maxEntries; i ++){
			//NSLog([NSString stringWithFormat:@"%@",[[sortedKeyArray objectAtIndex: count-i-1 ] description]]);
			[history removeObjectForKey:[sortedKeyArray objectAtIndex: count-i-1 ]];
		    
		}
	}
	[self updateSortedKeys];
	[entry      release];
	
	
}
-(BOOL)saveDataToDisk{
	return [SaveData writeApplicationPlist:history toFile:defaultFileName];
}
-(void)loadDataFromPath:(NSString*) path{
	NSDictionary *localHistory = [SaveData applicationPlistFromFile:defaultFileName];
	if(localHistory != nil) {
		[history addEntriesFromDictionary:localHistory];
    }
	
}
-(void)loadDataFromDefault{
   [self loadDataFromPath:defaultFileName];
}
-(void)loadDataFromURL:(NSString*)url{
	
}
-(NSString*)getCSVDatePercentStateFromIndex:(int)index {
	//Get keys and sort only if nil, we don't want to sort all the time.
	//if([history count] != [sortedKeyArray count]) {
	//   [self updateSortedKeys];
	//}
	if(index < [sortedKeyArray count]) {
		NSDictionary *entry = [history objectForKey:[sortedKeyArray objectAtIndex:index]];
		return [NSString stringWithFormat:@"%@,%.0f%%,%@", 
				  [self getDateFromIndex:index],
				  [(NSNumber*)[entry objectForKey:[dictKeys objectAtIndex:0]] floatValue]*100.0,
				  (NSString*)[entry objectForKey:[dictKeys objectAtIndex:1]]
		]; 
	}
	else {
	    //NSLog(@"HistoryData::getDatePercentStateFromIndex index greater than count -1");	
		return nil;
	}         
	
	
}
-(NSString*)getDatePercentStateFromIndex:(int)index {
	//Get keys and sort only if nil, we don't want to sort all the time.
	//if([history count] != [sortedKeyArray count]) {
	//   [self updateSortedKeys];
	//}
	if(index < [sortedKeyArray count]) {
		NSDictionary *entry = [history objectForKey:[sortedKeyArray objectAtIndex:index]];
		return [NSString stringWithFormat:@"%@ %.0f%% %@", 
				[self getDateFromIndex:index],
				[(NSNumber*)[entry objectForKey:[dictKeys objectAtIndex:0]] floatValue]*100.0,
				(NSString*)[entry objectForKey:[dictKeys objectAtIndex:1]]
				]; 
	}
	else {
	    //NSLog(@"HistoryData::getDatePercentStateFromIndex index greater than count -1");	
		return nil;
	}         
	
	
}

//Returns the percentage (range: 0-1)
-(NSNumber*)getPercentFromIndex:(int)index {
	if(index < [sortedKeyArray count]) {
		NSDictionary *entry = [history objectForKey:[sortedKeyArray objectAtIndex:index]];
		return (NSNumber*)[entry objectForKey:[dictKeys objectAtIndex:0]];
		
	}
	else {
	    NSLog(@"HistoryData::getPercentFromIndex index greater than count -1");	
		return nil;
	}   
	
		
}
//Date is formatted in short form
-(NSString*)getDateFromIndex:(int)index {
	if(index < [sortedKeyArray count]) {
		return [formatter2 stringFromDate:[formatter dateFromString:[sortedKeyArray objectAtIndex:index]]];
	}
	else {
	    NSLog(@"HistoryData::getDateFromIndex index greater than count -1");	
		return nil;
	}   
	
}
//NSNumber Date
-(NSNumber*)getNSNumberDateFromIndex:(int)index {
	if(index < [sortedKeyArray count]) {
		return [NSNumber numberWithDouble:[[formatter dateFromString:[sortedKeyArray objectAtIndex:index]] timeIntervalSinceReferenceDate]];
	}
	else {
	    NSLog(@"HistoryData::getNSNumberDateFromIndex index greater than count -1");	
		return nil;
	}
}

//First save data then return the data
-(NSData*)getHistoryData{
	[SaveData writeApplicationPlist:history toFile:defaultFileName];
	return [SaveData applicationDataFromFile:defaultFileName];
}

-(NSData*)getCSVHistoryData{
	
	[self updateSortedKeys];
	
	NSMutableString *str = [[NSMutableString alloc] initWithCapacity:10000];
	for(int i = 0; i < [sortedKeyArray count]; i++) {
		[str appendString:[NSString stringWithFormat:@"%@\r\n",[self getCSVDatePercentStateFromIndex:i]]];
	}
	
	NSData *txtFileData = [str dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES];
	[str release];
	return txtFileData;
}
// Useful to get the absolute range
-(NSNumber*)range {
	if([sortedKeyArray count] > 0)
        return [ NSNumber numberWithDouble: 
				abs([[formatter dateFromString:[sortedKeyArray objectAtIndex:0]] 
	                 timeIntervalSinceDate: [formatter dateFromString:[sortedKeyArray lastObject]]
					 ])
				];
	else
		return nil;	
}
// Useful to battery state
-(NSString*)getStateFromIndex:(int) index {
	if([sortedKeyArray count] > 0)
        return [(NSDictionary*)[history objectForKey:[sortedKeyArray objectAtIndex:index]] objectForKey:@"batteryState"];
	else
		return nil;	
}

NSInteger compareDateString(id date1String, id date2String, void *context){
	[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
	NSDate *date1 = [formatter dateFromString:date1String];
	NSDate *date2 = [formatter dateFromString:date2String];
	/*if(date1 == nil || date2 == nil) {
		//NSLog(@"nil data");
	}*/
	[formatter release];
	//return [date1 compare:date2];
	return [date2 compare:date1];

}
-(void) clearHistory {
	[history removeAllObjects];
}
-(void) updateSortedKeys {
	NSArray *keys = [history allKeys];
	[sortedKeyArray removeAllObjects];
	[sortedKeyArray addObjectsFromArray:[keys sortedArrayUsingFunction:compareDateString context:NULL]];
}

- (void)dealloc {
	[history release];
	[dictKeys release];
	[sortedKeyArray release];
	[formatter release];
	[formatter2 release];
    [super dealloc];
}

 @end
