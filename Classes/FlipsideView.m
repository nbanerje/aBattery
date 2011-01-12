//
//  FlipsideView.m
//  aBattery
//
//  Created by Neel Banerjee on 3/26/09.
//  Copyright Om Design LLC 2009. All rights reserved.
//

#import "FlipsideView.h"

@implementation FlipsideView
@synthesize accelX;
@synthesize accelY;
@synthesize accelZ;
@synthesize accelXMax;
@synthesize accelYMax;
@synthesize accelZMax;
@synthesize notes;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
