//
//  TMInputViewController.h
//  Berry
//
//  Created by Derek Omuro on 11/20/13.
//  Copyright (c) 2013 teaMango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMGraphViewController.h"
#import "TMBerryTextField.h"
#import "TMDailyLog.h"

@class TMGraphViewController;

@interface TMInputViewController : UIViewController

@property TMBerryTextField *dummyTextField;
@property TMGraphViewController *sourceViewController;
@property UILabel *displayText;
@property UISegmentedControl *timeControl;
@property NSInteger timeControlSelectedIndex;
@property TMDailyLog *selectedLog;

//@property (strong, nonatomic) UIScrollView *notesScrollView;
//@property (strong, nonatomic) UIPageControl *notesPageControl;

@end
