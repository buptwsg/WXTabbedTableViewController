//
//  HJOtherHomeScrollView.m
//  living
//
//  Created by wang shuguang on 2016/10/31.
//  Copyright © 2016年 MJHF. All rights reserved.
//

#import "HJOtherHomeScrollView.h"
#import "HJTabItemBaseView.h"

@implementation HJOtherHomeScrollView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    HJTabItemBaseView *itemView = nil;
    if (self.currentPage >= 0 && self.currentPage < self.subviews.count) {
        itemView = (HJTabItemBaseView*)self.subviews[self.currentPage];
    }
    
    CGRect rect = CGRectZero;
    if (itemView) {
        rect = [itemView ignoreScrollArea];
    }
    
    if (CGRectGetHeight(rect) > 0 && CGRectContainsPoint(rect, point)) {
        self.scrollEnabled = NO;
    }
    else {
        self.scrollEnabled = YES;
    }
    
    return [super pointInside: point withEvent: event];
}

@end
