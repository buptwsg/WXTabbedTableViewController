//
//  WXTabView.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "WXTabView.h"
#import "WXTabItemBaseView.h"

@interface WXTabView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIView<WXTabTitleViewProtocol> *titleView;
@property (strong, nonatomic) UIScrollView *horizontalScrollView;

@end

@implementation WXTabView

- (instancetype)initWithFrame:(CGRect)frame titleView:(UIView<WXTabTitleViewProtocol> *)titleView {
    self = [super initWithFrame: frame];
    if (self) {
        _titleView = titleView;
        [self addSubview: _titleView];
        
        CGFloat titleHeight = _titleView.frame.size.height;
        _horizontalScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, titleHeight, frame.size.width, frame.size.height - titleHeight)];
        _horizontalScrollView.delegate = self;
        _horizontalScrollView.pagingEnabled = YES;
        _horizontalScrollView.showsVerticalScrollIndicator = NO;
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
        _horizontalScrollView.contentSize = CGSizeMake(_titleView.tabTitles.count * _horizontalScrollView.frame.size.width, _horizontalScrollView.frame.size.height);
        [self addSubview: _horizontalScrollView];
    }
    
    return self;
}

- (void)addItemView:(WXTabItemBaseView *)itemView {
    [_horizontalScrollView addSubview: itemView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.outerScrollView.scrollEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self handleScrollEnd];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self handleScrollEnd];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self handleScrollEnd];
}

#pragma mark - private
- (void)handleScrollEnd {
    self.outerScrollView.scrollEnabled = YES;
    NSUInteger tab = self.horizontalScrollView.contentOffset.x / self.horizontalScrollView.frame.size.width;
    [self.titleView setSelectedItem: tab];
}

@end
