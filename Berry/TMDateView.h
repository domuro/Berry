//
//  TMMaxView.h
//  Berry
//
//  Created by Derek Omuro on 11/20/13.
//  Copyright (c) 2013 teaMango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMDateView : UIView

@property(strong, nonatomic) UILabel *dayLabel;
@property(strong, nonatomic) UILabel *monthLabel;
@property(strong, nonatomic) NSDateFormatter *dateFormatter;

@end
