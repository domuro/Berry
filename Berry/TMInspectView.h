//
//  TMInspectView.h
//  Berry
//
//  Created by Derek Omuro on 11/20/13.
//  Copyright (c) 2013 teaMango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMDailyLog.h"
#import "TMDateView.h"
#import "TMBarGraphView.h"
@interface TMInspectView : UIView

@property(strong, nonatomic) TMDateView* dateView;
@property(strong, nonatomic) TMBarGraphView* barView;

- (void)updateWithLog:(TMDailyLog *)log;

@end
