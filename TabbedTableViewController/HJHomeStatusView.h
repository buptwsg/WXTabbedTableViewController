//
//  HJMyStatusView.h
//  living
//
//  Created by sulirong on 2017/8/8.
//  Copyright © 2017年 MJHF. All rights reserved.
//

#import "HJTabItemBaseView.h"
#import "HJTrendsLayoutVC.h"

@interface HJHomeStatusView : HJTabItemBaseView
@property (nonatomic,strong,readonly) HJTrendsLayoutVC* flowLayoutVC;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,assign) CGFloat headerHeight;
@end
