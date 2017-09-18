//  HJMyHomeViewController.m
//  living
//
//  Created by li on 10/27/15.
//  Copyright © 2015 MJHF. All rights reserved.
//

#import "HJMyHomeViewController.h"
#import "UserPrefs.h"
#import "HJTagsIntf.h"
#import "UIImageView+WebCache.h"
#import "NSString+Ext.h"
#import "HJUserFollowedViewController.h"
#import "HJUserFollowingViewController.h"
#import "HJUserProfileDefine.h"
#import "DSSettingViewController.h"
#import "HJLevelWebViewController.h"
#import "StatisticsManager.h"
#import "Feeds.h"

//debug
#import "HJHomeIntf.h"
#import "HJWalletManager.h"
#import "HJUserWallet.h"
#import "HJWalletCloudTextManager.h"

#import "HJMyHomeBigAvaterViewController.h"

#import "HJH5GuardRankViewController.h"
#import "HJGuardRankService.h"
#import "HJWatchHistoryViewController.h"

#import "JSONHelp.h"
#import "HomeMenuModel.h"
#import "HJActivityIntf.h"

#import "HJHelpViewController.h" //帮助页面

#import "HJMYMVViewController.h"
#import "HJMusicVideoManager.h"
#import "HJOpenAuthorLevelViewController.h"
#import "UINavigationBar+Ext.h"
#import "HJPrivacyPolicyAlertView.h"
#import "HJMyCoinsH5ViewController.h"

#import "../living/Vendors/QHIVideoSDK/QHIVideoSDK/3rdParty/CustomDevice.h"

#import "HJChargeChecker.h"
#import "HJAccountViewController.h"
#import "HJAboutAnchorViewController.h"
#import "UIImage+Common.h"
#import "HJDailySignInViewController.h"
#import "HJMyFeedsViewController.h"
#import "HJSignInManager.h"
#import "HJSigninIntf.h"

#import "HJIgnoreHeaderTouchTableView.h"
#import "HJTabView.h"
#import "HJHomeStatusView.h"
#import "HJMyPrivateChatView.h"
#import "HJMyProfileView.h"
#import "HJMyHomeNewHeaderView.h"
#import "HJOtherHomeConst.h"
#import "HJReleaseSheetManager.h"
#import "HJLoadHeader.h"
#import "HJShareData.h"
#import "HJShareView.h"
#import "HJPersonalNavigationTitleView.h"
#import "YSDraftsViewController.h"

#define HJKeyDailySignInDotNeedShow @"HJKeyDailySignInDotNeedShow"

@interface HJMyHomeViewController ()<HJMyHomeNewHeaderViewDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) HJMyHomeNewHeaderView *headerTopView;
@property (nonatomic, strong) HJIgnoreHeaderTouchTableView *tableView;
@property (nonatomic, strong) UIView *viewUnderStatusBar;

@property (nonatomic, strong) HJTabView *tabView;
@property (nonatomic, strong) HJHomeStatusView *statusView;
@property (nonatomic, strong) HJMyPrivateChatView *privateChatView;
@property (nonatomic, strong) HJMyProfileView *profileView;
@property (nonatomic, strong) HJPersonalNavigationTitleView *titleView;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, strong) HJUserProfileInfo *userProfile;
@property (nonatomic, strong) NSArray *cellModelArray;

@property (nonatomic, assign) HomeMenuModel *dialySignIn;       //我的签到
@property (nonatomic, assign) HomeMenuModel *fansModel;         //粉丝贡献
@property (nonatomic, assign) HomeMenuModel *watchHistory;      //我看过的
@property (nonatomic, assign) HomeMenuModel *mvModel;           //我的MV
@property (nonatomic, assign) HomeMenuModel *levelModel;        //等级
@property (nonatomic, assign) HomeMenuModel *equipmentModel;        //我的装备
@property (nonatomic, assign) HomeMenuModel *authorLevelModel;  //主播等级
@property (nonatomic, assign) HomeMenuModel *accountModel;      //花椒账户
@property (nonatomic, assign) HomeMenuModel *aboutAuthorModel;  //主播相关
@property (nonatomic, strong) HJHomeSignInInfo *signInInfo;

@property (nonatomic) BOOL refreshing;
@property (nonatomic) BOOL isFirstAppear;

@end

@implementation HJMyHomeViewController
{
    BOOL _guardListEnable;
    BOOL _isBigImage;
    BOOL _isShowingFindApp;
    BOOL _firstAppear;
    NSString *_findAppH5URL;
    NSString *_findAppCellTitle;
}

- (void)setupData {
    _guardListEnable = _BOOL([[HJWalletCloudTextManager sharedManager] getStringForKey:double_type_money_switch defaultValue:0]);
    //他人页和个人页，@"fans"使用相同云控
    NSString *myTextStr = _STR([[HJWalletCloudTextManager sharedManager] getStringForKey:econ_personal_view_text defaultValue:MYHOME_TABLE_TITLE_TEXT_DEFAULT]);
    NSDictionary *result = [JSONHelp string2NSObject: myTextStr];
    
    NSMutableArray* cellMenuArray = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *menuArray = [NSMutableArray array];
    
    //粉丝贡献
    HomeMenuModel *fansModel = [[HomeMenuModel alloc] init];
    //fansModel.iconName = @"mine_fensi";
    fansModel.menuTitle = _STR(result[@"fans"]).length > 0 ? _STR(result[@"fans"]) : @"守护榜";
    fansModel.menuRedirectType = HomeMeumFans;
    fansModel.menuCellType = HJMyHomeCellTypeRightThreeImage;
    self.fansModel = fansModel;
    [menuArray addObject:fansModel];
    [cellMenuArray addObject:menuArray];
    
    menuArray = [NSMutableArray arrayWithCapacity:3];
    
    NSString *checkinEnable = [[HJWalletCloudTextManager sharedManager] getStringForKey: checkin_mycheck defaultValue: @""];
    _firstAppear = YES;
    
    if (checkinEnable && [checkinEnable isEqualToString: @"1"]) {         //我的签到
        HomeMenuModel *dialySignIn = [[HomeMenuModel alloc] init];
//        dialySignIn.iconName = @"mine_qiandao";
        dialySignIn.menuTitle = @"我的签到";
        dialySignIn.menuRedirectType = HomeMeumSign;
        dialySignIn.menuCellType = HJMyHomeCellTypeRightNumberArrow;
        self.dialySignIn = dialySignIn;
        [menuArray addObject:dialySignIn];
        [[NSUserDefaults standardUserDefaults] setBool: NO forKey: HJKeyDailySignInDotNeedShow];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInStatusChanged:) name:KeyHJSignInStatusChanged object:nil];
    }
    
    //我看过的
    HomeMenuModel *watchHistory = [[HomeMenuModel alloc] init];
