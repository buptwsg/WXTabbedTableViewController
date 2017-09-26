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

/**
 The outer table view. It has only one row, and the cell has a paging enabled horizontally scrolling UIScrollView. The scroll view can
 have one or more pages, each page contains a UITableView or UICollectionView.
 */
@property (strong, nonatomic, readonly) WXTabbedTableView *tableView;

/**
 The default title view provided by this framework
 */
@property (strong, nonatomic, readonly) WXTabTitleView *defaultTitleView;

/**
 the maximum y offset of the outer table view
 */
@property (nonatomic, readonly) CGFloat tableViewMaxOffsetY;

/**
 If set to YES, users can horizontally scroll the pages. Default is YES.
 */
@property (nonatomic) BOOL horizontalScrollEnabled;

/**
 @brief subclass should override this method to set title strings for tabs
 */
- (NSArray<NSString *> *)tabTitles;

/**
 @brief subclass can override this method to return a user defined tab title view. If not override, a default title view is returned.
 */
- (UIView<WXTabTitleViewProtocol> *)tabTitleView;

/**
 @brief subclass can override this method to config the appearance of default title view.
        Check WXTabTitleView.h for properties that can be configured.
*/
- (void)configDefaultTitleView;

/**
 @brief subclass should override this method to return the view for the tab at index
 @param index the tab index
 @param viewSize the size of the view
 @return instance of subclass of WXTabItemBaseView
 */
- (WXTabItemBaseView*)itemViewAtIndex: (NSUInteger)index size: (CGSize)viewSize;

@end
