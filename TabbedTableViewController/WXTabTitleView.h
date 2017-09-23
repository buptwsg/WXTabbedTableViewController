//
//  WXTabTitleView.h
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXTabTitleViewProtocol.h"

@interface WXTabTitleView : UIView <WXTabTitleViewProtocol>

@property (strong, nonatomic) UIColor *selectedColor;
@property (strong, nonatomic) UIColor *unselectedColor;
@property (strong, nonatomic) UIFont *selectedFont;
@property (strong, nonatomic) UIFont *unselectedFont;

@property (strong, nonatomic) UIColor *indicatorColor;
@property (nonatomic) BOOL indicatorWidthEqualToTitle;
@property (nonatomic) CGFloat indicatorHeight;
@property (strong, nonatomic) UIColor *bottomLineColor;

- (instancetype)initWithTitles: (NSArray<NSString*> *)titles NS_DESIGNATED_INITIALIZER;

@end