//    watchHistory.iconName = @"mine_kanguo";
    watchHistory.menuTitle = @"我看过的";
    watchHistory.menuRedirectType = HomeMeumwatchHistory;
    watchHistory.menuCellType = HJMyHomeCellTypeRightNumberArrow;
    self.watchHistory = watchHistory;
    [menuArray addObject:watchHistory];
    
    if (![CustomDevice isLessThaniPhone5siPad3iPod5])
    {
        //我的k歌视频
        HomeMenuModel *mMvModel = [[HomeMenuModel alloc] init];
//        mMvModel.iconName = @"mine_mv";
        mMvModel.menuTitle = @"我的k歌视频";// _STR(result[@"mymv"]).length > 0 ? _STR(result[@"mymv"]) : @"我的MV";
        mMvModel.menuRedirectType = HomeMeumMyMV;
        mMvModel.menuCellType = HJMyHomeCellTypeRightNumberArrow;
        mMvModel.menuRightContent = [NSString stringWithFormat:@"%ld",[[HJMusicVideoManager sharedManager] numberOfMV]];
        mMvModel.menuRightContentColor = @"909090";
        [menuArray addObject:mMvModel];
        self.mvModel = mMvModel;
    }
    
    //MV草稿箱
    HomeMenuModel *draftHistory = [[HomeMenuModel alloc] init];
    draftHistory.menuTitle = @"MV草稿箱";
    draftHistory.menuRedirectType = HomeMeumDraft;
    draftHistory.menuCellType = HJMyHomeCellTypeRightNumberArrow;
    [menuArray addObject:draftHistory];
    
    //我的装备
    BOOL equipmentSwitch = _BOOL([[HJWalletCloudTextManager sharedManager] getStringForKey:my_equipment_switch defaultValue:0]);
    if (equipmentSwitch) {
        NSString* menuTitle = _STR([[HJWalletCloudTextManager sharedManager] getStringForKey:my_equipment_title defaultValue:@"我的装备"]);
        HomeMenuModel *mEquipmentModel = [[HomeMenuModel alloc] init];
        //mLevelModel.iconName = @"mine_yonghudengji";
        mEquipmentModel.menuTitle = menuTitle;
        mEquipmentModel.menuCellType = HJMyHomeCellTypeRightNumberArrow;
        mEquipmentModel.menuRedirectType = HomeMeumMyEquipment;
        mEquipmentModel.menuRightContentColor = @"4A4A4A";
        self.equipmentModel = mEquipmentModel;
        [menuArray addObject:mEquipmentModel];
    }
    
    [cellMenuArray addObject:menuArray];
    
    menuArray = [NSMutableArray arrayWithCapacity:2];
    //用户等级
    HomeMenuModel *mLevelModel = [[HomeMenuModel alloc] init];
//    mLevelModel.iconName = @"mine_yonghudengji";
    mLevelModel.menuTitle = @"用户等级";
    mLevelModel.menuCellType = HJMyHomeCellTypeRightViewNumber;
    mLevelModel.menuRedirectType = HomeMeumMyLevel;
    mLevelModel.menuRightContentColor = @"4A4A4A";
    self.levelModel = mLevelModel;
    [menuArray addObject:mLevelModel];
    
    //我的主播等级
    NSInteger anchorRoleLevelSwitch = [[[HJWalletCloudTextManager sharedManager] getStringForKey:anchorrole_level_show defaultValue:@"1"] integerValue];
    if(anchorRoleLevelSwitch == 1){
        HomeMenuModel *mAuthorLevelModel = [[HomeMenuModel alloc] init];
//        mAuthorLevelModel.iconName = @"mine_zhubodengji";
        mAuthorLevelModel.menuTitle = @"主播等级";
        mAuthorLevelModel.menuCellType = HJMyHomeCellTypeRightViewNumber;
        mAuthorLevelModel.menuRedirectType = HomeMeumMyAuthorLevel;
        mAuthorLevelModel.menuRightContentColor = @"909090";
        self.authorLevelModel = mAuthorLevelModel;
        [menuArray addObject:mAuthorLevelModel];
    }
    
    [cellMenuArray addObject:menuArray];
    
    menuArray = [NSMutableArray arrayWithCapacity:2];
    //花椒帐号
    HomeMenuModel *mAccountModel = [[HomeMenuModel alloc] init];
//    mAccountModel.iconName = @"mine_huajiaozhanghu";
    mAccountModel.menuTitle = @"花椒账户";
    mAccountModel.menuCellType = HJMyHomeCellTypeRightNumberArrow;
    mAccountModel.menuRedirectType = HomeMeumAccount;
    mAccountModel.menuRightContentColor = @"909090";
    self.accountModel = mAccountModel;
    [menuArray addObject:mAccountModel];
    
    //主播相关
    HomeMenuModel *mAboutAnchorModel = [[HomeMenuModel alloc] init];
//    mAboutAnchorModel.iconName = @"mine_zhuboxiangguan";
    mAboutAnchorModel.menuTitle = @"主播相关";
    mAboutAnchorModel.menuCellType = HJMyHomeCellTypeRightNumberArrow;
    mAboutAnchorModel.menuRedirectType = HomeMeumAboutAnchor;
    [menuArray addObject:mAboutAnchorModel];
    self.aboutAuthorModel = mAboutAnchorModel;
    [cellMenuArray addObject:menuArray];
    
    //========== setting section ======= //
    menuArray = [NSMutableArray arrayWithCapacity:3];
    //帮助与反馈
    HomeMenuModel *mHelpModel = [[HomeMenuModel alloc] init];
