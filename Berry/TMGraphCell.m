//
//  GraphCell.m
//  GitGraph
//
//  Created by Derek Omuro on 11/19/13.
//  Copyright (c) 2013 Derek Omuro. All rights reserved.
//

#import "TMGraphCell.h"

@implementation TMGraphCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSize = CGSizeMake(40, 40);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[TMGraphCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
    self.collectionView.frame = self.contentView.bounds;
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.collectionView.contentSize.width, self.collectionView.contentSize.height);
    [self setFrame:frame];

    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.contentView.bounds;
}

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.index = index;
    
    [self.collectionView reloadData];
}

@end
