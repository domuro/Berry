//
//  TMInputViewController.m
//  Berry
//
//  Created by Derek Omuro on 11/20/13.
//  Copyright (c) 2013 teaMango. All rights reserved.
//

#import "TMInputViewController.h"

@interface TMInputViewController ()

@end

@implementation TMInputViewController

@synthesize dummyTextField, displayText, timeControl, selectedLog, timeControlSelectedIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [[[self navigationController] navigationBar] setBarStyle:UIBarStyleDefault];
    [[[self navigationController] navigationBar] setTranslucent:NO];
    
    //NSLog(@"%@", [[self selectedLog] date]);
    [[self navigationItem] setTitle:[NSDateFormatter localizedStringFromDate:[[self selectedLog] date]
                                                                   dateStyle:NSDateFormatterMediumStyle
                                                                   timeStyle:NSDateFormatterNoStyle]];
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)]];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)]];
    
    [self setTimeControl:[[UISegmentedControl alloc] initWithItems:@[@"Morning", @"Noon", @"Evening"]]];
    [timeControl setFrame:CGRectMake(15, 10, 290, 30)];
    [timeControl addTarget:self action:@selector(timeControlChanged) forControlEvents:UIControlEventValueChanged];
    [[self view] addSubview:timeControl];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 49.5, 320, 0.5)];
    label.backgroundColor = [UIColor lightGrayColor];
    [[self view] addSubview:label];
    
    [self setDisplayText:[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 120)]];
    [displayText setFont:[UIFont systemFontOfSize:120]];
    [displayText setTextAlignment:NSTextAlignmentRight];
    
    NSInteger currentHour = [[[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:[NSDate date]] hour];
    NSInteger index;
    if (currentHour >= 0 && currentHour < 11) {
        index = 0;
    } else if (currentHour >= 11 && currentHour < 17) {
        index = 1;
    } else {
        index = 2;
    }
    
    [self setDummyTextField:[[TMBerryTextField alloc] initWithFrame:CGRectMake(0, 568, 1, 1)]];
    [dummyTextField setKeyboardType:UIKeyboardTypeNumberPad];
    df
    [dummyTextField setText:[NSString stringWithFormat:@"%@", [[selectedLog records] objectAtIndex:index]]];
    [dummyTextField sendActionsForControlEvents:UIControlEventEditingChanged];
    timeControlSelectedIndex = index;
    [timeControl setSelectedSegmentIndex:index];
    
    [[self view] addSubview:dummyTextField];
    [[self view] addSubview:displayText];
 
    [dummyTextField becomeFirstResponder];
}

- (void)dummyChanged
{
    [displayText setText:[dummyTextField displayNumber]];
}

- (void)timeControlChanged
{
    // Save the change to self.selectedLog
    NSMutableArray *records = [[selectedLog records] mutableCopy];
    [records replaceObjectAtIndex:timeControlSelectedIndex withObject:[dummyTextField number]];
    [[self selectedLog] setRecords:[records copy]];
    // Change the data to another time in a day
    [dummyTextField setText:[NSString stringWithFormat:@"%@", [[selectedLog records] objectAtIndex:[timeControl selectedSegmentIndex]]]];
    [self dummyChanged];
    timeControlSelectedIndex = [timeControl selectedSegmentIndex];
}

- (void)done
{
    [self timeControlChanged];
    [[self selectedLog] writeToDisk];
    //[self sourceViewController]
    [self dismissViewControllerAnimated:YES completion:nil];
    [[self sourceViewController] refreshView];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