//    mHelpModel.iconName = @"mine_bangzhu";
    mHelpModel.menuTitle = _LS(@"setting_row_feedback");
    mHelpModel.menuRedirectType = HomeMeumHelp;
    mHelpModel.menuCellType = HJMyHomeCellTypeRightNumberArrow;
    [menuArray addObject:mHelpModel];
    
    //设置
    HomeMenuModel *mSettingModel = [[HomeMenuModel alloc] init];
//    mSettingModel.iconName = @"mine_shezhi";
    mSettingModel.menuTitle = @"设置";
    mSettingModel.menuRedirectType = HomeMeumSetting;
    mSettingModel.menuCellType = HJMyHomeCellTypeRightNumberArrow;
    [menuArray addObject:mSettingModel];
    
    NSString *findAppConfig = _STR([[HJWalletCloudTextManager sharedManager] getStringForKey:settings_find_app_confg defaultValue:@""]);
    if (findAppConfig.length > 0) {
        NSDictionary *findAppConfigDict = [JSONHelp string2NSObject:findAppConfig];
        if ([findAppConfigDict isKindOfClass:NSDictionary.class]) {
            _isShowingFindApp = _BOOL(findAppConfigDict[@"is_Show"]);
            _findAppH5URL = _STR(findAppConfigDict[@"H5_URL"]);
            _findAppCellTitle = _STR(findAppConfigDict[@"cell_title"]);
            
            if (_findAppCellTitle.length > 0 && _isShowingFindApp) {
                HomeMenuModel *mSettingModel = [[HomeMenuModel alloc] init];
                mSettingModel.menuTitle = _findAppCellTitle;
                mSettingModel.menuRedirectType = HomeMeumApp;
                mSettingModel.menuCellType = HJMyHomeCellTypeRightNumberArrow;
                [menuArray addObject:mSettingModel];
            }
        }
    }
    [cellMenuArray addObject:menuArray];
    
    menuArray = [NSMutableArray arrayWithCapacity:1];
    [cellMenuArray addObject:menuArray];
    self.cellModelArray = [cellMenuArray copy];
}

- (BOOL)dateChanged: (NSString *)key{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *todayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    NSInteger today = [todayComponents day];
    NSInteger oldDay = [[NSUserDefaults standardUserDefaults] integerForKey: _STR(key)];
    
    if (today == oldDay) {
        return NO;
    }
    
    return YES;
}

- (void)updateSignInDescLabel{
    NSString *descText = @"";
    
    if (self.dialySignIn && self.signInInfo) {
        if (!self.signInInfo.status) {
            descText = @"未签到";
            self.dialySignIn.menuRightContentColor = @"909090";
            if (_firstAppear && [self dateChanged: HJKeyPersonalCenterBadgeNeedShow]) {
                [self.tabView.tabTitleView showBadge: 2];
            }
            if (_firstAppear && [self dateChanged: KeyHJHomeSignInDate]) {
                [[NSUserDefaults standardUserDefaults] setBool: YES forKey: HJKeyDailySignInDotNeedShow];
            }
        }else{
            //已签到
            descText = @"已签到";
            self.dialySignIn.menuRightContentColor = @"999999";
            [[NSUserDefaults standardUserDefaults] setBool: NO forKey: HJKeyDailySignInDotNeedShow];
            [self.tabView.tabTitleView hideBadge: 2];
            if (!self.signInInfo.openGift) {
                descText = @"未打开幸运礼盒";
                if (_firstAppear && [self dateChanged: KeyHJHomeSignInDate]) {
                    [[NSUserDefaults standardUserDefaults] setBool: YES forKey: HJKeyDailySignInDotNeedShow];
                }
            }
        }
        self.dialySignIn.menuRightContent = descText;
        _firstAppear = NO;
    }
}

- (void)signInStatusChanged:(NSNotification*)notify {
    [self loadUserInfoWithLoading: NO];
}

- (void)setUserInfo:(HJUserProfilesResponse *)userInfo {
    _userInfo = userInfo;
    _userID = userInfo.uid;
    [self.titleView setUserProfile: userInfo];
}

#pragma mark - UI
- (void)setupUI {
    _canScroll = YES;
    [self setupTableView];
    [self setupTableHeaderView];
    [self setTitle: nil];
    
    self.viewUnderStatusBar = [[UIView alloc] initWithFrame: CGRectMake(0, 0, KScreenWidth, 20)];
    self.viewUnderStatusBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.viewUnderStatusBar];
    
    [self.tableView addViewToIgnoreTouch: self.headerTopView.avatorImageBtn];
    [self.tableView addViewToIgnoreTouch: self.headerTopView.buttonStatus];
    [self.tableView addViewToIgnoreTouch: self.headerTopView.buttonFollowing];
    [self.tableView addViewToIgnoreTouch: self.headerTopView.buttonFollower];
    [self.tableView addViewToIgnoreTouch: self.headerTopView.hjNumLabel];
    [self.tableView addViewToIgnoreTouch: self.headerTopView.buttonEditProfile];
    
    self.privateChatView = [[HJMyPrivateChatView alloc] initWithParentVC:self];
}

- (void)setTitle:(NSString *)title {
    HJPersonalNavigationTitleView *titleView = [HJPersonalNavigationTitleView fromNib];
    self.titleView = titleView;
    self.navigationItem.titleView = titleView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.titleView setUserProfile: self.userInfo];
    });
    
    
    self.titleView.hidden = YES;
}

