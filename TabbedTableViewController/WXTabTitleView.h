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

- (instancetype)initWithTitles: (NSArray<NSString*> *)titles NS_DESIGNATED_INITIALIZER;

@end
