//
//  BerryTextField.m
//  Tai
//
//  Created by App Jam on 11/18/13.
//  Copyright (c) 2013 App Jam. All rights reserved.
//

#import "TMBerryTextField.h"

@implementation TMBerryTextField

@synthesize number;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}

- (NSString *)displayNumber
{
    [self setText:[[[self text] componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet] ] componentsJoinedByString:@""]];
    if ([[self text] length] == 1 && [[self text] isEqualToString:@"0"]) {
        [self setText:[[self text] substringFromIndex:1]];
    } else if ([[self text] length] > 4) {
        [self setText:[[self text] substringToIndex:4]];
    }
    NSInteger textLength = [[self text] length];
    NSString *textWithDecimalPoint;
    if (textLength == 0) {
        textWithDecimalPoint = @"0.0";
    } else if (textLength <= 2) {
        textWithDecimalPoint = [[self text] stringByAppendingString:@".0"];
    } else {
        NSInteger intValue = [[self text] integerValue];
        NSInteger digitAfterDes = 0;
        if (intValue >= 35 && intValue < 350) {
            textWithDecimalPoint = [[self text] stringByAppendingString:@".0"];
        } else {
            while (!(intValue >= 35 && intValue < 350)) {
                intValue = intValue / 10;
                digitAfterDes += 1;
            }
            textWithDecimalPoint = [[[[self text] substringToIndex:(textLength - digitAfterDes)] stringByAppendingString:@"."] stringByAppendingString:[[self text] substringFromIndex:(textLength - digitAfterDes)]];
        }
        
    }
    double doubleNumber = [textWithDecimalPoint doubleValue];
    [self setNumber:[NSNumber numberWithDouble:doubleNumber]];

//    if (floatNumber >= 35 && floatNumber < 350) {
//        [self setNumber:[NSNumber numberWithFloat:floatNumber]];
//    } else {
//        [self setNumber:@0];
//    }
    
    return textWithDecimalPoint;
}

@end
