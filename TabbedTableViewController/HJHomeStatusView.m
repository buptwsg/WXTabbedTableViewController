//
//  HJMyStatusView.m
//  living
//
//  Created by sulirong on 2017/8/8.
//  Copyright © 2017年 MJHF. All rights reserved.
//

#import "HJHomeStatusView.h"
#import "HJTabBarNotificationDefines.h"
#import "HJWatchWordManager.h"
#import "HJNewDiscoveryVC.h"
#import "HJSuperNearbyVC.h"
#import "HJShortVideoVC.h"
#import "UINavigationBar+Ext.h"
#import "HJHomeCell.h"
#import "HJAlertController.h"
#import "DSNavigationController.h"
#import "HJMyHomeModel.h"
#import <MJRefresh.h>
#import "NewsFeeds.h"
#import "HJHomeStatusView+State.h"

@interface HJHomeStatusView()
@property (nonatomic, strong) NewsFeeds*      feedObject;
@property (nonatomic, assign, getter=isRequesting) BOOL requesting;
@end


@implementation HJHomeStatusView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (instancetype)initWithTabIndex: (NSInteger)index {
    self = [super initWithTabIndex:index];
    if (self) {
        [self setupData];
        [self setupView];
        [self observeNotifications];
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.flowLayoutVC.tableView.frame = self.bounds;
}

-(void)viewWillAppear{
    [self.flowLayoutVC doViewWillAppear];
}

-(void)viewWillDisappear{
    [self.flowLayoutVC doViewWillDisAppear];
}

-(void)setUserId:(NSString *)userId {
    _userId = userId;
    [self loadUserFeedsWithLoading:NO];
}

- (void)setupData {
    self.feedObject = [[NewsFeeds alloc] init];
    self.feedObject.feeds = [NSMutableArray arrayWithCapacity:20];
    self.feedObject.offset = @"";
    self.feedObject.total = 0;
}

-(void)setupView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = WW_Color_BackgroundColor_Gray;
}

- (void)observeNotifications {
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(onFeedUpdated:) name:@"kHJShortVideoFinishedNotification" object:nil];
    [nc addObserver:self selector:@selector(onFeedUpdated:) name:@"kHJImageFinishedNotification" object:nil];
}

#pragma mark Notification Begin
- (void)onFeedUpdated:(NSNotification*)notification {
    IMP_WSELF()
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself.flowLayoutVC.dataSourceDelegate stopPlayTime];
        [wself.flowLayoutVC.dataSourceDelegate.playerView stop];
        [wself.flowLayoutVC.dataSourceDelegate.playerView removeFromSuperview];
        wself.flowLayoutVC.dataSourceDelegate.playerView = nil;
        [wself loadUserFeedsWithLoading:NO];
    });
}

#pragma mark Notification End

-(void)lazySetupFlowVCIfNecessary {
    if (_flowLayoutVC == nil) {
        IMP_WSELF()
        void (^refreshBlock)(BOOL) = ^(BOOL hasMore) {
            if (wself == nil) return;
            IMP_SSELF()
            if (hasMore == NO) { //下拉刷新
                [sself doRefresh];
            } else {
                [sself loadUserMoreFeeds];
            }
        };
        UIView* header = nil;
        if (self.headerHeight >= 0.1f) {
            header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.headerHeight)];
            header.backgroundColor = [UIColor clearColor];
        }

        _flowLayoutVC = [[HJTrendsLayoutVC alloc] initWithFrame:self.bounds Feeds:self.feedObject.feeds withHeaderView:header withBottomHeight:0 isShowDistanch:NO withRefreshBlock:refreshBlock];
        self.flowLayoutVC.view.backgroundColor=WW_Color_BackgroundColor_Gray;
        self.flowLayoutVC.from = @"my_feeds";
        self.flowLayoutVC.tableView.mj_header=nil;
        [self.flowLayoutVC doViewWillAppear];
        
        [self.tableView removeFromSuperview];
        [self addSubview:self.flowLayoutVC.tableView];
        [self.parentVC addChildViewController:self.flowLayoutVC];
        [_flowLayoutVC didMoveToParentViewController:self.parentVC];
        self.tableView = self.flowLayoutVC.tableView;
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.flowLayoutVC.didDeleteCell = ^(NSInteger deleteIndex) {
            if (wself.feedObject.feeds.count == 0) { //show empty view
                [wself showEmpty];
            }
        };
        self.flowLayoutVC.doScrollViewDidScroll = ^(UIScrollView *scrollView) {
            [wself scrollViewDidScroll:scrollView];
        };
    }
}

