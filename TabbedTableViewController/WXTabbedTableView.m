//
//  WXTabbedTableView.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "WXTabbedTableView.h"

@implementation WXTabbedTableView {
    NSMutableArray *_viewsToIgnoreTouch;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.viewsToIgnoreTouch) {
        CGPoint convertPoint = [view convertPoint: point fromView: self];
        if (!view.isHidden && view.userInteractionEnabled && [view pointInside: convertPoint withEvent: event]) {
            return NO;
        }
    }
    
    return [super pointInside: point withEvent: event];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)addViewToIgnoreTouch:(UIView *)view {
    [self.viewsToIgnoreTouch addObject: view];
}

- (void)removeViewToIgnoreTouch:(UIView *)view {
    [self.viewsToIgnoreTouch removeObject: view];
}

- (NSMutableArray*)viewsToIgnoreTouch {
    if (nil == _viewsToIgnoreTouch) {
        _viewsToIgnoreTouch = [[NSMutableArray alloc] init];
    }
    
    return _viewsToIgnoreTouch;
}


@end
