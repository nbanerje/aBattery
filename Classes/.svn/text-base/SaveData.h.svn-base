//
//  SaveData.h
//  aBattery
//
//  Created by Neel Banerjee on 5/10/09.
//  Copyright 2009 Om Design LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SaveData : NSObject {

}

+ (BOOL)writeApplicationPlist:(id)plist toFile:(NSString *)fileName;
+ (BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName;

+ (id)applicationPlistFromFile:(NSString *)fileName;
+ (NSData *)applicationDataFromFile:(NSString *)fileName;


+ (id)applicationPlistFromBundleFile:(NSString *)fileName;
+ (NSData *)applicationDataFromBundleFile:(NSString *)fileName;
@end