- (void)setupTableView {
    CGRect frame = CGRectMake(0, kStatusWithTopBarHeight, KScreenWidth, KScreenHeight - kDSTabBarHeight - kStatusWithTopBarHeight);
    self.tableView = [[HJIgnoreHeaderTouchTableView alloc] initWithFrame: frame style:UITableViewStylePlain];
    self.tableView.rowHeight = KScreenHeight - kStatusBarHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [HJLoadHeader headerWithRefreshingBlock:^{
       [self refreshForFirstAppear: NO forPullDown: YES];
    }];
}

- (void)endHeaderRefresh {
    self.refreshing = NO;
    [self.tableView.mj_header endRefreshing];
}

- (void)setupTableHeaderView {
//    if (KScreenWidth < 375) {
//        _headerTopView = [[NSBundle mainBundle] loadNibNamed: @"HJMyHomeNewHeaderView_320" owner: nil options: nil][0];
//    }
//    else {
        _headerTopView = [HJMyHomeNewHeaderView fromNib];
    //}
    
    _headerTopView.delegate = self;
    _headerTopView.userInfo = self.userInfo;
    _headerTopView.frame = CGRectMake(0, 0, _headerTopView.intrinsicContentSize.width, _headerTopView.intrinsicContentSize.height);
    [self.view insertSubview: _headerTopView belowSubview: self.tableView];
//    
//    UIButton *publishButton = [UIButton buttonWithType: UIButtonTypeCustom];
//    [publishButton setImage: [UIImage imageNamed: @"tab_ic_jiahao_white"] forState: UIControlStateNormal];
//    [publishButton setImage: [UIImage imageNamed: @"tab_ic_jiahao_white_pressed"] forState: UIControlStateHighlighted];
//    [publishButton addTarget: self action: @selector(showPublishOptions) forControlEvents: UIControlEventTouchUpInside];
//    publishButton.frame = CGRectMake(_headerTopView.width - 40 - 1, 23, 40, 40);
//    [_headerTopView addSubview: publishButton];
//    [self.tableView addViewToIgnoreTouch: publishButton];
    
    UIView *realHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, KScreenWidth, _headerTopView.height - kStatusWithTopBarHeight)];
    realHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = realHeaderView;
}

- (void)setupNav
{
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"ic_gerenye_zhuanfa"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareSelf) forControlEvents:UIControlEventTouchUpInside];
    shareButton.frame = CGRectMake(0,0,40,40);
    [self setLeftBarButtonView:shareButton];
    
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishButton setImage:[UIImage imageNamed:@"tab_ic_jiahao_gray"] forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(showPublishOptions) forControlEvents:UIControlEventTouchUpInside];
    publishButton.frame = CGRectMake(0,0,40,40);
    [self setRightBarButtonView:publishButton];
}

- (void)showPublishOptions {
//    [[StatisticsManager shareInstance] customTimeEvent: start_making_video customAttributes: @{@"from": @"me"}];
//    DSTabBarController *tabVC = (DSTabBarController *)AppWindow.rootViewController;
//    [tabVC openShortVideoRecord:kRouteTypeMine];
    [[StatisticsManager shareInstance] clickWithEventId:me_publish_click];
    HJReleaseSheetManager* manager = [HJReleaseSheetManager defaultManager];
    [manager showWithRouteType:kRouteTypeMine complete:^(HJReleaseBarType type) {
        switch (type) {
            case HJReleaseBarType_Image:
                [[StatisticsManager shareInstance] customTimeEvent:start_making_picture customAttributes:@{@"from": @"me"}];
                break;
            case HJReleaseBarType_Video:
                [[StatisticsManager shareInstance] customTimeEvent:start_making_video customAttributes:@{@"from": @"me"}];
                break;
            default:
                break;
        }
    } andSuperVC:self];
    
}

- (void)shareSelf {
    HJShareData *data = [HJShareData new];
    data.relateID = self.userInfo.uid;
    data.authorID = self.userInfo.uid;
    data.shareType = HJShareTypeProfile;
    data.messageType = HJShareMessageTypeLink;
    data.pageName = HJSharePageNameProfile;
    data.imageUrlString = self.userInfo.avatarLargeUrl;
    data.image = [self.headerTopView.avatorImageBtn backgroundImageForState: UIControlStateNormal];;
    data.nickName = self.userInfo.nickname;
    [HJShareView showWithShareData:data];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KScreenHeight - kStatusWithTopBarHeight - kDSTabBarHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"tabCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGRect frame = CGRectMake(0, 0, KScreenWidth, [self tableView: self.tableView heightForRowAtIndexPath: [NSIndexPath indexPathWithIndex: 0]]);
        self.tabView = [[HJTabView alloc] initWithFrame:frame tabTitleArray: @[@"我的动态", @"私信", @"个人中心"]];
        
        self.statusView = [[HJHomeStatusView alloc] initWithTabIndex:0];
        self.statusView.parentVC = self;
        self.statusView.userId = self.userID;
        
        self.profileView = [[HJMyProfileView alloc] init];
        self.profileView.parentVC = self;
        self.profileView.profileItems = self.cellModelArray;
        IMP_WSELF()
        self.profileView.actionBlock = ^(HomeMenuModel *model) {
            [wself redirectToPageByModel: model];
        };
        
        [self.tabView addTabItemView: self.statusView];
        [self.tabView addTabItemView: self.privateChatView];
        [self.tabView addTabItemView: self.profileView];
        
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview: self.tabView];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.tableView)
        return;
    
    //NSLog(@"%@: did scroll: %@", [self.tableView class], NSStringFromCGPoint(scrollView.contentOffset));
    CGFloat tabOffsetY = [_tableView rectForSection: 0].origin.y;
    CGFloat offsetY = scrollView.contentOffset.y;
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if ((offsetY - tabOffsetY) > FLT_EPSILON || !_canScroll) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }
    else {
        _isTopIsCanNotMoveTabView = NO;
    }
    
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //到达顶部
            [[NSNotificationCenter defaultCenter] postNotificationName: kGoTopNotificationName object:nil userInfo:@{@"canScroll": @"1"}];
            _canScroll = NO;
        }
        
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //离开顶部
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }

    [self handleHeaderView: scrollView.contentOffset.y];
    [self handleTopBars];
}
//
//-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y <= -50) {
//        [self refreshForFirstAppear: NO forPullDown: YES];
//    }
//}

