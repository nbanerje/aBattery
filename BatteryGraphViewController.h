//
//  BatteryGraphViewController.h
//  aBattery
//
//  Created by Neel Banerjee on 9/5/09.
//  Copyright 2009 Om Design LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "HistoryData.h"
#import "Battery.h"

@interface BatteryGraphViewController : UIViewController <CPPlotDataSource>
{
	CPXYGraph *graph;
	HistoryData *dataForPlot;
	NSThread *plotThread;
}

@property(readwrite, retain, nonatomic) HistoryData *dataForPlot;
//@property(readwrite, retain, nonatomic) NSMutableArray *dataForPlot;
-(void) updateGraph;
-(void) createPlotWithId:(NSString*)plotId lineWidth:(float) lineWidth lineColor:(CPColor*) lineColor symbol:(CPPlotSymbol*)plotSymbol;
-(CPPlotSymbol*) getEllipseSymbolWithColor:(CPColor*) color;
-(double) setupXAxis;
-(double) setupXAxisCustomLabels;
-(void) axisLabelText:(NSString*) text tickLocation:(double) 
tickLocation unitLabel:(NSString *) unit labelArray:(NSMutableArray*) customLabels 
	tickLocationArray: (NSMutableArray*) tickLocations;
-(NSArray*) minorTickLocationsFromMajorTickLocationArray:(NSArray*) majorTickLocations axis:(CPXYAxis*) axis;
-(double) nearestSecondMinuteFromSeconds:(double) seconds;

-(void) setupYAxis:(double) yint;

-(void) drawPlot;
-(void) showIndicatorLabel;
-(void) hideIndicatorLabel;
-(void) showTabbar;
@end
