//
//  WXTabView.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "WXTabView.h"
#import "WXTabItemBaseView.h"

static void *WXTabTitleObservationContext = &WXTabTitleObservationContext;

@interface WXTabView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIView<WXTabTitleViewProtocol> *titleView;
@property (strong, nonatomic) UIScrollView *horizontalScrollView;
@property (strong, nonatomic) NSMutableArray<WXTabItemBaseView*> *tabItemViews;

@end

@implementation WXTabView

- (void)dealloc {
    [self.tabItemViews enumerateObjectsUsingBlock:^(WXTabItemBaseView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeObserver: self forKeyPath: @"title"];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame titleView:(UIView<WXTabTitleViewProtocol> *)titleView {
    self = [super initWithFrame: frame];
    if (self) {
        _titleView = titleView;
        [self addSubview: _titleView];
        __weak typeof(self) weakSelf = self;
        _titleView.titleClickBlock = ^(NSUInteger newIndex, NSUInteger oldIndex) {
            if (newIndex != oldIndex) {
                weakSelf.horizontalScrollView.contentOffset = CGPointMake(frame.size.width * newIndex, 0);
                [weakSelf.tabItemViews[oldIndex] viewWillDisappear: WXTabItemViewDisappearByChangingTab];
                [weakSelf.tabItemViews[newIndex] viewWillAppear: WXTabItemViewAppearByChangingTab];
            }
        };
        
        //If there is less than two tab titles, don't show title view
        if (_titleView.tabTitles.count < 2) {
            _titleView.frame = CGRectZero;
            _titleView.hidden = YES;
        }
        CGFloat titleHeight = _titleView.frame.size.height;
        _horizontalScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, titleHeight, frame.size.width, frame.size.height - titleHeight)];
        _horizontalScrollView.delegate = self;
        _horizontalScrollView.pagingEnabled = YES;
        _horizontalScrollView.showsVerticalScrollIndicator = NO;
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
        _horizontalScrollView.contentSize = CGSizeMake(_titleView.tabTitles.count * _horizontalScrollView.frame.size.width, _horizontalScrollView.frame.size.height);
        [self addSubview: _horizontalScrollView];
        
        _tabItemViews = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - public methods
- (void)setHorizontalScrollEnabled:(BOOL)horizontalScrollEnabled {
    _horizontalScrollEnabled = horizontalScrollEnabled;
    _horizontalScrollView.scrollEnabled = horizontalScrollEnabled;
}

- (void)addItemView:(WXTabItemBaseView *)itemView {
    [_horizontalScrollView addSubview: itemView];
    itemView.title = self.titleView.tabTitles[itemView.index];
    [_tabItemViews addObject: itemView];
    
    [itemView addObserver: self forKeyPath: @"title" options: kNilOptions context: WXTabTitleObservationContext];
}

- (void)viewWillAppear {
    for (WXTabItemBaseView *view in self.tabItemViews) {
        [view viewWillAppear: WXTabItemViewAppearByViewController];
    }
}

- (void)viewWillDisappear {
    for (WXTabItemBaseView *view in self.tabItemViews) {
        [view viewWillDisappear: WXTabItemViewDisappearByViewController];
    }
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
    NSUInteger oldTab = self.titleView.selectedItem;
    NSUInteger tab = self.horizontalScrollView.contentOffset.x / self.horizontalScrollView.frame.size.width;
    
    if (oldTab != tab) {
        [self.titleView setSelectedItem: tab];
        [self.tabItemViews[oldTab] viewWillDisappear: WXTabItemViewDisappearByChangingTab];
        [self.tabItemViews[tab] viewWillAppear: WXTabItemViewAppearByChangingTab];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == WXTabTitleObservationContext) {
        WXTabItemBaseView *itemView = (WXTabItemBaseView*)object;
        [self.titleView setTitle: itemView.title forIndex: itemView.index];
    }
    else {
        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
}
@end
