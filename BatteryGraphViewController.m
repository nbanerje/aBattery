

#import "BatteryGraphViewController.h"

@implementation BatteryGraphViewController

@synthesize dataForPlot;

#pragma mark -
#pragma mark Initialization and teardown

static const double ONEMINUTE = 60;
static const double ONEHOUR   = 60*60;
static const double ONEDAY    = 60*60*24;
static const double ONEWEEK   = 60*60*24*7;
static const double ONEMONTH  = 60*60*24*7*4;
static const double ONEYEAR   = 60*60*24*7*4*12;

-(void)dealloc 
{
	[dataForPlot release];
	if(plotThread != nil) [plotThread release];
    [super dealloc];
}

-(void)viewDidLoad 
{
    [super viewDidLoad];
    self.tabBarItem.title         = @"Graph";
	self.tabBarItem.image         = [UIImage imageNamed:@"graph.png"];
	[NSNumberFormatter setDefaultFormatterBehavior:NSNumberFormatterBehavior10_4];
	//plotThread = [[NSThread alloc] initWithTarget:self selector:@selector(startPlotThread:) object:nil];
	[[NSNotificationCenter defaultCenter] addObserver: self 
											 selector: @selector(updateGraph) 
												 name:  UIDeviceBatteryLevelDidChangeNotification
											   object: [UIDevice currentDevice]];
	
	[[NSNotificationCenter defaultCenter] addObserver: self 
											 selector: @selector(updateGraph) 
												 name: UIDeviceBatteryStateDidChangeNotification
											   object: [UIDevice currentDevice]];
	//Make sure the tab bar is visible
	[NSTimer timerWithTimeInterval:2 target:self selector:@selector(showTabbar) userInfo:nil repeats:YES];
	
		
		
}
-(void) viewWillAppear:(BOOL)animated {
	//NSLog(@"BatteryGraphViewController::viewWillAppear");
	[self showIndicatorLabel];
	CPLayerHostingView *hostingView = (CPLayerHostingView *)[self.view viewWithTag:1];
	//[self drawPlot];
	hostingView.hidden = YES;
	if(plotThread == nil) {
	    plotThread = [[NSThread alloc] initWithTarget:self selector:@selector(startPlotThread:) object:nil];
	    [plotThread start];
	}
	else if ([plotThread isExecuting] == NO) {
		[plotThread	release];
		plotThread = [[NSThread alloc] initWithTarget:self selector:@selector(startPlotThread:) object:nil];
	    [plotThread start];
		
	}
	
	//[plotThread start];
	
//	if([plotThread isExecuting]) NSLog(@"BatteryGraphViewController::viewWillAppear plotThread is executing");
//	if([plotThread isFinished]) NSLog(@"BatteryGraphViewController::viewWillAppear plotThread is finished");
	
}
-(void) viewDidAppear:(BOOL)animated {
	//NSLog(@"BatteryGraphViewController::viewDidAppear");
    //[self updateGraph];
}	
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait ||
			interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ||
			interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
			interfaceOrientation == UIInterfaceOrientationLandscapeRight
			);
}

-(void) updateGraph {
	//NSLog(@"BatteryGraphViewController::updateGraph");
   [self setupYAxis:[self setupXAxisCustomLabels]];
	if(graph != nil && ![plotThread isExecuting]) {
		[graph reloadData];
	
	}
   
}
-(void) showIndicatorLabel {
	//NSLog(@"BatteryGraphViewController::showIndicatorLabel");
	UILabel *loadingLabel = (UILabel*)[self.view viewWithTag:2];
	UILabel *disclaimerLabel = (UILabel*)[self.view viewWithTag:4];
	UIActivityIndicatorView *indicator = (UIActivityIndicatorView*)[self.view viewWithTag:3];
	loadingLabel.hidden = NO;
	disclaimerLabel.hidden = NO;
	[indicator startAnimating];
	self.tabBarController.tabBar.hidden = YES;
}

