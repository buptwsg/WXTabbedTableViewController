//
//  WXTabTitleView.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "WXTabTitleView.h"

static UIColor * colorFromHex(int hex) {
    unsigned r, g, b;
    r = (hex & 0xff0000) >> 16;
    g = (hex & 0x00ff00) >> 8;
    b = hex & 0x0000ff;
    return [UIColor colorWithRed: 1.0*r/255 green: 1.0*g/255 blue: 1.0*b/255 alpha: 1];
}

static UIFont * fontFromNameAndSize(NSString *name, CGFloat fontSize) {
    UIFont *font = [UIFont fontWithName: name size: fontSize];
    if (!font) {
        font = [UIFont systemFontOfSize: fontSize];
    }
    
    return font;
}

@interface WXTabTitleView ()

@property (strong, nonatomic) NSMutableArray<UIButton*> *titleButtonArray;
@property (strong, nonatomic) UIView *indicatorLine;
@property (strong, nonatomic) UIView *bottomLine;
@property (nonatomic) NSUInteger selectedItem;

@end

@implementation WXTabTitleView
@synthesize tabTitles = _tabTitles;
@synthesize titleClickBlock = _titleClickBlock;

#pragma mark - Init
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
        _selectedColor = colorFromHex(0x161418);
        _unselectedColor = colorFromHex(0x979393);
        _selectedFont = fontFromNameAndSize(@"PingFangSC-Medium", 14);
        _unselectedFont = fontFromNameAndSize(@"PingFangSC-Regular", 14);
        _indicatorColor = colorFromHex(0x161418);
        _bottomLineColor = colorFromHex(0xE1E1E1);
        _titleButtonArray = [[NSMutableArray alloc] init];
        _selectedItem = 0;
        
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    for (int i = 0; i < self.tabTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        [button setTitle: self.tabTitles[i] forState:UIControlStateNormal];
        
        if (i == 0) {
            button.titleLabel.font = [self selectedFont];
            [button setTitleColor: [self selectedColor] forState: UIControlStateNormal];
        }
        else {
            button.titleLabel.font = [self unselectedFont];
            [button setTitleColor: [self unselectedColor] forState: UIControlStateNormal];
        }
        
        button.tag = i;
        [button addTarget:self action:@selector(clickButton:) forControlEvents: UIControlEventTouchUpInside];
        
        [self addSubview: button];
        [_titleButtonArray addObject: button];
    }
    
    _indicatorLine = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 0, 2)];
    _indicatorLine.backgroundColor = [self indicatorColor];
    _indicatorLine.layer.cornerRadius = _indicatorLine.frame.size.height / 2;
    [self addSubview:_indicatorLine];
    
    _bottomLine = [[UIView alloc] initWithFrame: CGRectZero];
    _bottomLine.backgroundColor = [self bottomLineColor];
    [self addSubview: _bottomLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonWidth = self.frame.size.width / self.tabTitles.count;
    for (UIButton *button in self.titleButtonArray) {
        button.frame = CGRectMake(buttonWidth * button.tag, 0, buttonWidth, self.frame.size.height);
    }
    
    CGFloat indicatorWidth = buttonWidth * 0.85;
    CGFloat indicatorHeight = _indicatorLine.frame.size.height;
    _indicatorLine.frame = CGRectMake(self.titleButtonArray[self.selectedItem].center.x - 0.5 * indicatorWidth, self.frame.size.height - indicatorHeight, indicatorWidth, indicatorHeight);
    
    _bottomLine.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
}

#pragma mark - Accessor Methods
- (void)setTabTitles:(NSArray<NSString *> *)tabTitles {
    _tabTitles = [tabTitles copy];
    [_tabTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_titleButtonArray[idx] setTitle: obj forState: UIControlStateNormal];
    }];
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [self.titleButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == self.selectedItem) {
            [obj setTitleColor: selectedColor forState: UIControlStateNormal];
        }
    }];
}

- (void)setUnselectedColor:(UIColor *)unselectedColor {
    _unselectedColor = unselectedColor;
    [self.titleButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != self.selectedItem) {
            [obj setTitleColor: unselectedColor forState: UIControlStateNormal];
        }
    }];
}

- (void)setSelectedFont:(UIFont *)selectedFont {
    _selectedFont = selectedFont;
    [self.titleButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == self.selectedItem) {
            obj.titleLabel.font = selectedFont;
        }
    }];
}

- (void)setUnselectedFont:(UIFont *)unselectedFont {
    _unselectedFont = unselectedFont;
    [self.titleButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != self.selectedItem) {
            obj.titleLabel.font = unselectedFont;
        }
    }];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    self.indicatorLine.backgroundColor = _indicatorColor;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    _bottomLineColor = bottomLineColor;
    self.bottomLine.backgroundColor = _bottomLineColor;
}

#pragma mark - WXTabTitleViewProtocol
- (void)setSelectedItem:(NSUInteger)item {
    if (_selectedItem != item) {
        _selectedItem = item;
        [self.titleButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == _selectedItem) {
                [obj setTitleColor: [self selectedColor] forState: UIControlStateNormal];
                obj.titleLabel.font = [self selectedFont];
            }
            else {
                [obj setTitleColor: [self unselectedColor] forState: UIControlStateNormal];
                obj.titleLabel.font = [self unselectedFont];
            }
        }];
        
        [self setNeedsLayout];
    }
}

#pragma mark - Private Methods
- (void)clickButton: (UIButton*)sender {
    NSUInteger tag = sender.tag;
    [self setSelectedItem: tag];
    if (self.titleClickBlock) {
        self.titleClickBlock(tag);
    }
}
@end
