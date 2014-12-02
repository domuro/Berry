//
//  TMBarGraphView.h
//  Berry
//
//  Created by App Jam on 11/21/13.
//  Copyright (c) 2013 teaMango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEABarChart.h"

@interface TMBarGraphView : UIView

@property TEABarChart* barChart;
@property UILabel *morningLabel;
@property UILabel *noonLabel;
@property UILabel *eveningLabel;

@end
