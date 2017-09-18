//
//  HJTabView.m
//  living
//
//  Created by wang shuguang on 2016/10/28.
//  Copyright © 2016年 MJHF. All rights reserved.
//

#import "HJTabView.h"
#import "HJTabTitleView.h"
#import "HJTabItemBaseView.h"
#import "HJOtherHomeScrollView.h"
#import "HJOtherHomeConst.h"
#import "HJPriMsgBorderAndMedalManager.h"
@interface HJTabView()<UIScrollViewDelegate>

@property (nonatomic, strong) HJOtherHomeScrollView *tabContentView;

@end

@implementation HJTabView

-(instancetype)initWithFrame:(CGRect)frame tabTitleArray:(NSArray *)tabTitleArray{
    self = [super initWithFrame: CGRectZero];
    if (self) {
        self.frame = frame;
        
        _tabTitleView = [[HJTabTitleView alloc] initWithTitleArray: tabTitleArray];
        if (tabTitleArray.count < 2) {
            _tabTitleView.frame = RectSetHeight(_tabTitleView, 0);
        }
        
        __weak typeof(self) weakSelf = self;
        _tabTitleView.titleClickBlock = ^(NSInteger row){
            if (weakSelf.tabContentView) {
                weakSelf.tabContentView.contentOffset = CGPointMake(KScreenWidth * row, 0);
                
                [weakSelf notifyViewWillDisappear];
                weakSelf.tabContentView.currentPage = row;
                [weakSelf notifyViewWillAppear];
                
                [weakSelf logTab];
            }
        };
        
        [self addSubview:_tabTitleView];
        
        _tabContentView = [[HJOtherHomeScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tabTitleView.frame), KScreenWidth, CGRectGetHeight(self.frame) - CGRectGetHeight(_tabTitleView.frame))];
        _tabContentView.contentSize = CGSizeMake(CGRectGetWidth(_tabContentView.frame)*tabTitleArray.count, CGRectGetHeight(_tabContentView.frame));
        _tabContentView.pagingEnabled = YES;
        _tabContentView.bounces = NO;
        _tabContentView.showsHorizontalScrollIndicator = NO;
        _tabContentView.directionalLockEnabled = YES;
        _tabContentView.delegate = self;
        [self addSubview:_tabContentView];
        
        [self logTab];
    }
    return self;
}

- (void)addTabItemView:(HJTabItemBaseView *)itemView {
    CGRect itemFrame = self.tabContentView.bounds;
    itemFrame.origin.x = itemView.index * itemFrame.size.width;
    itemView.frame = itemFrame;
    [self.tabContentView addSubview: itemView];
}

- (void)startAcceptMessage {
    for (UIView *view in _tabContentView.subviews) {
        if ([view isKindOfClass: [HJTabItemBaseView class]]) {
            [(HJTabItemBaseView*)view startAcceptMessage];
        }
    }
}

- (void)stopAcceptMessage {
    for (UIView *view in _tabContentView.subviews) {
        if ([view isKindOfClass: [HJTabItemBaseView class]]) {
            [(HJTabItemBaseView*)view stopAcceptMessage];
        }
    }
}

- (void)notifyViewWillDisappear {
    if (_tabContentView.currentPage < _tabContentView.subviews.count) {
        HJTabItemBaseView *tabItem = _tabContentView.subviews[_tabContentView.currentPage];
        [tabItem viewWillDisappear];
    }
}

- (void)notifyViewWillAppear {
    if (_tabContentView.currentPage < _tabContentView.subviews.count) {
        HJTabItemBaseView *tabItem = _tabContentView.subviews[_tabContentView.currentPage];
        [tabItem viewWillAppear];
    }
}

- (void)notifyCurrentTabPullDownRefresh {
    [[HJPriMsgBorderAndMedalManager defaultManager] cleanCache];
    if (_tabContentView.currentPage < _tabContentView.subviews.count) {
        HJTabItemBaseView *tabItem = _tabContentView.subviews[_tabContentView.currentPage];
        [tabItem doPullDownRefresh];
    }
}

- (void)setTitleOnTop:(BOOL)onTop {
    _tabTitleView.onTop = onTop;
}

- (void)setSelectedTab:(NSInteger)index {
    if (index != _tabContentView.currentPage) {
        [_tabContentView setContentOffset: CGPointMake(index * KScreenWidth, 0) animated: YES];
    }
}

-(NSArray *)tabTitleArray {
    return _tabTitleView.titleArray;
}

- (void)setTabTitleArray:(NSArray *)tabTitleArray {
    [_tabTitleView setTitleArray:tabTitleArray];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger pageNum = offsetX / KScreenWidth;
    if (pageNum != _tabContentView.currentPage) {
        [_tabTitleView setItemSelected: pageNum];
        
        [self notifyViewWillDisappear];
        _tabContentView.currentPage = pageNum;
        [self notifyViewWillAppear];
        
        [self logTab];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kScrollViewDidEndDecelerating object: nil];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating: scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName: kScrollViewWillBeginDragging object: nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [[NSNotificationCenter defaultCenter] postNotificationName: kScrollViewDidEndDecelerating object: nil];
    }
}

- (void)logTab {
    switch (_tabContentView.currentPage) {
        case 0:
            [[StatisticsManager shareInstance] customTimeEvent: me_tab_show customAttributes: @{@"rank_name" : @"my_feed"}];
            break;
            
        case 1:
            [[StatisticsManager shareInstance] customTimeEvent: me_tab_show customAttributes: @{@"rank_name" : @"my_message"}];
            break;
            
        case 2:
            [[StatisticsManager shareInstance] customTimeEvent: me_tab_show customAttributes: @{@"rank_name" : @"my_center"}];
            break;
            
        default:
            break;
    }
}
@end
