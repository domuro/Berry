//
//  TMBarGraphView.m
//  Berry
//
//  Created by App Jam on 11/21/13.
//  Copyright (c) 2013 teaMango. All rights reserved.
//

#import "TMBarGraphView.h"

@implementation TMBarGraphView

@synthesize barChart, morningLabel, noonLabel, eveningLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        barChart = [[TEABarChart alloc] initWithFrame:CGRectMake(25, 20, frame.size.width - 50, frame.size.height - 55)];
        barChart.barSpacing = 16;
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(20, frame.size.height - 35, frame.size.width - 40, 0.5)];
        [separator setBackgroundColor:[UIColor lightGrayColor]];
        morningLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 110, 33.5, 20)];
        [morningLabel setTextAlignment:NSTextAlignmentCenter];
        [morningLabel setFont:[UIFont systemFontOfSize:17]];
        noonLabel = [[UILabel alloc] initWithFrame:CGRectMake(74.5, 110, 33.5, 20)];
        [noonLabel setTextAlignment:NSTextAlignmentCenter];
        [noonLabel setFont:[UIFont systemFontOfSize:17]];
        eveningLabel = [[UILabel alloc] initWithFrame:CGRectMake(124, 110, 33.5, 20)];
        [eveningLabel setTextAlignment:NSTextAlignmentCenter];
        [eveningLabel setFont:[UIFont systemFontOfSize:17]];


        //self.barChart.barColor = [UIColor cyanColor];
        //self.barChart.backgroundColor = [UIColor clearColor];
        
        [self addSubview:barChart];
        [self addSubview:separator];
        [self addSubview:morningLabel];
        [self addSubview:noonLabel];
        [self addSubview:eveningLabel];
    }
    return self;
}

@end
