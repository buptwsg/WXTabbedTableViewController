//
//  HJTabTitleView.h
//  living
//
//  Created by wang shuguang on 2016/10/28.
//  Copyright © 2016年 MJHF. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  定义点击的block
 *
 *  @param NSInteger 点击column数
 */
typedef void (^HJTabTitleClickBlock)(NSInteger);


@interface HJTabTitleView : UIView

@property (nonatomic, copy) NSArray* titleArray;

-(instancetype)initWithTitleArray:(NSArray *)titleArray;

-(void)setItemSelected: (NSInteger)column;

@property (nonatomic, copy) HJTabTitleClickBlock titleClickBlock;

@property (nonatomic) BOOL onTop;

@property (nonatomic) BOOL showBottomSeparator;

- (void)showBadge: (NSInteger)buttonIdx;

- (void)hideBadge: (NSInteger)buttonIdx;
@end