- (void)handleHeaderView: (CGFloat)offsetY {
//    if (offsetY < 0) {
//        self.headerTopView.frame = CGRectMake(0, 0, self.headerTopView.width, self.headerTopView.intrinsicContentSize.height - offsetY);
//    }
//    
//    if (offsetY > 0) {
//        CGRect frame = self.headerTopView.frame;
//        frame.origin.y = -offsetY;
//        self.headerTopView.frame = frame;
//    }
    
    //if (offsetY == 0)
    {
        self.headerTopView.frame = CGRectMake(0, -offsetY, self.headerTopView.width, self.headerTopView.intrinsicContentSize.height);
    }
}

- (void)handleTopBars {
    CGFloat offsetY = self.tableView.contentOffset.y;
    CGFloat maxOffset = ScreenWidth - 132 - 84;// [_tableView rectForSection: 0].origin.y;
    CGFloat alpha = offsetY / maxOffset;
    if (alpha < 0) {
        alpha = 0;
    }
    alpha = fminf(1, alpha);
    
//    self.viewUnderStatusBar.backgroundColor = [UIColor colorForHex: @"FFFFFF" alpha: alpha];
//    if (alpha >= 0.5f) {
//        [[UIApplication sharedApplication]setStatusBarStyle:[ThemeManager sharedInstance].currentStatusStyle];
//        [self setNeedsStatusBarAppearanceUpdate];
//    }
//    else {
//        [[UIApplication sharedApplication]setStatusBarStyle: UIStatusBarStyleLightContent];
//        [self setNeedsStatusBarAppearanceUpdate];
//    }
    if(offsetY > maxOffset){
        self.titleView.hidden = NO;
        self.titleView.layer.masksToBounds = YES;
        
        CGFloat bgViewY = HEIGHT(self.titleView) - (offsetY - maxOffset);
        bgViewY = bgViewY < MinY(self.titleView) ? MinY(self.titleView) : bgViewY;
        self.titleView.bgView.frame = RectSetY(self.titleView.bgView, bgViewY);
    } else {
        self.titleView.hidden = YES;
    }
    
    NSInteger intAlpha = alpha;
    [self.tabView setTitleOnTop: (intAlpha == 1)];
}

- (void)acceptMsg:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

- (void)disableScroll {
    self.tableView.scrollEnabled = NO;
}

- (void)enableScroll {
    self.tableView.scrollEnabled = YES;
}

- (void)gotoMessageCenter {
    if (self.tabView) {
        [self.tabView setSelectedTab: 1];
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [self.tabView setSelectedTab: 1];
    });
}

#pragma mark - observer
- (void)observeNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:HJProfileInfoChangedNotification object:nil];         //个人信息修改
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:HJProfileImageUploadNotification object:nil];         //头像上传成功
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"hasClickLikeInDetailPage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedNotification:) name:@"profile_authortask_success" object:nil];//用户主播任务完成
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(disableScroll) name: kScrollViewWillBeginDragging object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(enableScroll) name: kScrollViewDidEndDecelerating object: nil];
}

#pragma mark - Life cycle
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isFirstAppear = YES;
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(gotoMessageCenter) name: @"PushOpenMessageCenterRootView" object: nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[StatisticsManager shareInstance] clickWithEventId: home_me_click];
    
    [self setupData];
    [self observeNotifications];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    [self setupNav];
    [[UIApplication sharedApplication] setStatusBarHidden: NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name: kLeaveTopNotificationName object:nil];
    [self.tabView startAcceptMessage];
    
    [self refreshForFirstAppear: self.isFirstAppear forPullDown: NO];
    self.isFirstAppear = NO;
    [SVProgressHUD dismiss];
    [self handleTopBars];
    
    [[StatisticsManager shareInstance] beginPage: squareMePage];
    _mvModel.menuRightContent = [NSString stringWithFormat:@"%zd",[[HJMusicVideoManager sharedManager] numberOfMV]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self name: kLeaveTopNotificationName object: nil];
    [self.tabView stopAcceptMessage];
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRemoveHomeGuideViewNotification" object:nil];
    if (_isBigImage) {
        return;
    }

    [[StatisticsManager shareInstance] endPage: squareMePage];
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_isBigImage) {
        [[StatisticsManager shareInstance] endPage: squareMePage];
        if ([self.tableView isEditing]) {
            [self.tableView setEditing:NO];
        }
        _isBigImage = NO;
    }
}

- (void)doRefreshWhenTabBarChanged {
    [[StatisticsManager shareInstance] clickWithEventId: home_me_click];
}

#pragma mark ---下拉刷新---
- (void)refreshForFirstAppear: (BOOL)firstAppear forPullDown: (BOOL)pullDown {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    if (![AFNetworkReachabilityManager sharedManager].isReachable ) {
        [HJToastMgr showToast:@"网络连接异常，请检查网络设置"];
//        return;
    }
    
    if (!self.refreshing) {
        self.refreshing = YES;
        [self loadUserInfoWithLoading:NO];
        [self loadGuardRankWithLoading:NO];
        
        if (firstAppear || pullDown) {
            [self.tabView notifyCurrentTabPullDownRefresh];
        }
    }
}

#pragma mark --- load data begin ---
/**
 *加载用户信息
 */
