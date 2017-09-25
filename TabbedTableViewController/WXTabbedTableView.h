//
//  WXTabbedTableView.h
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The view controller creates an instance of this class as the outer table view. This table view can recognize simultaneously more than one gesture, it's key to
 be able to pan two scroll views at the same time.
 Besides, if there are any views which are user interaction enabled and below the table header view, you can make these views to receive touch by calling - (void)addViewToReceiveTouch:. This is useful if you want to zoom in or zoom out the view below table header view when user scrolls the outer table view.
 */
@interface WXTabbedTableView : UITableView

/**
 Make a view to be able to receive touch event
 */
- (void)addViewToReceiveTouch: (UIView*)view;

/**
 Remove a view to receive touch event
 */
- (void)removeViewToReceiveTouch: (UIView*)view;

@end