-(void) hideIndicatorLabel {
	//NSLog(@"BatteryGraphViewController::hideIndicatorLabel");
	UILabel *loadingLabel = (UILabel*)[self.view viewWithTag:2];
	UILabel *disclaimerLabel = (UILabel*)[self.view viewWithTag:4];
	UIActivityIndicatorView *indicator = (UIActivityIndicatorView*)[self.view viewWithTag:3];
	loadingLabel.hidden = YES;
	disclaimerLabel.hidden = YES;
	[indicator stopAnimating];
	self.tabBarController.tabBar.hidden = NO;
}
-(void) showTabbar {
   if(![plotThread isExecuting]) self.tabBarController.tabBar.hidden = NO;
}
-(void) startPlotThread:(id) info{
	//NSLog(@"BatteryGraphViewController::startPlotThread");
	[NSThread setThreadPriority:1.0];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self drawPlot];
	CPLayerHostingView *hostingView = (CPLayerHostingView *)[self.view viewWithTag:1];
	//[self drawPlot];
	hostingView.hidden = NO;
	[self hideIndicatorLabel];
	[pool release];
}
-(void) drawPlot {
	//NSLog(@"BatteryGraphViewController::drawPlot START*********");
	[dataForPlot updateSortedKeys];
    // Create graph from theme
	CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
	graph = (CPXYGraph *)[theme newGraph];	
	CPLayerHostingView *hostingView = (CPLayerHostingView *)[self.view viewWithTag:1];
    hostingView.hostedLayer = graph;
	
    graph.paddingLeft   = 0;
	graph.paddingTop    = 0;
	graph.paddingRight  = 0;
	graph.paddingBottom = 0;
    
	//[self setupYAxis:[self setupXAxis]];
	[self setupYAxis:[self setupXAxisCustomLabels]];

	[self createPlotWithId:@"White Plot" lineWidth:3.0f lineColor:[CPColor darkGrayColor] symbol:[self getEllipseSymbolWithColor:[CPColor clearColor]]];
	[self createPlotWithId:@"Blue Plot" lineWidth:3.0f lineColor:[CPColor clearColor] symbol:[self getEllipseSymbolWithColor:[CPColor blueColor]]];
	[self createPlotWithId:@"Orange Plot" lineWidth:3.0f lineColor:[CPColor clearColor] symbol:[self getEllipseSymbolWithColor:[CPColor colorWithCGColor:[UIColor orangeColor].CGColor]]];
	[self createPlotWithId:@"Red Plot" lineWidth:3.0f lineColor:[CPColor clearColor] symbol:[self getEllipseSymbolWithColor:[CPColor redColor]]];
	[self createPlotWithId:@"Green Plot" lineWidth:3.0f lineColor:[CPColor clearColor] symbol:[self getEllipseSymbolWithColor:[CPColor greenColor]]];
	
    //hostingView.alpha = 1.0;
	
    
	//NSLog(@"BatteryGraphViewController::drawPlot END**************");	
}
-(void) createPlotWithId:(NSString*)plotId lineWidth:(float) lineWidth lineColor:(CPColor*) lineColor symbol:(CPPlotSymbol*)plotSymbol {
	// Create a blue plot area
	CPScatterPlot *boundLinePlot = [[CPScatterPlot alloc] init];
    boundLinePlot.identifier = plotId;
	boundLinePlot.dataLineStyle.miterLimit = 1.0f;
	boundLinePlot.dataLineStyle.lineWidth = lineWidth;
	boundLinePlot.dataLineStyle.lineColor = lineColor;
    boundLinePlot.dataSource = self;
	boundLinePlot.plotSymbol = plotSymbol;
	[graph addPlot:boundLinePlot];
	[boundLinePlot release];
	
	
		
}
-(CPPlotSymbol*) getEllipseSymbolWithColor:(CPColor*) color{
	// Add plot symbols
	CPLineStyle *symbolLineStyle = [CPLineStyle lineStyle];
	symbolLineStyle.lineColor = [CPColor blackColor];
	CPPlotSymbol *plotSymbol = [CPPlotSymbol ellipsePlotSymbol];
	plotSymbol.fill = [CPFill fillWithColor:color];
	plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(10.0, 10.0);
	return plotSymbol;
   	
}
//Returns the yint for the yaxis setup
-(double) setupXAxis {
    // Setup plot space
    CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
	
	double secondsOfLastIndex;
	double secondsOfFirstIndex;
	double range;
	double location1;
	double location2;
	double length;
	double yint;
	if([[dataForPlot sortedKeyArray] count] >=2 ) {
	
	// This value is less than secondsOfFirstIndex
	  secondsOfLastIndex =[[dataForPlot getNSNumberDateFromIndex:[[dataForPlot sortedKeyArray] count] - 1] doubleValue];
	// This value is greater than secondsOfLastIndex
	  secondsOfFirstIndex =[[dataForPlot getNSNumberDateFromIndex:0] doubleValue];
	 
	}
	else {
		secondsOfLastIndex = (double)[[NSDate date] timeIntervalSinceReferenceDate];
		secondsOfFirstIndex = secondsOfLastIndex+60;
	}
	
	
	range = secondsOfFirstIndex - secondsOfLastIndex;
	
	location1 = secondsOfLastIndex-(range*0.20);
	location2 = secondsOfFirstIndex+(range*0.05);
	length = location2 - location1;
	
	yint  = secondsOfLastIndex-(range*0.02);
	//NSLog(@"BatteryGraphViewController::setupXAxis");
	//NSLog(@"\trange\tlocation1\tlocation2\tlength\tyint\texrange0.15\texrange0.05");
	
	//NSLog([NSString stringWithFormat:@"\t%f\t%f\t%f\t%f\t%f\t%f\t%f",range,location1,location2,length,yint,range*0.15, range*0.05]);
    plotSpace.xRange = [CPPlotRange plotRangeWithLocation: CPDecimalFromDouble(location1) length:CPDecimalFromDouble(length)];
	
    // Axes
	CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
    CPXYAxis *x = axisSet.xAxis;
	x.constantCoordinateValue = CPDecimalFromFloat(0);
    
 	/*NSArray *exclusionRanges = [NSArray arrayWithObjects:
								[CPPlotRange plotRangeWithLocation:CPDecimalFromDouble(location1) length:CPDecimalFromDouble(range*0.15)], 
								[CPPlotRange plotRangeWithLocation:CPDecimalFromDouble(secondsOfFirstIndex) length:CPDecimalFromDouble(range*0.05)],
								nil];
	x.labelExclusionRanges = exclusionRanges;
	*/
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(range <=60) {
		//NSLog(@"BatteryGraphViewController::setupXAxis Range: min");
		//Less than One min range
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		//Every 30 min
		x.majorIntervalLength = CPDecimalFromDouble(30);
		x.minorTicksPerInterval = 1;
	}
	else if (range <=60*30) {
		//NSLog(@"BatteryGraphViewController::setupXAxis Range: 0.5 h");
		//Less than 0.5 hour range
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		//Every 15 min
		x.majorIntervalLength = CPDecimalFromDouble(60*5);
		x.minorTicksPerInterval = 0;
	}
    else if (range <=60*60) {
		//NSLog(@"BatteryGraphViewController::setupXAxis Range: 1 h");
		//Less than one hour range
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		//Every 15 min
		x.majorIntervalLength = CPDecimalFromDouble(60*15);
		x.minorTicksPerInterval = 1;
	}
	else if (range <=60*60*12) {
		//NSLog(@"BatteryGraphViewController::setupXAxis Range: 0.5 d");
		//Less than 0.5 day range
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		//Every 6 hours
		x.majorIntervalLength = CPDecimalFromDouble(60*60*1);
		x.minorTicksPerInterval = 1;
	}
	else if (range <=60*60*24) {
		//NSLog(@"BatteryGraphViewController::setupXAxis Range: 1 d");
		//Less than one day range
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		//Every 6 hours
		x.majorIntervalLength = CPDecimalFromDouble(60*60*6);
		x.minorTicksPerInterval = 1;
	}
	else if (range<=60*60*24*7){
		//NSLog(@"BatteryGraphViewController::setupXAxis Range: 1 w");
		//less than one week
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	    // Every day
		x.majorIntervalLength = CPDecimalFromDouble(60*60*24);
		x.minorTicksPerInterval = 1;
	}
	else if (range<=60*60*24*30){
		//NSLog(@"BatteryGraphViewController::setupXAxis Range: 1 m");
		//less than one month
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		//every week
		x.majorIntervalLength = CPDecimalFromDouble(60*60*24*7);
		x.minorTicksPerInterval = 1;
	}
	else if (range<=60*60*24*365){
		//NSLog(@"BatteryGraphViewController::setupXAxis Range: 1 y");
		
		//less than one week
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		//every month
		x.majorIntervalLength = CPDecimalFromDouble(60*60*24*30);
		x.minorTicksPerInterval = 1;
	}
	else {
		//NSLog(@"BatteryGraphViewController::setupXAxis Range: +1 y");
		
		//more than one week
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		//every year
		x.majorIntervalLength = CPDecimalFromDouble(60*60*24*365);
		x.minorTicksPerInterval = 11;
	}
	
	axisSet.xAxis.tickLabelFormatter = [[CPTimeFormatter alloc]
										initWithDateFormatter:dateFormatter]; 
	[dateFormatter release];
	return yint;
}
-(double) setupXAxisCustomLabels {
    // Setup plot space
    CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
	
	double secondsOfLastIndex;
	double secondsOfFirstIndex;
	double range;
	double location1;
	double location2;
	double length;
	double yint;
	if([[dataForPlot sortedKeyArray] count] >=2 ) {
		
		// This value is less than secondsOfFirstIndex
		secondsOfLastIndex =[[dataForPlot getNSNumberDateFromIndex:[[dataForPlot sortedKeyArray] count] - 1] doubleValue];
		// This value is greater than secondsOfLastIndex
		secondsOfFirstIndex =[[dataForPlot getNSNumberDateFromIndex:0] doubleValue];
		range = secondsOfFirstIndex - secondsOfLastIndex;
		//If the range is less that 10 ten minutes set a fixed 4 minute range
		if(range<ONEMINUTE*10) {
			secondsOfLastIndex  = secondsOfLastIndex  - ONEMINUTE*2;
			secondsOfFirstIndex = secondsOfFirstIndex + ONEMINUTE*2;
		}
		
		
	}
	//If we only have one entry make 4 min span
	else if([[dataForPlot sortedKeyArray] count] ==1 ) {
		
        secondsOfFirstIndex =[[dataForPlot getNSNumberDateFromIndex:0] doubleValue] + ONEMINUTE*2;
		
		secondsOfLastIndex  =  secondsOfFirstIndex  - ONEMINUTE*2;
	}
	//If we don't have more than 1 entries then just range 4min from the current time
	else {
		secondsOfLastIndex = (double)[[NSDate date] timeIntervalSinceReferenceDate]  - ONEMINUTE*2;
		secondsOfFirstIndex = (double)[[NSDate date] timeIntervalSinceReferenceDate] + ONEMINUTE*2;
	}
	
	
	range = secondsOfFirstIndex - secondsOfLastIndex;
	yint  = secondsOfLastIndex-(range*0.15);
	//location1 = secondsOfLastIndex-(range*0.20);
	location1 = yint  - (range*0.20);
	location2 = secondsOfFirstIndex+(range*0.05);
	length = location2 - location1;
	
	
	//NSLog(@"BatteryGraphViewController::setupXAxis");
	//NSLog(@"\trange\tlocation1\tlocation2\tlength\tyint\texrange0.15\texrange0.05");
	
	//NSLog([NSString stringWithFormat:@"\t%f\t%f\t%f\t%f\t%f\t%f\t%f",range,location1,location2,length,yint,range*0.15, range*0.05]);
    plotSpace.xRange = [CPPlotRange plotRangeWithLocation: CPDecimalFromDouble(location1) length:CPDecimalFromDouble(length)];
	
    // Axes
	CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
    CPXYAxis *x = axisSet.xAxis;
    x.axisLabelingPolicy = CPAxisLabelingPolicyNone;
    x.constantCoordinateValue = CPDecimalFromFloat(0);
    x.minorTicksPerInterval = 0;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
	if(range<ONEDAY) {
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	}
	else {
	    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
	}
	
	//Add label at firstLocation
	NSMutableArray *labelArray = [[NSMutableArray alloc]
								  initWithCapacity: 3];
	
	NSMutableArray *tickLocationArray = [[NSMutableArray alloc]
										 initWithCapacity: 3];
	
	double halfWay = secondsOfLastIndex + range/2.0;
	
	double firstLocation = [self nearestSecondMinuteFromSeconds:secondsOfLastIndex];
	NSString *firstLocationString
	= [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:firstLocation]];
	
	double midLocation  = [self nearestSecondMinuteFromSeconds:halfWay];
	NSString *midLocationString
	= [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:midLocation]];

	double lastLocation = [self nearestSecondMinuteFromSeconds:secondsOfFirstIndex];
	NSString *lastLocationString
	= [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:lastLocation]];
	//NSLog(@"1st\tmid\tlast\t0.5");
	//NSLog([NSString stringWithFormat:@"\t%f\t%f\t%f\t%f\t%f\t%f\t%f",firstLocation,midLocation,lastLocation,halfWay]);
    //NSLog([NSString stringWithFormat:@"\t%@\t%@\t%@",firstLocationString,midLocationString,lastLocationString]);
    
	[self axisLabelText:firstLocationString tickLocation:firstLocation unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
	[self axisLabelText:midLocationString tickLocation:midLocation unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
	[self axisLabelText:lastLocationString tickLocation:lastLocation unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
	
	x.axisLabels =  [NSSet setWithArray:labelArray];
	x.majorTickLocations =  [NSSet setWithArray:tickLocationArray];
	NSArray *minorTickLocations = [self minorTickLocationsFromMajorTickLocationArray:tickLocationArray axis:x];
	x.minorTickLocations =  [NSSet setWithArray:minorTickLocations];
	
	[dateFormatter release];
	return yint;
}
//Returns seconds
-(double) nearestSecondMinuteFromSeconds:(double) seconds {
		return round(seconds/60)*60;
}

-(void) axisLabelText:(NSString*) text tickLocation:(double) 
tickLocation unitLabel:(NSString *) unit labelArray:(NSMutableArray*) customLabels 
	tickLocationArray: (NSMutableArray*) tickLocations {
	CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
    CPXYAxis *x = axisSet.xAxis;
	CPAxisLabel *newLabel;
	
	if(unit == nil)
		newLabel = [[CPAxisLabel alloc] initWithText: text textStyle:x.axisLabelTextStyle];
	else
		newLabel = [[CPAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%@ %@",text,unit] textStyle:x.axisLabelTextStyle];
	
	newLabel.tickLocation = [[NSNumber numberWithDouble:tickLocation] decimalValue];
	newLabel.textStyle    = x.axisLabelTextStyle;
	newLabel.offset       = x.axisLabelOffset + x.majorTickLength;
	[customLabels addObject:newLabel];
	[tickLocations addObject:[NSDecimalNumber decimalNumberWithDecimal: [[NSNumber numberWithDouble:tickLocation] decimalValue]]];
	
	[newLabel release];
    
	
}
// Assumes that the array is sorted. We don't sort here to optimize for speed and lazyness
-(NSArray*) minorTickLocationsFromMajorTickLocationArray:(NSArray*) majorTickLocations axis:(CPXYAxis*) axis{
	NSMutableArray *newMinorTickLocations = [[NSMutableArray alloc] initWithCapacity:([majorTickLocations count]+1)*axis.minorTicksPerInterval] ;
	NSDecimalNumber *majorTick     = (NSDecimalNumber*)[majorTickLocations objectAtIndex:0];
	NSDecimalNumber *increment     = [[majorTick decimalNumberBySubtracting:[NSDecimalNumber zero]] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:axis.minorTicksPerInterval+1] decimalValue]]];
	
	if([majorTickLocations count]>=1) {
		for (int j = 1; j <= axis.minorTicksPerInterval; j++){
			NSDecimalNumber *tick0 = [[NSDecimalNumber zero] decimalNumberByAdding:[increment decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:j] decimalValue]]]];
			//[tick0 retain];
			[newMinorTickLocations addObject:tick0];
			//NSLog([NSString stringWithFormat:@"minor %d",[[majorTick decimalNumberByAdding:[increment decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:j] decimalValue]]]] intValue]]);
		}
		
	}
	if([majorTickLocations count]>=2) {
		NSDecimalNumber *nextMajorTick = (NSDecimalNumber*)[majorTickLocations objectAtIndex:1];
		
		for( int i = 0; i < [majorTickLocations count]-1; i++) {
			majorTick     = (NSDecimalNumber*)[majorTickLocations objectAtIndex:i];
			nextMajorTick = (NSDecimalNumber*)[majorTickLocations objectAtIndex:i+1];
			increment     = [[nextMajorTick decimalNumberBySubtracting:majorTick] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:axis.minorTicksPerInterval+1] decimalValue]]];
			for (int j = 1; j <= axis.minorTicksPerInterval; j++) {
				NSDecimalNumber *tick = [majorTick decimalNumberByAdding:[increment decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:j] decimalValue]]]];
				//[tick retain];
				
				[newMinorTickLocations addObject:tick];
				//NSLog([NSString stringWithFormat:@"minor %d",[[majorTick decimalNumberByAdding:[increment decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:j] decimalValue]]]] intValue]]);
			}
		}
	}
	return newMinorTickLocations;
}


