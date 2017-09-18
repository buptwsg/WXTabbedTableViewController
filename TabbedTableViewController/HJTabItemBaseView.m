//
//  HJTabItemBaseView.m
//  living
//
//  Created by wang shuguang on 2016/10/28.
//  Copyright © 2016年 MJHF. All rights reserved.
//

#import "HJTabItemBaseView.h"
#import "HJOtherHomeConst.h"

@interface HJTabItemBaseView ()

@end

@implementation HJTabItemBaseView

- (instancetype)initWithTabIndex: (NSInteger)index {
    self = [super init];
    if (self) {
        _index = index;
        self.frame = KScreenRect;
        //不应该在这里设置大小,大小应该根外层scrollView一致.
        //self.backgroundColor = [UIColor colorForHex: @"E2E2E2"];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.tableView.backgroundColor = [UIColor colorForHex: @"F2F2F2"];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:self.tableView];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self startAcceptMessage];
    }
    
    return self;
}

-(void)dealloc{
    self.tableView.delegate=nil;
    self.tableView.dataSource=nil;
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)startAcceptMessage {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kGoTopNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kLeaveTopNotificationName object:nil];//其中一个TAB离开顶部的时候，如果其他几个偏移量不为0的时候，要把他们都置为0
}

- (void)stopAcceptMessage {
    [[NSNotificationCenter defaultCenter] removeObserver: self name: kGoTopNotificationName object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: kLeaveTopNotificationName object: nil];
}

- (void)viewWillDisappear {
}

- (void)viewWillAppear {
}

- (void)doPullDownRefresh { 
}

- (CGRect)ignoreScrollArea {
    return CGRectZero;
}

-(void)acceptMsg : (NSNotification *)notification{
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString: kGoTopNotificationName]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            self.tableView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString: kLeaveTopNotificationName]){
        self.tableView.contentOffset = CGPointZero;
        self.canScroll = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
    }
}

//避免编译器警告
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

//避免编译器警告
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView != self.tableView) {
        return;
    }
    
    if (!self.canScroll) {
        [scrollView setContentOffset: CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeaveTopNotificationName object:nil userInfo:@{@"canScroll": @"1"}];
    }
}
@end
