//
//  GraphCell.h
//  GitGraph
//
//  Created by Derek Omuro on 11/19/13.
//  Copyright (c) 2013 Derek Omuro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMGraphCollectionView.h"

static NSString *CollectionViewCellIdentifier = @"CollectionViewCellIdentifier";

@interface TMGraphCell : UITableViewCell

@property (nonatomic, strong) TMGraphCollectionView *collectionView;

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index;

@end
