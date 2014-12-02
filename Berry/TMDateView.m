//
//  TMMaxView.m
//  Berry
//
//  Created by Derek Omuro on 11/20/13.
//  Copyright (c) 2013 teaMango. All rights reserved.
//

#import "TMDateView.h"
#include "TMDailyLog.h"
@implementation TMDateView

@synthesize monthLabel, dayLabel, dateFormatter;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];

        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, frame.size.width, 24)];
        monthLabel.textAlignment = NSTextAlignmentCenter;
        monthLabel.font = [UIFont systemFontOfSize:24.0f];
        dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, frame.size.width, 78)];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.font = [UIFont systemFontOfSize:78.0f];

        //[dayLabel setText:@"22"];
        //[monthLabel setText:@"November"];
        [self addSubview:dayLabel];
        [self addSubview:monthLabel];
    }
    return self;

}

@end