- (void) loadUserInfoWithLoading:(BOOL)loading {
    //获取用户基本信息
    IMP_WSELF()
    [[HJUserIntf sharedIntfs] user_getUserInfo:self.userID
                                       success:^(id result) {
                                           if (result && [result isKindOfClass:HJUserProfilesResponse.class]) {
                                               HJUserProfilesResponse *userInfo = (HJUserProfilesResponse *)result;
                                               HJUserProfileInfo *userProfileInfo = [[HJUserProfileInfo alloc] init];
                                               userProfileInfo.userInfo = userInfo;
                                               wself.userProfile = userProfileInfo;
                                               wself.userInfo  = userInfo;
                                               wself.signInInfo = userInfo.signInInfo;
                                               [wself updateSignInDescLabel];
                                               wself.levelModel.menuRightContent = @"";
                                               wself.levelModel.menuFigureImage = [UIImage userLevelImage:userInfo.level
                                                                                                isOffical:userInfo.verifiedInfo.official
                                                                                                     size:CGSizeMake(38, 20)
                                                                                   ];
                                               
                                               if (wself.userInfo.isAuthorTask == 1) {
                                                   wself.authorLevelModel.menuCellType = HJMyHomeCellTypeRightViewNumber;
                                                   wself.authorLevelModel.menuRightContent = @"";
                                                   wself.authorLevelModel.menuFigureImage = [UIImage authorLevelImage:userInfo.authorlevel isOffical:userInfo.verifiedInfo.official size:CGSizeMake(38, 20)];
                                                   wself.authorLevelModel.menuRightContentColor = @"4A4A4A";
                                               }else{
                                                   wself.authorLevelModel.menuCellType = HJMyHomeCellTypeRightNumberArrow;
                                                   wself.authorLevelModel.menuRightContent = @"未开启";
                                                   wself.authorLevelModel.menuRightContentColor = @"909090";
                                               }
                                               
                                               //跟新本地的用户的等级和经验 关注人数粉丝数
                                               NSString *mUid = userInfo.uid;
                                               if (mUid.length > 0 && [UserPrefs userID].length >0 && [mUid isEqualToString:[UserPrefs userID]]) {
                                                   HJUserProfile *mProfile = [UserPrefs userProfile];
                                                   NSString *level = _STR(userInfo.level);
                                                   NSString *exp = _STR(userInfo.exp);
                                                   NSString *authorlevel = _STR(userInfo.authorlevel);
                                                   NSString *authorexp = _STR(userInfo.authorexp);
                                                   NSInteger followers=_INTEGER(@(userInfo.followers));
                                                   NSInteger followings=_INTEGER(@(userInfo.followings));
                                                   
                                                   if ((level.length>0 && mProfile.level.intValue != level.intValue) || (exp.length>0 && mProfile.exp.intValue != exp.intValue) || (authorexp.length>0 && mProfile.authorexp.intValue != authorexp.intValue) || (authorlevel.length>0 && mProfile.authorlevel.intValue != authorlevel.intValue) || (followings!=mProfile.followings) || (followers!=mProfile.followers)) {
                                                       mProfile.level = level;
                                                       mProfile.exp = exp;
                                                       mProfile.authorexp = authorexp;
                                                       mProfile.authorlevel = authorlevel;
                                                       mProfile.followers=followers;
                                                       mProfile.followings=followings;
                                                   }
                                                   
                                                   mProfile.equipmentsInfo = userInfo.equipmentsInfo;
                                                   [UserPrefs setUserProfile:mProfile];
                                               }
                                               
                                               wself.headerTopView.userInfo = wself.userInfo;
                                               [wself refreshProfile];
                                               
                                               //获取用户金钱相关的信息
                                               if ([[UserPrefs userID] isNotEmpty]) {
                                                   [wself loadUserWalletWithLoading:NO];
                                               }
                                           }
                                       }
                                       failure:^(NSError *error) {
                                           [self endHeaderRefresh];
                                       }];
}

/**
 *加载用户钱包信息
 */
- (void) loadUserWalletWithLoading:(BOOL)loading {
    IMP_WSELF()
    [[HJWalletManager sharedManager] loadUserWalletSuccess:^(HJUserWallet *userWallet) {
        NSString *balanc = [NSString stringWithFormat:@"%.0f", userWallet.balance];
        [UserPrefs setBalance:balanc];
        NSString *bala_p = _STR(@(userWallet.balance_p));
        if (bala_p.length > 0) {
            [UserPrefs setBalance_p:bala_p];
        }
        NSString* balancText = [NSString longNumberToShotString:(balanc.integerValue)];
        NSString* bala_pText = [NSString longNumberToShotString:(bala_p.integerValue)];
        BOOL moneyEnabled = _BOOL([[HJWalletCloudTextManager sharedManager] getStringForKey:double_type_money_switch defaultValue:0]);
        if (moneyEnabled) {
            self.accountModel.menuRightContent = Format_Str(@"花椒豆 %@ • 花椒币 %@",balancText,bala_pText);
        } else {
            self.accountModel.menuRightContent = Format_Str(@"花椒豆 %@",balancText);
        }
        [wself refreshProfile];
        [wself loadActivityWithLoading:NO];
    } failure:^(NSError *error) {
        DDLogError(@"%@",error);
        [self endHeaderRefresh];
    } isReload:YES];
}

/**
 *加载用户奖励信息
 */
- (void) loadActivityWithLoading:(BOOL)loading {
    IMP_WSELF()
    [[HJActivityIntf sharedIntfs] activity_getUserBonusWithSuccess:^(id result) {
        NSString *userId = _STR(result[@"uid"]);
        if ([userId isEqualToString:[UserPrefs userID]]) {
            NSString *mBonusStr = _STR(result[@"bonus"]);
            [UserPrefs setBouns:mBonusStr];
            [wself refreshProfile];
        }
        [self endHeaderRefresh];
    } failure:^(NSError *error) {
        DDLogError(@"%@",error);
        [self endHeaderRefresh];
    }];
}

/**
 *加载粉丝守护信息
 */
- (void)loadGuardRankWithLoading:(BOOL)loading{
    if (!_guardListEnable) return;
    
    IMP_WSELF();
    [[HJGuardRankService sharedIntfs] getGuardSumRankWithUserID:self.userID withOffset:@"0" success:^(id result) {
        if ([result isKindOfClass:HJGuardRankInfo.class]) {
            HJGuardRankInfo * coinRankList = (HJGuardRankInfo *)result;
            if (coinRankList.list.count > 0) {
                wself.fansModel.menuData = [NSMutableArray arrayWithArray:coinRankList.list];
            } else {
                wself.fansModel.menuData = nil;
            }
        } else {
            wself.fansModel.menuData = nil;
        }
        
        [wself refreshProfile];
    } failure:^(NSError *error) {
        wself.fansModel.menuData = nil;
        [wself refreshProfile];
        DDLogError(@"error%@",error);
    }];
}