-(void) setupYAxis:(double) yint {
	//NSLog(@"BatteryGraphViewController::setupYAxis");
	CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
	CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
	
	plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-.2) length:CPDecimalFromFloat(1.4)];
	CPXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPDecimalFromString(@"0.25");
    y.minorTicksPerInterval = 4;
    y.constantCoordinateValue = CPDecimalFromDouble(yint);
	y.axisLabelOffset = 0.1;
	NSNumberFormatter *formatterY = [[NSNumberFormatter alloc] init];
	[formatterY setNumberStyle: NSNumberFormatterPercentStyle];
	y.tickLabelFormatter = formatterY;
	[formatterY release];
	NSArray *exclusionRanges =  [NSArray arrayWithObjects:
					   [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-.2) length:CPDecimalFromFloat(.21)], 
					   [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.0099) length:CPDecimalFromFloat(0.40)],
					   nil];
	y.labelExclusionRanges = exclusionRanges;
	
}
#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
	//NSLog(@"BatteryGraphViewController::numberOfRecordsForPlot");
    return [[dataForPlot sortedKeyArray] count];
}

-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
	//NSLog(@"BatteryGraphViewController::numberForPlot");
   /* NSNumber *num = [[dataForPlot objectAtIndex:index] valueForKey:(fieldEnum == CPScatterPlotFieldX ? @"x" : @"y")];
	// Green plot gets shifted above the blue
	if ([(NSString *)plot.identifier isEqualToString:@"Green Plot"])
	{
		if ( fieldEnum == CPScatterPlotFieldY ) 
			num = [NSNumber numberWithDouble:[num doubleValue] + 1.0];
	}
    return num;
	*/
	/*NSNumber *num;
	if(fieldEnum == CPScatterPlotFieldX) {
		num = [dataForPlot getNSNumberDateFromIndex:index];
		NSLog([NSString stringWithFormat:@"%@",num]);
	}
	else {
		num = [dataForPlot getPercentFromIndex:index];
		NSLog([NSString stringWithFormat:@"%@",num]);
	}
	return num;
	*/
	NSNumber *num;
	// White plot gets everything
	if ([(NSString *)plot.identifier isEqualToString:@"White Plot"])
	{
		if(fieldEnum == CPScatterPlotFieldX) {
			num = [dataForPlot getNSNumberDateFromIndex:index];
			//NSLog([NSString stringWithFormat:@"%@",num]);
		}
		else {
			num = [dataForPlot getPercentFromIndex:index];
			//NSLog([NSString stringWithFormat:@"%@",num]);
		}
	}
	else if ([(NSString *)plot.identifier isEqualToString:@"Red Plot"])
	{
		
		if([(NSString*)[dataForPlot getStateFromIndex:index] isEqualToString:[Battery unknownString]]){
			if(fieldEnum == CPScatterPlotFieldX) {
				num = [dataForPlot getNSNumberDateFromIndex:index];
				//NSLog([NSString stringWithFormat:@"%@",num]);
			}
			else {
				num = [dataForPlot getPercentFromIndex:index];
				//NSLog([NSString stringWithFormat:@"%@",num]);
			}
			
		}
		else 
			num = [NSNumber numberWithInt:-10];
		
	}
	else if ([(NSString *)plot.identifier isEqualToString:@"Orange Plot"])
	{
		
		if([(NSString*)[dataForPlot getStateFromIndex:index] isEqualToString:[Battery dischargingString]]){
			if(fieldEnum == CPScatterPlotFieldX) {
				num = [dataForPlot getNSNumberDateFromIndex:index];
				//NSLog([NSString stringWithFormat:@"%@",num]);
			}
			else {
				num = [dataForPlot getPercentFromIndex:index];
				//NSLog([NSString stringWithFormat:@"%@",num]);
			}
			
		}
		else 
			num = [NSNumber numberWithInt:-10];
		
	}
	else if ([(NSString *)plot.identifier isEqualToString:@"Blue Plot"])
	{
		
		if([(NSString*)[dataForPlot getStateFromIndex:index] isEqualToString:[Battery chargingString]]){
			if(fieldEnum == CPScatterPlotFieldX) {
				num = [dataForPlot getNSNumberDateFromIndex:index];
				//NSLog([NSString stringWithFormat:@"%@",num]);
			}
			else {
				num = [dataForPlot getPercentFromIndex:index];
				//NSLog([NSString stringWithFormat:@"%@",num]);
			}
			
		}
		else 
			num = [NSNumber numberWithInt:-10];
		
	}   
	else if ([(NSString *)plot.identifier isEqualToString:@"Green Plot"])
	{
		
		if([(NSString*)[dataForPlot getStateFromIndex:index] isEqualToString:[Battery fullString]]){
			if(fieldEnum == CPScatterPlotFieldX) {
				num = [dataForPlot getNSNumberDateFromIndex:index];
				//NSLog([NSString stringWithFormat:@"%@",num]);
			}
			else {
				num = [dataForPlot getPercentFromIndex:index];
				//NSLog([NSString stringWithFormat:@"%@",num]);
			}
			
		}
		else 
			num = [NSNumber numberWithInt:-10];
		
	}
	return num;
	
}

@end
