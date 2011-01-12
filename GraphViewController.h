//
//  GraphView.h
//  aBattery
//
//  Created by Neel Banerjee on 9/5/09.
//  Copyright 2009 Om Design LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryData.h"
#import "CorePlot-CocoaTouch.h"
#import "Battery.h"


@interface GraphViewController : UIViewController<CPPlotDataSource>  {

	CPXYGraph *graph;
	
	HistoryData *dataForPlot;
	
	NSThread *graphThread;
	UIActivityIndicatorView *indicatorview;
	
}

@property(readwrite, retain, nonatomic) HistoryData *dataForPlot;
-(void) axisLabelText:(NSString*) text tickLocation:(NSDecimalNumber*) tickLocation 
unitLabel:(NSString *) unit labelArray:(NSMutableArray*) customLabels 
tickLocationArray:(NSMutableArray*) tickLocations;

-(NSArray*) minorTickLocationsFromMajorTickLocationArray:(NSArray*) majorTickLocations axis:(CPXYAxis*) axis;
-(void)updateGraph;
- (void)startGraph:(id)info;

	


@end
