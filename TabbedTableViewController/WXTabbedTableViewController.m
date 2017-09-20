//
//  WXTabbedTableViewController.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/18.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "WXTabbedTableViewController.h"
#import "WXTabTitleView.h"
#import "WXTabView.h"
#import "WXTabItemBaseView.h"
#import "WXTabbedTableView.h"

static NSString * const WXTabCellIdentifier = @"TabCell";

@interface WXTabbedTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) WXTabView *tabView;

@end

@implementation WXTabbedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    _tableView = [[WXTabbedTableView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: self.tableView];
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: WXTabCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: WXTabCellIdentifier forIndexPath:indexPath];
    CGFloat height = [self tableView: tableView heightForRowAtIndexPath: indexPath];
    self.tabView = [[WXTabView alloc] initWithFrame: CGRectMake(0, 0, self.tableView.frame.size.width, height) titleView: [self tabTitleView]];
    self.tabView.outerScrollView = self.tableView;
    
    for (NSUInteger i = 0; i < [self tabTitles].count; i++) {
        WXTabItemBaseView *itemView = [self itemViewAtIndex: i size: CGSizeMake(self.tableView.frame.size.width, height - [self tabTitleView].frame.size.height)];
        [self.tabView addItemView: itemView];
    }
    [cell.contentView addSubview: self.tabView];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIEdgeInsets contentInset = tableView.contentInset;
    return screenSize.height - contentInset.top - contentInset.bottom;
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

@end