//Important!! tabView invoke.
-(void)doPullDownRefresh{
    [self doRefresh];
}

- (void)doRefresh {
    [self.flowLayoutVC.dataSourceDelegate stopPlayTime];
    [self.flowLayoutVC.dataSourceDelegate.playerView stop];
    [self.flowLayoutVC.dataSourceDelegate.playerView removeFromSuperview];
    self.flowLayoutVC.dataSourceDelegate.playerView = nil;
    [self loadUserFeedsWithLoading:NO];
}

- (void)endRefresh {
    [self.flowLayoutVC endRefresh];
}

- (BOOL)avaliableCheck {
    if ([self.userId isNotEmpty] == NO) {
        return NO;
    }
    
    if ([self isRequesting]) {
        return NO;
    }
    return YES;
}

//下拉刷新
- (void)loadUserFeedsWithLoading:(BOOL)loading {
    if ([self avaliableCheck] == NO) {
        return;
    }
    
    self.requesting = YES;
    
    [self lazySetupFlowVCIfNecessary];
    
    if (loading) {
        [self showLoading];
    }
    HJMyHomeModel* hm = [HJMyHomeModel sharedIntfs];
    IMP_WSELF()
    BOOL isMyself = [UserPrefs isMyself:self.userId];
    
    [hm feed_getUserFeeds:self.userId
                   Offset:nil
                  success:^(id result) {
                      if (wself == nil) {
                          return;
                      }
                      IMP_SSELF()
                      //绕圈是为了解决HJFlowLayoutVC引用同一feeds的问题.
                      NewsFeeds* feedObject = [NewsFeeds responseWithInfo:result];
                      sself.flowLayoutVC.hasMore = feedObject.more;
                      
                      NSMutableArray* feeds = sself.feedObject.feeds;
                      sself.feedObject = feedObject;
                      if (feeds) {
                          [feeds setArray:feedObject.feeds];
                          sself.feedObject.feeds = feeds;
                      }
                      
                      for (Feeds *fs in feeds) {
                          fs.originFeeds.feedsName = isMyself ? @"home_me" : @"others_personal_page";
                          fs.feedsName = isMyself ? @"home_me" : @"others_personal_page";
                      }
                      if (sself.feedObject.feeds.count > 0) {
                          [sself showView];
                      } else {
                          [sself showEmpty];
                      }
                      
                      [sself endRefresh];
                      sself.requesting = NO;
                  } failure:^(NSError *error) {
                      IMP_SSELF()
                      [HJToastMgr showToast:@"网络连接异常，请检查网络设置"];
                      [sself endRefresh];
                      if (self.feedObject.feeds.count > 0) {
                          [self showView];
                      } else {
                          [sself showError];
                      }
                      sself.requesting = NO;
                  }];
}


//上拉刷新
- (void)loadUserMoreFeeds {
    if ([self avaliableCheck] == NO) {
        return;
    }
    
    self.requesting = YES;
    
    HJMyHomeModel* hm = [HJMyHomeModel sharedIntfs];
    IMP_WSELF()
    [hm feed_getUserFeeds:self.userId Offset:self.feedObject.offset success:^(id result) {
        if (wself == nil) {
            return;
        }
        
        IMP_SSELF()
        NewsFeeds* feedObject = [NewsFeeds responseWithInfo:result];
        sself.flowLayoutVC.hasMore = feedObject.more;
        
        for (Feeds *fs in feedObject.feeds) {
            fs.feedsName = @"home_me";
        }
        
        NSMutableArray* feeds = sself.feedObject.feeds;
        sself.feedObject = feedObject;
        if (feeds) {
            [feeds addObjectsFromArray:feedObject.feeds];
            sself.feedObject.feeds = feeds;
        }
        sself.requesting = NO;
        [sself endRefresh];
        if (sself.feedObject.feeds.count > 0) {
            [sself showView];
        } else {
            [sself showEmpty];
        }
        
    } failure:^(NSError *error) {
        [HJToastMgr showToast:@"网络错误"];
        wself.requesting = NO;
    }];
}

- (UIView*)stateView {
    if (!_stateView) {
        _stateView = [[UIView alloc] initWithFrame:self.bounds];
        _stateView.backgroundColor = WW_Color_BackgroundColor_Gray;
    }
    return _stateView;
}

@end
