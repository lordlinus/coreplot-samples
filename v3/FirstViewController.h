//
//  FirstViewController.h
//  v3
//
//  Created by d246967 on 17/10/13.
//  Copyright (c) 2013 d246967. All rights reserved.
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define dataURL [NSURL URLWithString:@"http://localhost/data.json"]

@interface FirstViewController : UIViewController<CPTPlotDataSource>
{
    IBOutlet CPTXYGraph *graph1;
    NSMutableArray *plotData;
    double currentIndex;
    NSDate *referenceDate;
    NSTimer *scrollTimer;
    NSTimer *newDLData,*newULData;
    
}

@end