#pragma mark - Jump to other page
- (void)pushSignInViewController {
    HJDailySignInViewController *vc = [HJDailySignInViewController new];
    [self showViewController:vc sender:nil];
}

- (void)pushExperienceRuleViewController {
    [[StatisticsManager shareInstance] clickWithEventId: my_user_level_enter];
    
    HJLevelWebViewController *vc = [HJLevelWebViewController new];
    NSString *newHtmlUrl = [NSString stringWithFormat:@"https://h.huajiao.com/static/html/grade/userGrade.html?uid=%@&rand=%d&skin=h5_bing", _STR([UserPrefs userID]), arc4random()];
    NSString *encodedString=[newHtmlUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    vc.url = encodedString;
    vc.hidesBottomBarWhenPushed = YES;
    [self showViewController:vc sender:nil];
}

- (void)pushWebViewControllerWithTitle:(NSString *)title andUrl:(NSString *)url {
    if (url && [url length] > 0) {
        HJWebViewController *vc = [HJWebViewController new];
        NSString *encodedString=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        vc.url = encodedString;
        vc.navTitle = title;
        vc.hidesBottomBarWhenPushed = YES;
        [self showViewController:vc sender:nil];
    }
}

- (void)MyHomeNewHeaderView:(id)view jumpToControllerWithInfo:(HJMyHomeNewHeaderView_Jump)jumpType {
    switch (jumpType) {
        case HJMyHomeNewHeaderBigAvater: {
            DDLogInfo(@"UserAction");
            HJMyHomeBigAvaterViewController * avterViewController = [[HJMyHomeBigAvaterViewController alloc] initWithNibName:@"HJMyHomeBigAvaterViewController" bundle:nil];
            avterViewController.userInfo = self.userInfo;
            avterViewController.isOwnInfo = YES;
            _isBigImage = YES;
            [self.navigationController presentViewController:avterViewController animated:YES completion:NULL];
        }
            break;
        case HJMyHomeNewHeaderProfileInfo: {
            DDLogInfo(@"UserAction");
            [[StatisticsManager shareInstance] customTimeEvent: enter_personal_page customAttributes: @{@"from" : @"home_me"}];
            NSString* url = [NSString stringWithFormat: REDIRECT_PROFILE,_STR(self.userInfo.uid)];
            [HJADManager handleURL:url WithDic:nil];
        }
            break;
            
        default:
            [self redirectToPageByType: (HomeMeumRedirectType)jumpType];
            break;
    }
}

- (void)pushAuthorLevelView {
    [[StatisticsManager shareInstance] clickWithEventId: my_anchor_level_enter];
    //主播经验值大于0跳转到主播等级页面，否则跳转到开启页面
    if (self.userInfo.authorlevel.integerValue > 0) {
        HJWebViewController *vc = [HJWebViewController new];
        
        NSString *htmlUrl = [NSString stringWithFormat:@"https://h.huajiao.com/static/html/grade/authorGrade.html?rand=%d&skin=h5_bing", arc4random()];
        NSString *encodedString = [htmlUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        vc.url = encodedString;
        vc.hidesBottomBarWhenPushed = YES;
        [self showViewController:vc sender:nil];
    }else{
        HJOpenAuthorLevelViewController *authorLevelVc = [[HJOpenAuthorLevelViewController alloc] initWithNibName:@"HJOpenAuthorLevelViewController" bundle:nil];
        [self.navigationController pushViewController:authorLevelVc animated:NO];
    }
}

- (void)pushMyEquipment {
    NSString *url = _STR([[HJWalletCloudTextManager sharedManager] getStringForKey:my_equipment_h5 defaultValue:@"https://h.huajiao.com/static/html/equipment/my.html"]);
    if ([url isNotEmpty]) {
        HJWebViewController *vc = [HJWebViewController new];
        NSString *encodedString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        vc.url = encodedString;
        vc.hidesBottomBarWhenPushed = YES;
        [self showViewController:vc sender:nil];
        self.isFirstAppear = YES;
    }
}

- (void)pushAboutAuthor {
    [[StatisticsManager shareInstance] clickWithEventId: anchor_about_enter];
    HJWebViewController *vc = [HJWebViewController new];
    NSString *url = [NSString stringWithFormat:@"https://bao.huajiao.com/wapanchor/anchor?rand=%d&skin=h5_bing", arc4random()];
    NSString *encodedString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    vc.url = encodedString;
    vc.hidesBottomBarWhenPushed = YES;
    [self showViewController:vc sender:nil];
}

-(void) refreshProfile {
    [self.profileView.tableView reloadData];
}

- (void)redirectToPageByType:(HomeMeumRedirectType)type {
    switch (type) {
        case HomeMeumMoment: {     //动态
            if (self.userInfo.feeds > 0) {
                [[StatisticsManager shareInstance] clickWithEventId: my_feed_enter];
                HJMyFeedsViewController* vc = [[HJMyFeedsViewController alloc] init];
                vc.userInfo = self.userInfo;
                vc.hidesBottomBarWhenPushed = YES;
                [self showViewController:vc sender:nil];
            }
            break;
        }
        case HomeMeumMyFollowing: //关注
        {
            if (self.userInfo.followings > 0) {
                HJUserFollowingViewController *vc = [[HJUserFollowingViewController alloc] initWithUserId:self.userID];
                vc.hidesBottomBarWhenPushed = YES;
                [self showViewController:vc sender:nil];
                [[StatisticsManager shareInstance] clickWithEventId: my_focus_list_enter];
            }
            break;
        }
        case HomeMeumMyFollower: //粉丝
        {
            if (self.userInfo.followers > 0) {
                HJUserFollowedViewController *vc = [[HJUserFollowedViewController alloc] initWithUserId:self.userID];
                vc.hidesBottomBarWhenPushed = YES;
                [self showViewController:vc sender:nil];
                [[StatisticsManager shareInstance] clickWithEventId: my_fans_list_enter];
            }
            break;
        }
        default:
            break;
    }
}

- (void)redirectToPageByModel:(HomeMenuModel *)mHomeMenuModel
{
    if(mHomeMenuModel == nil) return;
    
    switch (mHomeMenuModel.menuRedirectType) {
        case HomeMeumSign:             //一键签到
        {
            [self pushSignInViewController];
            break;
        }
        case HomeMeumFans:             //守护榜页面
        {
            if (!_guardListEnable) return;
            [[StatisticsManager shareInstance] clickWithEventId: personal_contribute_list_click];
            
            if ([HJPrivacyPolicyAlertView shouldShowThisAlertView])
            {
                HJPrivacyPolicyAlertView *ppAlertView = [HJPrivacyPolicyAlertView privacyPolicyAlertView];
                ppAlertView.frame = self.view.bounds;
                [appDelegate.tabBarController.view addSubview:ppAlertView];
                
                IMP_WSELF()
                ppAlertView.closeButtonAction = ^ {
                    HJH5GuardRankViewController* guradRankVc = [HJH5GuardRankViewController new];
                    guradRankVc.isHiddenNavBar = YES;
                    guradRankVc.url = [guradRankVc getUrl:wself.userID];
                    guradRankVc.hidesBottomBarWhenPushed = YES;
                    [wself showViewController:guradRankVc sender:nil];
                };
            }
            else
            {
                HJH5GuardRankViewController* guradRankVc = [HJH5GuardRankViewController new];
                guradRankVc.isHiddenNavBar = YES;
                guradRankVc.url = [guradRankVc getUrl:self.userID];
                guradRankVc.hidesBottomBarWhenPushed = YES;
                [self showViewController:guradRankVc sender:nil];
            }
            
            break;
        }
        case HomeMeumwatchHistory://我看过的
        {
            HJWatchHistoryViewController* vc = [HJWatchHistoryViewController new];
            [self showViewController:vc sender:nil];
            [[StatisticsManager shareInstance] clickWithEventId:my_history_enter];
            break;
        }
        case HomeMeumDraft:  //我的草稿箱
        {
            YSDraftsViewController *controller = [[YSDraftsViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case HomeMeumMyMV:   //我的MV
        {
            [[StatisticsManager shareInstance] clickWithEventId: my_MV_enter];
            HJMYMVViewController *vc = [[HJMYMVViewController alloc] initWithNibName:@"HJMYMVViewController" bundle:nil];
            [self showViewController:vc sender:nil];
            break;
        }
        case HomeMeumMyLevel:  //我的等级
        {
            [self pushExperienceRuleViewController];
            break;
        }
        case HomeMeumMyEquipment:  //我的装备
        {
            [self pushMyEquipment];
            break;
        }
        case HomeMeumMyAuthorLevel:  //我的主播等级
        {
            [self pushAuthorLevelView];
            break;
        }
        case HomeMeumAccount:       //花椒账户
        {
            [[StatisticsManager shareInstance] clickWithEventId: huajiao_account_enter];
            HJAccountViewController *vc = [[HJAccountViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self showViewController:vc sender:nil];
            break;
        }
        case HomeMeumAboutAnchor:       //主播相关
        {
            [self pushAboutAuthor];
            break;
        }
        case HomeMeumHelp:      //帮助与反馈
        {
            [[StatisticsManager shareInstance] clickWithEventId: help_enter];
            HJHelpViewController *vc = [[HJHelpViewController alloc] initWithTitle:mHomeMenuModel.menuRedirectPageTitle];
            [self showViewController:vc sender:nil];
            break;
        }
        case HomeMeumSetting:   //设置
        {
            [[StatisticsManager shareInstance] clickWithEventId: setting_enter];
            DSSettingViewController *vc = [[DSSettingViewController alloc] init];
            vc.avatarImage = self.headerTopView.headImageView.image;
            vc.hidesBottomBarWhenPushed = YES;
            vc.userInfo = self.userInfo;
            vc.contextViewcontroller = self;
            [self showViewController:vc sender:nil];
            break;
        }
        case HomeMeumApp:       //发现
        {
            HJWebViewController *vc = [HJWebViewController new];
            NSString *htmlUrl = [NSString stringWithFormat:@"%@?rand=%d", _findAppH5URL, arc4random()];
            NSString *encodedString = [htmlUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            vc.url = encodedString;
            vc.navTitle = _findAppCellTitle;
            vc.hidesBottomBarWhenPushed = YES;
            [self showViewController:vc sender:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark <UINavigationControllerDelegate>
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass: [self class]] ||
        [viewController isKindOfClass: NSClassFromString(@"HJPersonalHomePageViewController")] ||
        [viewController isKindOfClass: NSClassFromString(@"HJSeedingViewController_v2")] ||
        [viewController isKindOfClass: NSClassFromString(@"HJReplayVideoViewController")]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    else {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark -- notification --
- (void)receivedNotification:(NSNotification *)notif {
    if ([notif.name isEqualToString:HJProfileInfoChangedNotification]) {
        [[StatisticsManager shareInstance] clickWithEventId:@"user_avatar_edit_succ"];
        NSDictionary *dic = notif.userInfo;
        if ([dic[@"key"] isEqualToString:@"avatar"]) {
            NSString *value = dic[@"value"];
            self.userProfile.userInfo.avatarLargeUrl = value;
            self.userProfile.userInfo.avatar = value;
            self.headerTopView.userInfo = self.userInfo;
            HJUserProfile *profile = [UserPrefs userProfile];
            profile.avatar = value;
            profile.avatarLargeURL = value;
            [UserPrefs setUserProfile:profile];
        }
    }else if ([notif.name isEqualToString:@"hasClickLikeInDetailPage"]) {
        [self.tableView reloadData];
    } else if ([notif.name isEqualToString:@"profile_authortask_success"]) {
        [self.tableView reloadData];
    }
}

@end
