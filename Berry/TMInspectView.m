//
//  TMInspectView.m
//  Berry
//
//  Created by Derek Omuro on 11/20/13.
//  Copyright (c) 2013 teaMango. All rights reserved.
//

#import "TMInspectView.h"

@implementation TMInspectView

@synthesize dateView, barView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        dateView = [[TMDateView alloc]initWithFrame:CGRectMake(0, 0, 137.5, frame.size.height)];
        barView = [[TMBarGraphView alloc]initWithFrame:CGRectMake(137.5, 0, 182.5, frame.size.height)];

        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
        UIView *separator1 = [[UIView alloc] initWithFrame:CGRectMake(137.5, 0, 0.5, frame.size.height)];

        [separator setBackgroundColor:[UIColor lightGrayColor]];
        [separator1 setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:self.dateView];
        [self addSubview:self.barView];
        [self addSubview:separator];
        [self addSubview:separator1];

    }
    return self;
}

- (void)updateWithLog:(TMDailyLog *)aDailyLog {
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MMMM"];
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"d"];
    
    [[dateView dayLabel] setText:[dayFormatter stringFromDate:[aDailyLog date]]];
    [[dateView monthLabel] setText:[monthFormatter stringFromDate:[aDailyLog date]]];
    
    [[barView barChart] setData:[aDailyLog records]];
    if ([[[aDailyLog records] objectAtIndex:0] integerValue] == 0) {
        [[barView morningLabel] setText:nil];
    } else {
        [[barView morningLabel] setText:[NSString stringWithFormat:@"%ld", (long)[[[aDailyLog records] objectAtIndex:0] integerValue]]];
    }
    if ([[[aDailyLog records] objectAtIndex:1] integerValue] == 0) {
        [[barView noonLabel] setText:nil];
    } else {
        [[barView noonLabel] setText:[NSString stringWithFormat:@"%ld", (long)[[[aDailyLog records] objectAtIndex:1] integerValue]]];
    }
    if ([[[aDailyLog records] objectAtIndex:2] integerValue] == 0) {
        [[barView eveningLabel] setText:nil];
    } else {
        [[barView eveningLabel] setText:[NSString stringWithFormat:@"%ld", (long)[[[aDailyLog records] objectAtIndex:2] integerValue]]];
    }
}
@end
