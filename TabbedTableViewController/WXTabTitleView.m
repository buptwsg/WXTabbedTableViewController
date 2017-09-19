//
//  WXTabTitleView.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "WXTabTitleView.h"

@implementation WXTabTitleView
@synthesize tabTitles = _tabTitles;

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithTitles: @[@"First", @"Second"]];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithTitles: @[@"First", @"Second"]];
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [super initWithFrame: CGRectMake(0, 0, screenSize.width, 44)];
    if (self) {
        _tabTitles = [titles copy];
    }
    
    return self;
}

@end
