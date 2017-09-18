//
//  HJTabItemBaseView.h
//  living
//
//  Created by wang shuguang on 2016/10/28.
//  Copyright © 2016年 MJHF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJTabItemBaseView : UIView<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign,readonly) NSUInteger index;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, weak) UIViewController *parentVC;

- (instancetype)initWithTabIndex: (NSInteger)index;

- (void)startAcceptMessage;

- (void)stopAcceptMessage;

/**
 该TAB消失时被调用，子类可以重写该方法。
 */
- (void)viewWillDisappear;

/**
 该TAB出现时被调用，子类可以重写该方法。
 */
- (void)viewWillAppear;

/**
 通知该TAB做下拉刷新操作，子类可以重写该方法。
 */
- (void)doPullDownRefresh;

- (CGRect)ignoreScrollArea;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
