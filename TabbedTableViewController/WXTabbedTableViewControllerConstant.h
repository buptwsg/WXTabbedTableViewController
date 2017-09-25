//
//  WXTabbedTableViewControllerConstant.h
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/20.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief a list of view appear reasons
 */
typedef NS_ENUM(NSInteger, WXTabItemViewAppearReason) {
    ///the view controller's viewWillAppear: method is called
    WXTabItemViewAppearByViewController,
    ///user horizontally scroll or touch the title view to change tab
    WXTabItemViewAppearByChangingTab
};

/**
 @brief a list of view disappear reasons
 */
typedef NS_ENUM(NSInteger, WXTabItemViewDisappearReason) {
    ///the view controller's viewWillDisappear: method is called
    WXTabItemViewDisappearByViewController,
    ///user horizontally scroll or touch the title view to change tab
    WXTabItemViewDisappearByChangingTab
};

extern NSString * const WXTabTitleViewArriveTopNotification;
extern NSString * const WXTabTitleViewLeaveTopNotification;
