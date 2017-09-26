//
//  WXTabView.h
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXTabTitleViewProtocol.h"

@class WXTabItemBaseView;

/**
 An internal view class, users should not care about it.
 */
@interface WXTabView : UIView

@property (weak, nonatomic) UIScrollView *outerScrollView;

@property (nonatomic) BOOL horizontalScrollEnabled;

- (instancetype)initWithFrame:(CGRect)frame titleView: (UIView<WXTabTitleViewProtocol> *)titleView;

- (void)addItemView: (WXTabItemBaseView*)itemView;

- (void)viewWillAppear;

- (void)viewWillDisappear;

@end
