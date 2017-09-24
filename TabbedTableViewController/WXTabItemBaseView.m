//
//  WXTabItemBaseView.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "WXTabItemBaseView.h"
#import "WXTabbedTableViewControllerConstant.h"

@interface WXTabItemBaseView()

@property (nonatomic) BOOL canScroll;

@end

@implementation WXTabItemBaseView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (instancetype)initWithIndex:(NSUInteger)index size:(CGSize)viewSize {
    self = [super initWithFrame: CGRectMake(index * viewSize.width, 0, viewSize.width, viewSize.height)];
    if (self) {
        UITableView *tableView = [[UITableView alloc] initWithFrame: self.bounds];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.showsHorizontalScrollIndicator = NO;
        [self addSubview: tableView];
        
        self.scrollView = tableView;
        [self startAcceptMessages];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollView != scrollView) {
        return;
    }
    
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        contentInset = scrollView.safeAreaInsets;
    }
    else {
        contentInset = scrollView.contentInset;
    }
    
    if (!self.canScroll) {
        [scrollView setContentOffset: CGPointMake(0, -contentInset.top)];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < -contentInset.top) {
        [[NSNotificationCenter defaultCenter] postNotificationName: WXTabTitleViewLeaveTopNotification object: nil ];
    }
}

#pragma mark - Private methods
- (void)startAcceptMessages {
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(acceptMessage:) name: WXTabTitleViewArriveTopNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(acceptMessage:) name: WXTabTitleViewLeaveTopNotification object: nil];
}

- (void)stopAcceptMessages {
    [[NSNotificationCenter defaultCenter] removeObserver: self name: WXTabTitleViewArriveTopNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: WXTabTitleViewLeaveTopNotification object: nil];
}

- (void)acceptMessage: (NSNotification*)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString: WXTabTitleViewArriveTopNotification]) {
        self.canScroll = YES;
        self.scrollView.showsVerticalScrollIndicator = YES;
    }
    else if ([notificationName isEqualToString: WXTabTitleViewLeaveTopNotification]){
        //when one of the tabs leaves top, others should also be reset to leave top.
        self.scrollView.contentOffset = CGPointMake(0, -self.scrollView.contentInset.top);
        self.canScroll = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
    }
}

@end
