//
//  WXTabbedTableViewController.h
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/18.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WXTabbedTableView;
@class WXTabTitleView;

@interface WXTabbedTableViewController : UIViewController

@property (strong, nonatomic, readonly) WXTabbedTableView *tableView;
@property (strong, nonatomic, readonly) WXTabTitleView *defaultTitleView;

@end
