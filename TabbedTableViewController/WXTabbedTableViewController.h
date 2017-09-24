//
//  WXTabbedTableViewController.h
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/18.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WXTabbedTableView.h"
#import "WXTabTitleView.h"
#import "WXTabView.h"

@interface WXTabbedTableViewController : UIViewController

@property (strong, nonatomic, readonly) WXTabbedTableView *tableView;
@property (strong, nonatomic, readonly) WXTabTitleView *defaultTitleView;
@property (strong, nonatomic, readonly) WXTabView *tabView;
@property (nonatomic, readonly) CGFloat tableViewMaxOffsetY;

- (NSArray<NSString *> *)tabTitles;

- (UIView<WXTabTitleViewProtocol> *)tabTitleView;

- (void)configDefaultTitleView;

- (WXTabItemBaseView*)itemViewAtIndex: (NSUInteger)index size: (CGSize)viewSize;

@end
