//
//  WXTabbedTableView.h
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXTabbedTableView : UITableView

- (void)addViewToIgnoreTouch: (UIView*)view;

- (void)removeViewToIgnoreTouch: (UIView*)view;

@end
