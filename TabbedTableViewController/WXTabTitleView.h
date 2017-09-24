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

/**color for the selected title text*/
@property (strong, nonatomic) UIColor *selectedColor;

/**color for the unselected title text*/
@property (strong, nonatomic) UIColor *unselectedColor;

/**font for the selected title text*/
@property (strong, nonatomic) UIFont *selectedFont;

/**font for the unselected title text*/
@property (strong, nonatomic) UIFont *unselectedFont;

/**color for the indicator line*/
@property (strong, nonatomic) UIColor *indicatorColor;

/**whether the indicator line's width is equal to the title text*/
@property (nonatomic) BOOL indicatorWidthEqualToTitle;

/**height of the indicator line*/
@property (nonatomic) CGFloat indicatorHeight;

/**color for the bottom line*/
@property (strong, nonatomic) UIColor *bottomLineColor;

- (instancetype)initWithTitles: (NSArray<NSString*> *)titles NS_DESIGNATED_INITIALIZER;

@end
