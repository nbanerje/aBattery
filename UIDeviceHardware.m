//
//  UIDeviceHardware.m
//  aBattery
//
//  Created by Neel Banerjee on 9/6/09.
//  Copyright 2009 Om Design LLC. All rights reserved.
//


#import "UIDeviceHardware.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDeviceHardware

+ (NSString *) platform{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
	free(machine);
	return platform;
}

+ (NSString *) platformString{
	NSString *platform = [UIDeviceHardware platform];
	if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
	else if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
	else if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
	else if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
	else if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
	else if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
	else if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
	else if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
	else if ([platform isEqualToString:@"iPad1,1"])   return @"iPad";
	else return @"iPhone 4";
	return platform;
}

@end
