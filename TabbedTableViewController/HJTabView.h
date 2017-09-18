//
//  HJTabView.h
//  living
//
//  Created by wang shuguang on 2016/10/28.
//  Copyright © 2016年 MJHF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJTabTitleView.h"

@class HJTabTitleView;
@class HJTabItemBaseView;

@interface HJTabView : UIView
@property (nonatomic, strong) NSArray* tabTitleArray;
@property (nonatomic, strong, readonly) HJTabTitleView *tabTitleView;

-(instancetype)initWithFrame:(CGRect)frame tabTitleArray:(NSArray *)tabTitleArray;

- (void)addTabItemView: (HJTabItemBaseView*)itemView;

- (void)startAcceptMessage;
- (void)stopAcceptMessage;

- (void)notifyCurrentTabPullDownRefresh;

- (void)setTitleOnTop: (BOOL)onTop;

- (void)setSelectedTab: (NSInteger)index;


@end
