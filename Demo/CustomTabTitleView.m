//
//  CustomTabTitleView.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/23.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "CustomTabTitleView.h"

@implementation CustomTabTitleView {
    UIButton *_leftButton;
    UIButton *_rightButton;
    NSUInteger _selectedItem;
}

@synthesize tabTitles = _tabTitles;
@synthesize titleClickBlock = _titleClickBlock;
@synthesize selectedItem = _selectedItem;

- (instancetype)initWithTitles: (NSArray<NSString*> *)titles {
    self = [super initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    if (self) {
        _tabTitles = [titles copy];
        
        self.backgroundColor = [UIColor blackColor];
        _leftButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _leftButton.backgroundColor = [UIColor blueColor];
        _leftButton.frame = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height);
        _leftButton.tag = 0;
        [_leftButton addTarget: self action: @selector(buttonClicked:) forControlEvents: UIControlEventTouchUpInside];
        [_leftButton setTitle: titles[0] forState: UIControlStateNormal];
        [self addSubview: _leftButton];
        
        _rightButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _rightButton.backgroundColor = [UIColor greenColor];
        _rightButton.frame = CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height);
        _rightButton.tag = 1;
        [_rightButton addTarget: self action: @selector(buttonClicked:) forControlEvents: UIControlEventTouchUpInside];
        [_rightButton setTitle: titles[1] forState: UIControlStateNormal];
        [self addSubview: _rightButton];
    }
    return self;
}

- (void)setSelectedItem:(NSUInteger)item {
    if (item != _selectedItem) {
        _selectedItem = item;
        if (item == 0) {
            _leftButton.backgroundColor = [UIColor blueColor];
            _rightButton.backgroundColor = [UIColor greenColor];
        }
        else {
            _leftButton.backgroundColor = [UIColor greenColor];
            _rightButton.backgroundColor = [UIColor blueColor];
        }
    }
}

- (void)setTitle:(NSString *)title forIndex:(NSUInteger)index {
    
}

- (void)buttonClicked: (UIButton*)sender {
    NSUInteger tag = sender.tag;
    NSUInteger oldSelectedItem = self.selectedItem;
    [self setSelectedItem: tag];
    if (self.titleClickBlock) {
        self.titleClickBlock(tag, oldSelectedItem);
    }
}

@end
