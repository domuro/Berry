//
//  GraphViewController.h
//  GitGraph
//
//  Created by Derek Omuro on 11/19/13.
//  Copyright (c) 2013 Derek Omuro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "TMGraphCell.h"
#import "TMGraphCollectionView.h"
#import "TMDailyLog.h"
#import "TMInspectView.h"
#import "TMInputViewController.h"

@interface TMGraphViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate>

@property UICollectionViewCell *selectedCollectionViewCell;

- (void)refreshView;

@end
