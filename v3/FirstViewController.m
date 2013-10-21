//
//  FirstViewController.m
//  v3
//
//  Created by d246967 on 17/10/13.
//  Copyright (c) 2013 d246967. All rights reserved.
//

#import "FirstViewController.h"
#import "TestXYTheme.h"

NSString *kPlotIdentifier       = @"Data Source Plot";
const double kTimePeriod = 60.0 * 2; // 1 Minute
const double kFrameRate         = 5.0;  // frames per second
const double kAlpha             = 0.25; // smoothing constant

@interface DataObj : NSObject {
    NSTimeInterval timeInterval;
    double dlValue;
    double ulValue;
}
@property(readwrite) NSTimeInterval timeInterval;
@property(readwrite) double dlValue;
@property(readwrite) double ulValue;
@end

@implementation DataObj
@synthesize timeInterval;
@synthesize dlValue;
@synthesize ulValue;

@end


@implementation FirstViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self downloadGraph];
    
}


#pragma mark Test Methods

- (void) downloadGraph
{
    
    // Set a reference Date
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss a"];
    
    CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    timeFormatter.referenceDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    
    
    
    // Create graph from a custom theme
    graph1 = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [[TestXYTheme alloc] init];
    [graph1 applyTheme:theme];
    
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
    hostingView.hostedGraph = graph1;
    
    graph1.plotAreaFrame.paddingTop    = 15.0;
    graph1.plotAreaFrame.paddingRight  = 15.0;
    graph1.plotAreaFrame.paddingBottom = 60.0;
    graph1.plotAreaFrame.paddingLeft   = 55.0;
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.5];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    
    // Axes
    // X axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph1.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    x.orthogonalCoordinateDecimal = CPTDecimalFromUnsignedInteger(0);
    x.majorGridLineStyle          = majorGridLineStyle;
    x.minorGridLineStyle          = minorGridLineStyle;
    x.minorTicksPerInterval       = 9;
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterNoStyle;
    dateFormatter.timeStyle = kCFDateFormatterMediumStyle;
    //    CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    timeFormatter.referenceDate = referenceDate;
    x.labelFormatter            = timeFormatter;
    //    x.title                     =@"Time Axis";
    x.majorIntervalLength = CPTDecimalFromInteger(30);
    x.minorTicksPerInterval = 0;
    
    
    // Y axis
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength =  CPTDecimalFromInteger(10);
    y.minorTicksPerInterval = 5;
    y.labelOffset = 0;
    y.majorGridLineStyle = majorGridLineStyle;
    y.minorGridLineStyle = minorGridLineStyle;
    y.preferredNumberOfMajorTicks = 10;
    y.minorTickLineStyle = nil;
    y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInteger(0) length:CPTDecimalFromInteger(100)];
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    y.title=@"Mbps";
    
    // Rotate the labels by 45 degrees, just to show it can be done.
    //    x.labelRotation = M_PI * 0.25;
    
    // Create the plot
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init] ;
    dataSourceLinePlot.identifier     = kPlotIdentifier;
    dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 2.0;
    lineStyle.lineColor              = [CPTColor yellowColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph1 addPlot:dataSourceLinePlot];
    
    // Plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph1.defaultPlotSpace;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0) length:CPTDecimalFromDouble(kTimePeriod)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(0) length:CPTDecimalFromUnsignedInteger(100)];
    
    plotData  = [[NSMutableArray alloc] init];
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / kFrameRate
                                                   target:self
                                                 selector:@selector(scrollPlot:)
                                                 userInfo:nil
                                                  repeats:YES];
    
    newDLData = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(newData:)
                                               userInfo:nil
                                                repeats:YES];
    
    newULData = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(newData:)
                                               userInfo:nil
                                                repeats:YES];
    
}




#pragma mark Test Methods

-(void)scrollPlot:(NSTimer *)theTimer
{
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;

    CPTGraph *theGraph = hostingView.hostedGraph;
    
    CPTPlot *thePlot   = [theGraph plotWithIdentifier:kPlotIdentifier];
    
    NSTimeInterval aTimeInterval = [[NSDate date]timeIntervalSinceReferenceDate];

    
    if ( thePlot ) {
        currentIndex = aTimeInterval-kTimePeriod;
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)theGraph.defaultPlotSpace;
        double location       = currentIndex;
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(location)
                                                        length:CPTDecimalFromDouble(kTimePeriod)];
        
    }
}




-(void)newData:(NSTimer *)theTimer
{
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;

    CPTGraph *theGraph = hostingView.hostedGraph;
    CPTPlot *thePlot   = [theGraph plotWithIdentifier:kPlotIdentifier];
    
    if ( thePlot ) {
        DataObj *test = [[DataObj alloc] init];

        NSTimeInterval aTimeInterval = [[NSDate date]timeIntervalSinceReferenceDate];
        test.timeInterval = aTimeInterval;
        
        NSError* error;
        NSData* data = [NSData dataWithContentsOfURL:dataURL];
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        
        NSNumber *dlData = [json objectForKey:@"dl"];
        NSNumber *ulData = [json objectForKey:@"ul"];

        test.dlValue =[dlData floatValue];
        test.ulValue = [ulData floatValue];
        
//        NSLog(@"Download data is : %@, %f", dlData,[dlData floatValue]  );
//        test.dlValue = (rand() / (double)RAND_MAX) * 100;
        
        [plotData addObject:test];
        [thePlot insertDataAtIndex:plotData.count - 1 numberOfRecords:1];
    }
}

#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [plotData count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num = nil;
    DataObj *dataObj = [plotData objectAtIndex:index];
    switch ( fieldEnum ) {
        case CPTScatterPlotFieldX:
            num = [NSNumber numberWithDouble:dataObj.timeInterval];
            break;
            
        case CPTScatterPlotFieldY:
            num = [NSNumber numberWithDouble:dataObj.dlValue];
            break;
            
        default:
            break;
    }
    
    return num;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
