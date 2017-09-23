//
//  CustomTabTitleView.h
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/23.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXTabTitleViewProtocol.h"

@interface CustomTabTitleView : UIView <WXTabTitleViewProtocol>

- (instancetype)initWithTitles: (NSArray<NSString*> *)titles;

@end
