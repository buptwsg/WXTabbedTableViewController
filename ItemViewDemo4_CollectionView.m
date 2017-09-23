//
//  ItemViewDemo4_CollectionView.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/23.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "ItemViewDemo4_CollectionView.h"

@interface ItemViewDemo4_CollectionView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation ItemViewDemo4_CollectionView

- (instancetype)initWithIndex:(NSUInteger)index size:(CGSize)viewSize {
    self = [super initWithIndex: index size: viewSize];
    if (self) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.itemSize = CGSizeMake((viewSize.width - 5 * 2) / 3, 150);
        self.collectionView = [[UICollectionView alloc] initWithFrame: self.bounds collectionViewLayout: flowLayout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self addSubview: self.collectionView];
        
        [self.collectionView registerClass: [UICollectionViewCell class] forCellWithReuseIdentifier: @"cell"];
        self.scrollView = self.collectionView;
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"cell" forIndexPath: indexPath];
    CGFloat r = 1.0 * (arc4random() % 255) / 255;
    CGFloat g = 1.0 * (arc4random() % 255) / 255;
    CGFloat b = 1.0 * (arc4random() % 255) / 255;
    cell.backgroundColor = [UIColor colorWithRed: r green: g blue: b alpha: 1];
    return cell;
}
@end
