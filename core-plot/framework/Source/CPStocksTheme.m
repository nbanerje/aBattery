
#import "CPStocksTheme.h"
#import "CPXYGraph.h"
#import "CPColor.h"
#import "CPGradient.h"
#import "CPFill.h"
#import "CPPlotArea.h"
#import "CPXYPlotSpace.h"
#import "CPUtilities.h"
#import "CPXYAxisSet.h"
#import "CPXYAxis.h"
#import "CPLineStyle.h"
#import "CPTextStyle.h"
#import "CPBorderedLayer.h"
#import "CPExceptions.h"

/** @brief Creates a CPXYGraph instance formatted with a gradient background and white lines.
 **/
@implementation CPStocksTheme

+(NSString *)name 
{
	return kCPStocksTheme;
}

-(id)newGraph 
{
	CPXYGraph *graph = [super newGraph];
    
	graph.paddingLeft = 0.0;
	graph.paddingTop = 0.0;
	graph.paddingRight = 0.0;
	graph.paddingBottom = 0.0;
    
    CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-1.0) length:CPDecimalFromFloat(1.0)];
    plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-1.0) length:CPDecimalFromFloat(1.0)];
	
	return graph;
}

-(void)applyThemeToBackground:(CPXYGraph *)graph 
{	
    graph.fill = [CPFill fillWithColor:[CPColor blackColor]];
}
	
-(void)applyThemeToPlotArea:(CPPlotArea *)plotArea 
{	
    CPGradient *stocksBackgroundGradient = [[[CPGradient alloc] init] autorelease];
    stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPColor colorWithComponentRed:0.21569f green:0.28627f blue:0.44706f alpha:1.0f] atPosition:0.0f];
	stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPColor colorWithComponentRed:0.09412f green:0.17255f blue:0.36078f alpha:1.0f] atPosition:0.5f];
	stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPColor colorWithComponentRed:0.05882f green:0.13333f blue:0.33333f alpha:1.0f] atPosition:0.5f];
	stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPColor colorWithComponentRed:0.05882f green:0.13333f blue:0.33333f alpha:1.0f] atPosition:1.0f];
    stocksBackgroundGradient.angle = 270.0;
	plotArea.fill = [CPFill fillWithGradient:stocksBackgroundGradient];
}

-(void)applyThemeToAxisSet:(CPXYAxisSet *)axisSet 
{	
	CPLineStyle *borderLineStyle = [CPLineStyle lineStyle];
    borderLineStyle.lineColor = [CPColor colorWithGenericGray:0.2];
    borderLineStyle.lineWidth = 0.0f;
	
	CPBorderedLayer *borderedLayer = (CPBorderedLayer *)axisSet.overlayLayer;
	borderedLayer.borderLineStyle = borderLineStyle;
	borderedLayer.cornerRadius = 14.0f;
	axisSet.overlayLayerInsetX = 0.0f;
	axisSet.overlayLayerInsetY = 0.0f;
    
    CPLineStyle *majorLineStyle = [CPLineStyle lineStyle];
    majorLineStyle.lineCap = kCGLineCapRound;
    majorLineStyle.lineColor = [CPColor whiteColor];
    majorLineStyle.lineWidth = 3.0f;
    
    CPLineStyle *minorLineStyle = [CPLineStyle lineStyle];
    minorLineStyle.lineColor = [CPColor whiteColor];
    minorLineStyle.lineWidth = 3.0f;
	
    CPXYAxis *x = axisSet.xAxis;
	CPTextStyle *whiteTextStyle = [[[CPTextStyle alloc] init] autorelease];
	whiteTextStyle.color = [CPColor whiteColor];
	whiteTextStyle.fontSize = 14.0;
    x.axisLabelingPolicy = CPAxisLabelingPolicyFixedInterval;
    x.majorIntervalLength = CPDecimalFromString(@"0.5");
    x.constantCoordinateValue = CPDecimalFromString(@"0");
	x.tickDirection = CPSignNone;
    x.minorTicksPerInterval = 4;
    x.majorTickLineStyle = majorLineStyle;
    x.minorTickLineStyle = minorLineStyle;
    x.axisLineStyle = majorLineStyle;
    x.majorTickLength = 7.0f;
    x.minorTickLength = 5.0f;
	x.axisLabelTextStyle = whiteTextStyle; 
	
    CPXYAxis *y = axisSet.yAxis;
    y.axisLabelingPolicy = CPAxisLabelingPolicyFixedInterval;
    y.majorIntervalLength = CPDecimalFromString(@"0.5");
    y.minorTicksPerInterval = 4;
    y.constantCoordinateValue = CPDecimalFromString(@"0");
	y.tickDirection = CPSignNone;
    y.majorTickLineStyle = majorLineStyle;
    y.minorTickLineStyle = minorLineStyle;
    y.axisLineStyle = majorLineStyle;
    y.majorTickLength = 7.0f;
    y.minorTickLength = 5.0f;
	y.axisLabelTextStyle = whiteTextStyle;
    
}

@end
