//
//  WXTabbedTableViewControllerConstant.h
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/20.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WXTabItemViewAppearReason) {
    WXTabItemViewAppearByViewController,
    WXTabItemViewAppearByChangingTab
};

typedef NS_ENUM(NSInteger, WXTabItemViewDisappearReason) {
    WXTabItemViewDisappearByViewController,
    WXTabItemViewDisappearByChangingTab
};

extern NSString * const WXTabTitleViewArriveTopNotification;
extern NSString * const WXTabTitleViewLeaveTopNotification;
