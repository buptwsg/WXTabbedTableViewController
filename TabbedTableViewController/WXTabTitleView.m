//
//  WXTabTitleView.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "WXTabTitleView.h"

static UIColor * colorFromHex(NSString *hexColor) {
    // String should be 6 or 7 characters if it includes '#'
    if ([hexColor length]  < 6)
        return ([UIColor redColor]);
    
    // strip # if it appears
    if ([hexColor hasPrefix: @"#"])
        hexColor = [hexColor substringFromIndex:1];
    
    // if the value isn't 6 characters at this point return
    // the color black
    int n = (int)[hexColor length];
    if ((n != 6) && (n != 8))
        return ([UIColor redColor]);
    
    // Separate into r, g, b substrings
    NSString *strR, *strG, *strB, *strA;
    strR = [hexColor substringWithRange:NSMakeRange(0, 2)];
    strG = [hexColor substringWithRange:NSMakeRange(2, 2)];
    strB = [hexColor substringWithRange:NSMakeRange(4, 2)];
    strA = (n==8) ? [hexColor substringWithRange:NSMakeRange(6, 2)] : nil;
    
    // Scan values
    unsigned r, g, b, a=255.f;
    [[NSScanner scannerWithString:strR] scanHexInt:&r];
    [[NSScanner scannerWithString:strG] scanHexInt:&g];
    [[NSScanner scannerWithString:strB] scanHexInt:&b];
    if (strA) {
        [[NSScanner scannerWithString:strA] scanHexInt:&a];
    }
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:((float) a / 255.0f)];
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
        _selectedColor = colorFromHex(@"161418");
        _unselectedColor = colorFromHex(@"979393");
        _selectedFont = fontFromNameAndSize(@"PingFangSC-Medium", 14);
        _unselectedFont = fontFromNameAndSize(@"PingFangSC-Regular", 14);
        _indicatorColor = colorFromHex(@"161418");
        _bottomLineColor = colorFromHex(@"E1E1E1");
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
