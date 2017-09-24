//
//  WXTabbedTableViewController.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/18.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "WXTabbedTableViewController.h"
#import "WXTabItemBaseView.h"
#import "WXTabbedTableViewControllerConstant.h"

static NSString * const WXTabCellIdentifier = @"TabCell";

@interface WXTabbedTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic, readonly) WXTabView *tabView;
@property (nonatomic) BOOL canScroll;

@end

@implementation WXTabbedTableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.canScroll = YES;
    
    _tableView = [[WXTabbedTableView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: self.tableView];
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: WXTabCellIdentifier];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(acceptMessage:) name: WXTabTitleViewLeaveTopNotification object: nil];
    [self.tabView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: WXTabTitleViewLeaveTopNotification object: nil];
    [self.tabView viewWillDisappear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - public methods
- (CGFloat)tableViewMaxOffsetY {
    return [self.tableView rectForSection: 0].origin.y - [self tableViewContentInset].top;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: WXTabCellIdentifier forIndexPath:indexPath];
    if (nil == self.tabView) {
        CGFloat height = [self tableView: tableView heightForRowAtIndexPath: indexPath];
        UIView<WXTabTitleViewProtocol> *tabTitleView = [self tabTitleView];
        _tabView = [[WXTabView alloc] initWithFrame: CGRectMake(0, 0, self.tableView.frame.size.width, height) titleView: tabTitleView];
        self.tabView.outerScrollView = self.tableView;
        
        NSUInteger titleCount = [self tabTitles].count;
        for (NSUInteger i = 0; i < titleCount; i++) {
            WXTabItemBaseView *itemView = [self itemViewAtIndex: i size: CGSizeMake(self.tableView.frame.size.width, height - tabTitleView.frame.size.height)];
            [self.tabView addItemView: itemView];
        }
    }
    [cell.contentView addSubview: self.tabView];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIEdgeInsets)tableViewContentInset {
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        contentInset = self.tableView.adjustedContentInset;
    }
    else {
        contentInset = self.tableView.contentInset;
    }
    return contentInset;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIEdgeInsets contentInset = [self tableViewContentInset];
    return screenSize.height - contentInset.top - contentInset.bottom;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.tableView) {
        return;
    }
    
    //if this method is called before the only cell is created, ignore.
    if (!self.tabView) {
        return;
    }
    
    CGFloat maxOffsetY = self.tableViewMaxOffsetY;
    CGFloat currentOffsetY = self.tableView.contentOffset.y;
    if (!self.canScroll) {
        self.tableView.contentOffset = CGPointMake(0, maxOffsetY);
        return;
    }
    
    if (currentOffsetY >= maxOffsetY) {
        if (self.canScroll) {
            [[NSNotificationCenter defaultCenter] postNotificationName: WXTabTitleViewArriveTopNotification object: nil];
        }
        self.canScroll = NO;
        self.tableView.contentOffset = CGPointMake(0, maxOffsetY);
    }
}

#pragma mark - Methods that subclass can override
- (NSArray<NSString *> *)tabTitles {
    return @[@"First", @"Second"];
}

- (UIView<WXTabTitleViewProtocol> *)tabTitleView {
    if (nil == _defaultTitleView) {
        _defaultTitleView = [[WXTabTitleView alloc] initWithTitles: [self tabTitles]];
        [self configDefaultTitleView];
    }
    return _defaultTitleView;
}

- (void)configDefaultTitleView {
}

- (WXTabItemBaseView*)itemViewAtIndex: (NSUInteger)index size: (CGSize)viewSize {
    return [[WXTabItemBaseView alloc] initWithIndex: index size: viewSize];
}

#pragma mark - Private Methods
- (void)acceptMessage: (NSNotification*)notification {
    if ([notification.name isEqualToString: WXTabTitleViewLeaveTopNotification]) {
        self.canScroll = YES;
    }
}

@end
