//
//  WXTabItemBaseView.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "WXTabItemBaseView.h"

@implementation WXTabItemBaseView

- (instancetype)initWithIndex:(NSUInteger)index size:(CGSize)viewSize {
    self = [super initWithFrame: CGRectMake(index * viewSize.width, 0, viewSize.width, viewSize.height)];
    if (self) {
        
    }
    
    return self;
}

@end
