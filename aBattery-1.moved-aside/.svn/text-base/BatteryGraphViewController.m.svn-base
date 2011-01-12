//
//  BatteryGraphViewController.m
//  aBattery
//
//  Created by Neel Banerjee on 8/17/09.
//  Copyright 2009 Om Design LLC. All rights reserved.
//

#import "BatteryGraphViewController.h"


@implementation BatteryGraphViewController
@synthesize dataForPlot;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	self.tabBarItem.title         = @"Graph";
	graphThread = [[NSThread alloc] initWithTarget:self selector:@selector(startGraph:) object:nil];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	NSLog(@"BatteryGrpahViewController::didRotateFromInterfaceOrientation");
	//[super viewWillAppear:YES];
	//[self viewWillAppear:YES];
	//[graph setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
}


- (void)viewWillAppear:(BOOL)animated{
	[dataForPlot updateSortedKeys];
	NSLog(@"reload data");
	[graph reloadData];
	//Only Display Graph if there are greater than or equal to 2 points
	if([[dataForPlot sortedKeyArray] count]>=2) {
		[[NSNotificationCenter defaultCenter] addObserver: self 
												 selector: @selector(updateGraph) 
													 name:  UIDeviceBatteryLevelDidChangeNotification
												   object: [UIDevice currentDevice]];
		
		[[NSNotificationCenter defaultCenter] addObserver: self 
												 selector: @selector(updateGraph) 
													 name: UIDeviceBatteryStateDidChangeNotification
												   object: [UIDevice currentDevice]];
		//[super viewDidLoad];
		
		
		// Create graph from theme
		CPTheme *theme = [CPTheme themeNamed:kCPPlainBlackTheme];
		
		graph = (CPXYGraph *)[theme newGraph];	
		CPLayerHostingView *hostingView = (CPLayerHostingView *) self.view;
		hostingView.hostedLayer = graph;
		
		// Padding is the exclusion distance for the plot
		graph.paddingLeft = 10.0;
		graph.paddingTop = 10.0;
		graph.paddingRight = 10.0;
		graph.paddingBottom = 10.0;
		//	Then setup the axis:
		
		// Axes
		CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
		CPXYAxis *x = axisSet.xAxis;
		
		x.axisLabelingPolicy = CPAxisLabelingPolicyNone;
		
		NSArray *exclusionRanges;
		CPXYAxis *y = axisSet.yAxis;
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		y.tickLabelFormatter = numberFormatter;
		
		[numberFormatter release];
		y.majorIntervalLength = CPDecimalFromString(@"25");
		y.minorTicksPerInterval = 5;
		exclusionRanges = [NSArray arrayWithObjects:
						   [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(100.99) length:CPDecimalFromFloat(40)], 
						   [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-20) length:CPDecimalFromFloat(20)],
						   nil];
		y.labelExclusionRanges = exclusionRanges;
		
		
		// Create a white plot area
		CPScatterPlot *boundLinePlot = [[CPScatterPlot alloc] init];
		// This identifier is useful to condition the data based on the plot type 
		boundLinePlot.identifier = @"White Plot";
		/* Miter limits are represented by ratios. In Illustrator, the default miter 
		 limit is 4, and the limit specifies a threshold. Essentially, a miter limit
		 of 4 says: "if the miter length of this join is greater than 4 times my 
		 line thickness, bevel it; otherwise, allow the mitered join." In the left 
		 diagram, the dashed horizontal lines are each one line thickness away from 
		 each other. Notice that the miter length of the first join exceeds 4 times 
		 the thickness of the line. Because of this, Illustrator will bevel the join. 
		 The miter length of the second join falls below 4, so it is mitered (pointy). 
		 So, miter limits in Illustrator represent an either/or situation; either the 
		 line is beveled at the center of the join, or it is mitered. There is no in 
		 between.
		 http://blogs.msdn.com/mswanson/archive/2006/03/23/559698.aspx
		 */ 
		boundLinePlot.dataLineStyle.miterLimit = 1.0f;
		boundLinePlot.dataLineStyle.lineWidth = 3.0f;
		boundLinePlot.dataLineStyle.lineColor = [CPColor darkGrayColor];
		boundLinePlot.dataSource = self;
		
		
		[graph addPlot:boundLinePlot];
		[boundLinePlot release];
		
		// Create a green plot area (Full)
		CPScatterPlot *greenPlot = [[CPScatterPlot alloc] init];
		// This identifier is useful to condition the data based on the plot type 
		greenPlot.identifier = @"Green Plot";
		greenPlot.dataSource = self;
		greenPlot.dataLineStyle.lineWidth = 0.0f;
		CPLineStyle *symbolLineStyle = [CPLineStyle lineStyle];
		symbolLineStyle.lineColor = [CPColor blackColor];
		CPPlotSymbol *plotSymbol = [CPPlotSymbol ellipsePlotSymbol];
		plotSymbol.fill = [CPFill fillWithColor:[CPColor greenColor]];
		plotSymbol.lineStyle = symbolLineStyle;
		plotSymbol.size = CGSizeMake(10.0, 10.0);
		greenPlot.plotSymbol = plotSymbol;
		
		[graph addPlot:greenPlot];
		[greenPlot release];
		
		// Create a orange plot area (Discharging)
		CPScatterPlot *orangePlot = [[CPScatterPlot alloc] init];
		// This identifier is useful to condition the data based on the plot type 
		orangePlot.identifier = @"Orange Plot";
		orangePlot.dataSource = self;
		greenPlot.dataLineStyle.lineWidth = 0.0f;
		
		CPLineStyle *symbolLineStyle2 = [CPLineStyle lineStyle];
		symbolLineStyle2.lineColor = [CPColor blackColor];
		CPPlotSymbol *plotSymbol2 = [CPPlotSymbol ellipsePlotSymbol];
		plotSymbol2.fill = [CPFill fillWithColor:[CPColor colorWithCGColor:[UIColor orangeColor].CGColor]];
		plotSymbol2.lineStyle = symbolLineStyle2;
		plotSymbol2.size = CGSizeMake(10.0, 10.0);
		orangePlot.plotSymbol = plotSymbol2;
		
		[graph addPlot:orangePlot];
		[orangePlot release];
		
		// Create a red plot area (Unknown)
		CPScatterPlot *redPlot = [[CPScatterPlot alloc] init];
		// This identifier is useful to condition the data based on the plot type 
		redPlot.identifier = @"Red Plot";
		redPlot.dataSource = self;
		redPlot.dataLineStyle.lineWidth = 0.0f;
		
		CPLineStyle *symbolLineStyle3 = [CPLineStyle lineStyle];
		symbolLineStyle3.lineColor = [CPColor blackColor];
		CPPlotSymbol *plotSymbol3 = [CPPlotSymbol ellipsePlotSymbol];
		plotSymbol3.fill = [CPFill fillWithColor:[CPColor redColor]];
		plotSymbol3.lineStyle = symbolLineStyle3;
		plotSymbol3.size = CGSizeMake(10.0, 10.0);
		redPlot.plotSymbol = plotSymbol3;
		
		[graph addPlot:redPlot];
		[redPlot release];
		
		// Create a blue plot area (Charging)
		CPScatterPlot *bluePlot = [[CPScatterPlot alloc] init];
		// This identifier is useful to condition the data based on the plot type 
		bluePlot.identifier = @"Blue Plot";
		bluePlot.dataSource = self;
		bluePlot.dataLineStyle.lineWidth = 0.0f;
		
		CPLineStyle *symbolLineStyle4 = [CPLineStyle lineStyle];
		symbolLineStyle4.lineColor = [CPColor blackColor];
		CPPlotSymbol *plotSymbol4 = [CPPlotSymbol ellipsePlotSymbol];
		plotSymbol4.fill = [CPFill fillWithColor:[CPColor blueColor]];
		plotSymbol4.lineStyle = symbolLineStyle4;
		plotSymbol4.size = CGSizeMake(10.0, 10.0);
		bluePlot.plotSymbol = plotSymbol4;
		
		[graph addPlot:bluePlot];
		[bluePlot release];
		
		
		((CPXYPlotSpace *)graph.defaultPlotSpace).yRange = 
		[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-20) length:CPDecimalFromFloat(140.0)];
		
		// Setup plot space
		CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
		
		int secondsFromFirstEntry = 0;
		secondsFromFirstEntry = [[dataForPlot range] intValue];
		
		//CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
		//CPXYAxis *x = axisSet.xAxis;
		
		NSMutableArray *labelArray = [[NSMutableArray alloc]
									  initWithCapacity: 10];
		
		NSMutableArray *tickLocationArray = [[NSMutableArray alloc]
											 initWithCapacity: 10];
		
		//Less than 60 sec
		if(secondsFromFirstEntry<60) {
			x.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"10"] decimalValue];
			x.minorTicksPerInterval = 1;
			[self axisLabelText:@"10" tickLocation:[NSDecimalNumber decimalNumberWithString:@"10"] unitLabel:@"sec" labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"20" tickLocation:[NSDecimalNumber decimalNumberWithString:@"20"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"30" tickLocation:[NSDecimalNumber decimalNumberWithString:@"30"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"40" tickLocation:[NSDecimalNumber decimalNumberWithString:@"40"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"50" tickLocation:[NSDecimalNumber decimalNumberWithString:@"50"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"60" tickLocation:[NSDecimalNumber decimalNumberWithString:@"60"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
		}
		//1min to 60min
		else if(secondsFromFirstEntry>=60 && secondsFromFirstEntry < 60*60) {
			//30 min
			x.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"1800"] decimalValue];
			x.minorTicksPerInterval = 2;
			[self axisLabelText:@"30" tickLocation:[NSDecimalNumber decimalNumberWithString:@"1800"] unitLabel:@"min" labelArray:labelArray tickLocationArray:tickLocationArray];
			
		}
		//1hr to 24hrs
		else if(secondsFromFirstEntry>=60*60 && secondsFromFirstEntry < 60*60*24) {
			//12 hr
			x.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"3600"] decimalValue];
			x.minorTicksPerInterval = 1;
			[self axisLabelText:@"1" tickLocation:[NSDecimalNumber decimalNumberWithString:@"3600"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"12" tickLocation:[NSDecimalNumber decimalNumberWithString:@"43200"] unitLabel:@"hrs" labelArray:labelArray tickLocationArray:tickLocationArray];
		}
		//24hrs to 1 week
		else if(secondsFromFirstEntry>=60*60*24 && secondsFromFirstEntry < 60*60*24*7) {
			//1 day
			//x.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"86400"] decimalValue];
			x.minorTicksPerInterval = 3;
			[self axisLabelText:@"1" tickLocation:[NSDecimalNumber decimalNumberWithString:@"86400"] unitLabel:@" day" labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"2" tickLocation:[NSDecimalNumber decimalNumberWithString:@"172800"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"3" tickLocation:[NSDecimalNumber decimalNumberWithString:@"259200"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"4" tickLocation:[NSDecimalNumber decimalNumberWithString:@"345600"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"5" tickLocation:[NSDecimalNumber decimalNumberWithString:@"432000"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"6" tickLocation:[NSDecimalNumber decimalNumberWithString:@"518400"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
		}
		//1 week to 1month
		else if(secondsFromFirstEntry>=60*60*24*7 && secondsFromFirstEntry < 60*60*24*7*30) {
			//1 week
			x.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"604800"] decimalValue];
			x.minorTicksPerInterval = 7-2;
			[self axisLabelText:@"1" tickLocation:[NSDecimalNumber decimalNumberWithString:@"604800"] unitLabel:@" week" labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"2" tickLocation:[NSDecimalNumber decimalNumberWithString:@"1209600"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"3" tickLocation:[NSDecimalNumber decimalNumberWithString:@"1814400"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			
		}
		//1month to 1year
		else if(secondsFromFirstEntry>=60*60*24*7*30 && secondsFromFirstEntry < 60*60*24*7*4*12) {
			//1 month
			x.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"2419200"] decimalValue];
			[self axisLabelText:@"1" tickLocation:[NSDecimalNumber decimalNumberWithString:@"2419200"] unitLabel:@" month" labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"2" tickLocation:[NSDecimalNumber decimalNumberWithString:@"4838400"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"3" tickLocation:[NSDecimalNumber decimalNumberWithString:@"7257600"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"4" tickLocation:[NSDecimalNumber decimalNumberWithString:@"9676800"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"5" tickLocation:[NSDecimalNumber decimalNumberWithString:@"12096000"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"6" tickLocation:[NSDecimalNumber decimalNumberWithString:@"14515200"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"7" tickLocation:[NSDecimalNumber decimalNumberWithString:@"16934400"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"8" tickLocation:[NSDecimalNumber decimalNumberWithString:@"19353600"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"9" tickLocation:[NSDecimalNumber decimalNumberWithString:@"21772800"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"10" tickLocation:[NSDecimalNumber decimalNumberWithString:@"24192000"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"11" tickLocation:[NSDecimalNumber decimalNumberWithString:@"26611200"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			x.minorTicksPerInterval = 3;
		}
		else {
			
		}
		x.axisLabels =  [NSSet setWithArray:labelArray];
		x.majorTickLocations =  [NSSet setWithArray:tickLocationArray];
		NSArray *minorTickLocations = [self minorTickLocationsFromMajorTickLocationArray:tickLocationArray axis:x];
		x.minorTickLocations =  [NSSet setWithArray:minorTickLocations];
		
		
		[labelArray release];
		[tickLocationArray release];
		//[minorTickLocations release];
		
		if ([[dataForPlot sortedKeyArray] count]==0) {
			plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromInt(-60)
														   length:CPDecimalFromInt(120)];
			
		}
		//Descending case
		else if (secondsFromFirstEntry > 0) {
			plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromInt(-1*secondsFromFirstEntry*.20)
														   length:CPDecimalFromInt(abs(secondsFromFirstEntry)+2*secondsFromFirstEntry*.20)];
			NSLog(@"Descending");
		}
		//Ascending case
		else {
			plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromInt(secondsFromFirstEntry)
														   length:CPDecimalFromInt(abs(secondsFromFirstEntry)+secondsFromFirstEntry*.20)];
			NSLog(@"Ascending");
		}
		
	}
	else {
		CPLayerHostingView *hostingView = (CPLayerHostingView *)self.view;
		//hostingView.hostedLayer = graph;
        hostingView.hostedLayer = nil;
		//[self.view setNeedsDisplay];
	}
	
	/*
	//[graphThread start];
	//NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(removeIndicator) userInfo:nil repeats:YES];
	NSLog(@"Thread start");
	if([graphThread isExecuting]) {
		NSLog(@"thread executing");
		UIView *myview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height)];
		indicatorview = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		indicatorview.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.width/2+46);
		indicatorview.hidesWhenStopped = YES;
		
		CALayer *indicatorLayer = [CALayer layer];
		indicatorLayer.frame = myview.frame;
		indicatorLayer.backgroundColor = [CPColor blackColor].cgColor;
		
		[myview.layer addSublayer:indicatorLayer];
		[indicatorLayer release];
		
		[myview addSubview:indicatorview];
		[self.view addSubview:myview];

		[myview release];
		[indicatorview startAnimating];
		
	}
	*/
	
	
}

- (void) removeIndicator {
	NSLog(@"IN timer");
	if([graphThread isFinished]) {
		NSLog(@"Finished");
		indicatorview.hidden = YES;
	}
}
// This method is invoked from the graph thread
- (void)startGraph:(id)info {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Give the sound thread high priority to keep the timing steady.
    [NSThread setThreadPriority:1.0];
	[dataForPlot updateSortedKeys];
	NSLog(@"reload data");
	[graph reloadData];
	//Only Display Graph if there are greater than or equal to 2 points
	if([[dataForPlot sortedKeyArray] count]>=2) {
		[[NSNotificationCenter defaultCenter] addObserver: self 
												 selector: @selector(updateGraph) 
													 name:  UIDeviceBatteryLevelDidChangeNotification
												   object: [UIDevice currentDevice]];
		
		[[NSNotificationCenter defaultCenter] addObserver: self 
												 selector: @selector(updateGraph) 
													 name: UIDeviceBatteryStateDidChangeNotification
												   object: [UIDevice currentDevice]];
		//[super viewDidLoad];
		
		
		// Create graph from theme
		CPTheme *theme = [CPTheme themeNamed:kCPPlainBlackTheme];
		
		graph = (CPXYGraph *)[theme newGraph];	
		CPLayerHostingView *hostingView = (CPLayerHostingView *) [self.view viewWithTag:1];
		hostingView.hostedLayer = graph;
		
		// Padding is the exclusion distance for the plot
		graph.paddingLeft = 10.0;
		graph.paddingTop = 10.0;
		graph.paddingRight = 10.0;
		graph.paddingBottom = 10.0;
		//	Then setup the axis:
		
		// Axes
		CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
		CPXYAxis *x = axisSet.xAxis;
		
		x.axisLabelingPolicy = CPAxisLabelingPolicyNone;
		
		NSArray *exclusionRanges;
		CPXYAxis *y = axisSet.yAxis;
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		y.tickLabelFormatter = numberFormatter;
		
		[numberFormatter release];
		y.majorIntervalLength = CPDecimalFromString(@"25");
		y.minorTicksPerInterval = 5;
		exclusionRanges = [NSArray arrayWithObjects:
						   [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(100.99) length:CPDecimalFromFloat(40)], 
						   [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-20) length:CPDecimalFromFloat(20)],
						   nil];
		y.labelExclusionRanges = exclusionRanges;
		
		
		// Create a white plot area
		CPScatterPlot *boundLinePlot = [[CPScatterPlot alloc] init];
		// This identifier is useful to condition the data based on the plot type 
		boundLinePlot.identifier = @"White Plot";
		/* Miter limits are represented by ratios. In Illustrator, the default miter 
		 limit is 4, and the limit specifies a threshold. Essentially, a miter limit
		 of 4 says: "if the miter length of this join is greater than 4 times my 
		 line thickness, bevel it; otherwise, allow the mitered join." In the left 
		 diagram, the dashed horizontal lines are each one line thickness away from 
		 each other. Notice that the miter length of the first join exceeds 4 times 
		 the thickness of the line. Because of this, Illustrator will bevel the join. 
		 The miter length of the second join falls below 4, so it is mitered (pointy). 
		 So, miter limits in Illustrator represent an either/or situation; either the 
		 line is beveled at the center of the join, or it is mitered. There is no in 
		 between.
		 http://blogs.msdn.com/mswanson/archive/2006/03/23/559698.aspx
		 */ 
		boundLinePlot.dataLineStyle.miterLimit = 1.0f;
		boundLinePlot.dataLineStyle.lineWidth = 3.0f;
		boundLinePlot.dataLineStyle.lineColor = [CPColor darkGrayColor];
		boundLinePlot.dataSource = self;
		
		
		[graph addPlot:boundLinePlot];
		[boundLinePlot release];
		
		// Create a green plot area (Full)
		CPScatterPlot *greenPlot = [[CPScatterPlot alloc] init];
		// This identifier is useful to condition the data based on the plot type 
		greenPlot.identifier = @"Green Plot";
		greenPlot.dataSource = self;
		greenPlot.dataLineStyle.lineWidth = 0.0f;
		CPLineStyle *symbolLineStyle = [CPLineStyle lineStyle];
		symbolLineStyle.lineColor = [CPColor blackColor];
		CPPlotSymbol *plotSymbol = [CPPlotSymbol ellipsePlotSymbol];
		plotSymbol.fill = [CPFill fillWithColor:[CPColor greenColor]];
		plotSymbol.lineStyle = symbolLineStyle;
		plotSymbol.size = CGSizeMake(10.0, 10.0);
		greenPlot.plotSymbol = plotSymbol;
		
		[graph addPlot:greenPlot];
		[greenPlot release];
		
		// Create a orange plot area (Discharging)
		CPScatterPlot *orangePlot = [[CPScatterPlot alloc] init];
		// This identifier is useful to condition the data based on the plot type 
		orangePlot.identifier = @"Orange Plot";
		orangePlot.dataSource = self;
		greenPlot.dataLineStyle.lineWidth = 0.0f;
		
		CPLineStyle *symbolLineStyle2 = [CPLineStyle lineStyle];
		symbolLineStyle2.lineColor = [CPColor blackColor];
		CPPlotSymbol *plotSymbol2 = [CPPlotSymbol ellipsePlotSymbol];
		plotSymbol2.fill = [CPFill fillWithColor:[CPColor colorWithCGColor:[UIColor orangeColor].CGColor]];
		plotSymbol2.lineStyle = symbolLineStyle2;
		plotSymbol2.size = CGSizeMake(10.0, 10.0);
		orangePlot.plotSymbol = plotSymbol2;
		
		[graph addPlot:orangePlot];
		[orangePlot release];
		
		// Create a red plot area (Unknown)
		CPScatterPlot *redPlot = [[CPScatterPlot alloc] init];
		// This identifier is useful to condition the data based on the plot type 
		redPlot.identifier = @"Red Plot";
		redPlot.dataSource = self;
		redPlot.dataLineStyle.lineWidth = 0.0f;
		
		CPLineStyle *symbolLineStyle3 = [CPLineStyle lineStyle];
		symbolLineStyle3.lineColor = [CPColor blackColor];
		CPPlotSymbol *plotSymbol3 = [CPPlotSymbol ellipsePlotSymbol];
		plotSymbol3.fill = [CPFill fillWithColor:[CPColor redColor]];
		plotSymbol3.lineStyle = symbolLineStyle3;
		plotSymbol3.size = CGSizeMake(10.0, 10.0);
		redPlot.plotSymbol = plotSymbol3;
		
		[graph addPlot:redPlot];
		[redPlot release];
		
		// Create a blue plot area (Charging)
		CPScatterPlot *bluePlot = [[CPScatterPlot alloc] init];
		// This identifier is useful to condition the data based on the plot type 
		bluePlot.identifier = @"Blue Plot";
		bluePlot.dataSource = self;
		bluePlot.dataLineStyle.lineWidth = 0.0f;
		
		CPLineStyle *symbolLineStyle4 = [CPLineStyle lineStyle];
		symbolLineStyle4.lineColor = [CPColor blackColor];
		CPPlotSymbol *plotSymbol4 = [CPPlotSymbol ellipsePlotSymbol];
		plotSymbol4.fill = [CPFill fillWithColor:[CPColor blueColor]];
		plotSymbol4.lineStyle = symbolLineStyle4;
		plotSymbol4.size = CGSizeMake(10.0, 10.0);
		bluePlot.plotSymbol = plotSymbol4;
		
		[graph addPlot:bluePlot];
		[bluePlot release];
		
		
		((CPXYPlotSpace *)graph.defaultPlotSpace).yRange = 
		[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-20) length:CPDecimalFromFloat(140.0)];
		
		// Setup plot space
		CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
		
		int secondsFromFirstEntry = 0;
		secondsFromFirstEntry = [[dataForPlot range] intValue];
		
		//CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
		//CPXYAxis *x = axisSet.xAxis;
		
		NSMutableArray *labelArray = [[NSMutableArray alloc]
									  initWithCapacity: 10];
		
		NSMutableArray *tickLocationArray = [[NSMutableArray alloc]
											 initWithCapacity: 10];
		
		//Less than 60 sec
		if(secondsFromFirstEntry<60) {
			x.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"10"] decimalValue];
			x.minorTicksPerInterval = 1;
			[self axisLabelText:@"10" tickLocation:[NSDecimalNumber decimalNumberWithString:@"10"] unitLabel:@"sec" labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"20" tickLocation:[NSDecimalNumber decimalNumberWithString:@"20"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"30" tickLocation:[NSDecimalNumber decimalNumberWithString:@"30"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"40" tickLocation:[NSDecimalNumber decimalNumberWithString:@"40"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"50" tickLocation:[NSDecimalNumber decimalNumberWithString:@"50"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"60" tickLocation:[NSDecimalNumber decimalNumberWithString:@"60"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
		}
		//1min to 60min
		else if(secondsFromFirstEntry>=60 && secondsFromFirstEntry < 60*60) {
			//30 min
			x.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"1800"] decimalValue];
			x.minorTicksPerInterval = 2;
			[self axisLabelText:@"30" tickLocation:[NSDecimalNumber decimalNumberWithString:@"1800"] unitLabel:@"min" labelArray:labelArray tickLocationArray:tickLocationArray];
			
		}
		//1hr to 24hrs
		else if(secondsFromFirstEntry>=60*60 && secondsFromFirstEntry < 60*60*24) {
			//12 hr
			x.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"3600"] decimalValue];
			x.minorTicksPerInterval = 1;
			[self axisLabelText:@"1" tickLocation:[NSDecimalNumber decimalNumberWithString:@"3600"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"12" tickLocation:[NSDecimalNumber decimalNumberWithString:@"43200"] unitLabel:@"hrs" labelArray:labelArray tickLocationArray:tickLocationArray];
		}
		//24hrs to 1 week
		else if(secondsFromFirstEntry>=60*60*24 && secondsFromFirstEntry < 60*60*24*7) {
			//1 day
			//x.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"86400"] decimalValue];
			x.minorTicksPerInterval = 3;
			[self axisLabelText:@"1" tickLocation:[NSDecimalNumber decimalNumberWithString:@"86400"] unitLabel:@" day" labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"2" tickLocation:[NSDecimalNumber decimalNumberWithString:@"172800"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"3" tickLocation:[NSDecimalNumber decimalNumberWithString:@"259200"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"4" tickLocation:[NSDecimalNumber decimalNumberWithString:@"345600"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"5" tickLocation:[NSDecimalNumber decimalNumberWithString:@"432000"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"6" tickLocation:[NSDecimalNumber decimalNumberWithString:@"518400"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
		}
		//1 week to 1month
		else if(secondsFromFirstEntry>=60*60*24*7 && secondsFromFirstEntry < 60*60*24*7*30) {
			//1 week
			x.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"604800"] decimalValue];
			x.minorTicksPerInterval = 7-2;
			[self axisLabelText:@"1" tickLocation:[NSDecimalNumber decimalNumberWithString:@"604800"] unitLabel:@" week" labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"2" tickLocation:[NSDecimalNumber decimalNumberWithString:@"1209600"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"3" tickLocation:[NSDecimalNumber decimalNumberWithString:@"1814400"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			
		}
		//1month to 1year
		else if(secondsFromFirstEntry>=60*60*24*7*30 && secondsFromFirstEntry < 60*60*24*7*4*12) {
			//1 month
			x.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"2419200"] decimalValue];
			[self axisLabelText:@"1" tickLocation:[NSDecimalNumber decimalNumberWithString:@"2419200"] unitLabel:@" month" labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"2" tickLocation:[NSDecimalNumber decimalNumberWithString:@"4838400"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"3" tickLocation:[NSDecimalNumber decimalNumberWithString:@"7257600"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"4" tickLocation:[NSDecimalNumber decimalNumberWithString:@"9676800"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"5" tickLocation:[NSDecimalNumber decimalNumberWithString:@"12096000"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"6" tickLocation:[NSDecimalNumber decimalNumberWithString:@"14515200"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"7" tickLocation:[NSDecimalNumber decimalNumberWithString:@"16934400"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"8" tickLocation:[NSDecimalNumber decimalNumberWithString:@"19353600"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"9" tickLocation:[NSDecimalNumber decimalNumberWithString:@"21772800"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"10" tickLocation:[NSDecimalNumber decimalNumberWithString:@"24192000"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			[self axisLabelText:@"11" tickLocation:[NSDecimalNumber decimalNumberWithString:@"26611200"] unitLabel:nil labelArray:labelArray tickLocationArray:tickLocationArray];
			x.minorTicksPerInterval = 3;
		}
		else {
			
		}
		x.axisLabels =  [NSSet setWithArray:labelArray];
		x.majorTickLocations =  [NSSet setWithArray:tickLocationArray];
		NSArray *minorTickLocations = [self minorTickLocationsFromMajorTickLocationArray:tickLocationArray axis:x];
		x.minorTickLocations =  [NSSet setWithArray:minorTickLocations];
		
		
		[labelArray release];
		[tickLocationArray release];
		//[minorTickLocations release];
		
		if ([[dataForPlot sortedKeyArray] count]==0) {
			plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromInt(-60)
														   length:CPDecimalFromInt(120)];
			
		}
		//Descending case
		else if (secondsFromFirstEntry > 0) {
			plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromInt(-1*secondsFromFirstEntry*.20)
														   length:CPDecimalFromInt(abs(secondsFromFirstEntry)+2*secondsFromFirstEntry*.20)];
			NSLog(@"Descending");
		}
		//Ascending case
		else {
			plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromInt(secondsFromFirstEntry)
														   length:CPDecimalFromInt(abs(secondsFromFirstEntry)+secondsFromFirstEntry*.20)];
			NSLog(@"Ascending");
		}
		
	}
	else {
		CPLayerHostingView *hostingView = (CPLayerHostingView *)self.view;
		//hostingView.hostedLayer = graph;
        hostingView.hostedLayer = nil;
		//[self.view setNeedsDisplay];
	}
	
	[pool drain];
}

- (void)dealloc {
	[dataForPlot release];
	[graphThread release];
	[indicatorview release];
    [super dealloc];
}
#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
    //return [dataForPlot count];
	return [[dataForPlot sortedKeyArray] count];
}

-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
	NSNumber *num;
	// White plot gets everything
	if ([(NSString *)plot.identifier isEqualToString:@"White Plot"])
	{
		if(fieldEnum == CPScatterPlotFieldX) {
			num = [dataForPlot getSecondsFromFirstEntryIndex:index];
			NSLog([NSString stringWithFormat:@"%@",num]);
		}
		else {
			num = [dataForPlot getPercentFromIndex:index];
			NSLog([NSString stringWithFormat:@"%@",num]);
		}
	}
	else if ([(NSString *)plot.identifier isEqualToString:@"Red Plot"])
	{
		
		if([(NSString*)[dataForPlot getStateFromIndex:index] isEqualToString:[Battery unknownString]]){
			if(fieldEnum == CPScatterPlotFieldX) {
				num = [dataForPlot getSecondsFromFirstEntryIndex:index];
				NSLog([NSString stringWithFormat:@"%@",num]);
			}
			else {
				num = [dataForPlot getPercentFromIndex:index];
				NSLog([NSString stringWithFormat:@"%@",num]);
			}
		
		}
		else 
			num = [NSNumber numberWithInt:2000];
		
	}
	else if ([(NSString *)plot.identifier isEqualToString:@"Orange Plot"])
	{
		
		if([(NSString*)[dataForPlot getStateFromIndex:index] isEqualToString:[Battery dischargingString]]){
			if(fieldEnum == CPScatterPlotFieldX) {
				num = [dataForPlot getSecondsFromFirstEntryIndex:index];
				NSLog([NSString stringWithFormat:@"%@",num]);
			}
			else {
				num = [dataForPlot getPercentFromIndex:index];
				NSLog([NSString stringWithFormat:@"%@",num]);
			}
			
		}
		else 
			num = [NSNumber numberWithInt:2000];
		
	}
	else if ([(NSString *)plot.identifier isEqualToString:@"Blue Plot"])
	{
		
		if([(NSString*)[dataForPlot getStateFromIndex:index] isEqualToString:[Battery chargingString]]){
			if(fieldEnum == CPScatterPlotFieldX) {
				num = [dataForPlot getSecondsFromFirstEntryIndex:index];
				NSLog([NSString stringWithFormat:@"%@",num]);
			}
			else {
				num = [dataForPlot getPercentFromIndex:index];
				NSLog([NSString stringWithFormat:@"%@",num]);
			}
			
		}
		else 
			num = [NSNumber numberWithInt:2000];
		
	}   
	else if ([(NSString *)plot.identifier isEqualToString:@"Green Plot"])
	{
		
		if([(NSString*)[dataForPlot getStateFromIndex:index] isEqualToString:[Battery fullString]]){
			if(fieldEnum == CPScatterPlotFieldX) {
				num = [dataForPlot getSecondsFromFirstEntryIndex:index];
				NSLog([NSString stringWithFormat:@"%@",num]);
			}
			else {
				num = [dataForPlot getPercentFromIndex:index];
				NSLog([NSString stringWithFormat:@"%@",num]);
			}
			
		}
		else 
			num = [NSNumber numberWithInt:2000];
		
	}
	return num;
}

-(void) axisLabelText:(NSString*) text tickLocation:(NSDecimalNumber*) 
		tickLocation unitLabel:(NSString *) unit labelArray:(NSMutableArray*) customLabels 
	    tickLocationArray: (NSMutableArray*) tickLocations {
	CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
    CPXYAxis *x = axisSet.xAxis;
	CPAxisLabel *newLabel;
	
	if(unit == nil)
		newLabel = [[CPAxisLabel alloc] initWithText: text textStyle:x.axisLabelTextStyle];
	else
		newLabel = [[CPAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%@ %@",text,unit] textStyle:x.axisLabelTextStyle];
	
	newLabel.tickLocation = [tickLocation decimalValue];
	newLabel.textStyle    = x.axisLabelTextStyle;
	newLabel.offset       = x.axisLabelOffset + x.majorTickLength;
	[customLabels addObject:newLabel];
	[tickLocations addObject:tickLocation];
	
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
-(void)updateGraph {
	[graph reloadData];
}

@end
