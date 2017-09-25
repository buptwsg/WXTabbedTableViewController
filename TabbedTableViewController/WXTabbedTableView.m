//
//  WXTabbedTableView.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "WXTabbedTableView.h"

@implementation WXTabbedTableView {
    NSMutableArray *_viewsToReceiveTouch;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.viewsToReceiveTouch) {
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

- (void)addViewToReceiveTouch:(UIView *)view {
    [self.viewsToReceiveTouch addObject: view];
}

- (void)removeViewToReceiveTouch:(UIView *)view {
    [self.viewsToReceiveTouch removeObject: view];
}

- (NSMutableArray*)viewsToReceiveTouch {
    if (nil == _viewsToReceiveTouch) {
        _viewsToReceiveTouch = [[NSMutableArray alloc] init];
    }
    
    return _viewsToReceiveTouch;
}

@end
