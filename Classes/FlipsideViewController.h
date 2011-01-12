//
//  FlipsideViewController.h
//  aBattery
//
//  Created by Neel Banerjee on 3/26/09.
//  Copyright Om Design LLC 2009. All rights reserved.
//
#import "FileSystem.h"
@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController <UIAccelerometerDelegate> {
	id <FlipsideViewControllerDelegate> delegate;
	UIAccelerometer *accelerometer;
	float maxX, maxY, maxZ;
	FileSystem *fs;
	BOOL resetMaxAccelFlag;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property float maxX;
@property float maxY;
@property float maxZ;

- (IBAction) done;
- (IBAction)resetMaxAccel:(id)sender;
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;
- (void) updateMemory;
@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

