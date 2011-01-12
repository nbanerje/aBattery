//
//  FileSystem.h
//  aBattery
//
//  Created by Neel Banerjee on 4/19/09.
//  Copyright 2009 Om Design LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sys/param.h"
#import "sys/mount.h"
#import "sys/types.h"
#import "sys/sysctl.h"

@interface FileSystem : NSObject {
	struct statfs *statfsptr;
}

@property(readonly) double freeMemory; // MB
@property(readonly) double activeMemory; // MB
@property(readonly) double inactiveMemory; // MB
@property(readonly) double wireMemory; // MB
@property(readonly) double zeroFillMemory; // MB
@property(readonly) int pageins; 
@property(readonly) int pageouts; 
@property(readonly) int faults; 

@property(readonly) double totalMemory; // MB

@end
