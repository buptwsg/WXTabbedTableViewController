//
//  HJOtherHomeConst.h
//  living
//
//  Created by wang shuguang on 2016/10/28.
//  Copyright © 2016年 MJHF. All rights reserved.
//

#ifndef HJOtherHomeConst_h
#define HJOtherHomeConst_h

static NSString *const kGoTopNotificationName = @"goTop";//进入置顶命令
static NSString *const kLeaveTopNotificationName = @"leaveTop";//离开置顶命令
static NSString *const kScrollViewWillBeginDragging = @"ScrollViewWillBeginDragging";
static NSString *const kScrollViewDidEndDecelerating = @"ScrollViewDidEndDecelerating";

static CGFloat const kTabTitleViewHeight = 44;

typedef NS_OPTIONS(NSInteger, OtherHomeRefreshMask) {
    RefreshMaskUserProfile = 1 << 0,
    RefreshMaskRewardTotal = 1 << 1,
    RefreshMaskUserFeeds = 1 << 2,
    RefreshMaskAttentionFeeds = 1 << 3,
    RefreshMaskFollowings = 1 << 4
};

typedef void (^RefreshFinishBlock)(OtherHomeRefreshMask);

#endif /* HJOtherHomeConst_h */
