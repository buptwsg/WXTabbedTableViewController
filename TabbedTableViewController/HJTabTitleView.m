//
//  HJTabTitleView.m
//  living
//
//  Created by wang shuguang on 2016/10/28.
//  Copyright © 2016年 MJHF. All rights reserved.
//

#import "HJTabTitleView.h"
#import "HJOtherHomeConst.h"
#import "HJMessageCenterManager.h"
#import "HJSignInManager.h"

@interface HJTabTitleView()

@property (nonatomic, strong) NSMutableArray<UIButton*> *titleBtnArray;
@property (nonatomic, strong) UIView  *indicateLine;
@property (nonatomic, strong) UIView *leftSeparator;
@property (nonatomic, strong) UIView *rightSeparator;
@property (nonatomic, strong) UIView *bottomSeparator;

@end

@implementation HJTabTitleView
{
    NSInteger _selectedIndex;
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

-(instancetype)initWithTitleArray:(NSArray *)titleArray{
    self = [super initWithFrame: CGRectMake(0, 0, KScreenWidth, kTabTitleViewHeight)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _titleBtnArray = [NSMutableArray array];
        CGFloat btnWidth = KScreenWidth / titleArray.count;

        for (int i=0; i<titleArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
            btn.frame = CGRectMake(i*btnWidth, 0, btnWidth, kTabTitleViewHeight);
            [btn setTitle: titleArray[i] forState:UIControlStateNormal];
            
            if (i == 0) {
                btn.titleLabel.font = [self selectedFont];
                [btn setTitleColor: [self selectedColor] forState: UIControlStateNormal];
            }
            else {
                [btn setTitleColor: [self unSelectedColor] forState: UIControlStateNormal];
                btn.titleLabel.font = [self unSelectedFont];
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents: UIControlEventTouchUpInside];
            
            [self addSubview:btn];
            [_titleBtnArray addObject:btn];
        }
        
        CGFloat width = btnWidth * 0.85;
        _indicateLine = [[UIView alloc] initWithFrame:CGRectMake((btnWidth - width) / 2, self.height - 2, width, 2)];
        _indicateLine.backgroundColor = [self selectedColor];
        _indicateLine.layer.cornerRadius = _indicateLine.height / 2;
        [self addSubview:_indicateLine];
        
//        UIColor *separatorColor = [UIColor whiteColor];
//        CGFloat scale = [UIScreen mainScreen].scale;
        
//        //左边的垂直分隔线
//        UIView *line1 = [[UIView alloc] initWithFrame: CGRectMake(KScreenWidth / 3, 10, 1 / scale, 24)];
//        line1.backgroundColor = separatorColor;
//        line1.alpha = 0.3;
//        [self addSubview: line1];
//        self.leftSeparator = line1;
//        
//        //右边的垂直分隔线
//        UIView *line2 = [[UIView alloc] initWithFrame: CGRectMake(KScreenWidth * 2 / 3, 10, 1 / scale, 24)];
//        line2.backgroundColor = separatorColor;
//        line2.alpha = 0.3;
//        [self addSubview: line2];
//        self.rightSeparator = line2;
        
        //下边的水平分隔线
        UIView *line3 = [[UIView alloc] initWithFrame: CGRectMake(0, kTabTitleViewHeight-.5, self.frame.size.width, .5)];
        line3.backgroundColor = [UIColor colorForHex: @"E1E1E1"];
        [self addSubview: line3];
        self.bottomSeparator = line3;
//
//        //上边的水平分隔线
//        UIView *line4 = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, .5)];
//        line4.backgroundColor = separatorColor;
//        [self addSubview: line4];
        
        [self messageCenterStatusChanged];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageCenterStatusChanged) name:HJMessageCenterMessageStatusChangedNotification object:nil];
    }
    
    return self;
}

-(void)clickBtn : (UIButton *)btn{
    NSInteger tag = btn.tag;
    if (tag == _selectedIndex)
        return;
    
    [self setItemSelected:tag];
    
    if (self.titleClickBlock) {
        self.titleClickBlock(tag);
    }
}

-(void)setItemSelected: (NSInteger)column{
    _selectedIndex = column;
//    BOOL onTop = self.onTop;// (fabs(self.onTopProgress - 1.0f) < FLT_EPSILON);
    
    for (int i=0; i<_titleBtnArray.count; i++) {
        UIButton *btn = _titleBtnArray[i];
        if (i == column) {
            btn.titleLabel.font = [self selectedFont];
            [btn setTitleColor: [self selectedColor] forState: UIControlStateNormal];
        }else{
            btn.titleLabel.font = [self unSelectedFont];
            [btn setTitleColor: [self unSelectedColor] forState: UIControlStateNormal];
        }
    }
    
    UIButton *button = _titleBtnArray[_selectedIndex];
    _indicateLine.center = CGPointMake(button.center.x, _indicateLine.center.y);
    [self hideBadge: column];
    if (column == 2) {
        [[NSUserDefaults standardUserDefaults] setInteger: [[HJSignInManager shareManager] getCurrentDate] forKey: HJKeyPersonalCenterBadgeNeedShow];
    }
}

- (void)setOnTop:(BOOL)onTop {
    _onTop = onTop;
}

- (void)setShowBottomSeparator:(BOOL)showBottomSeparator {
    _showBottomSeparator = showBottomSeparator;
    self.bottomSeparator.hidden = !showBottomSeparator;
}

- (UIColor*)selectedColor {
    return [UIColor colorForHex: @"161418"];
}

- (UIColor*)unSelectedColor {
    return [UIColor colorForHex:@"979393"];
}

- (UIColor*)selectedBackgroundColor {
    return [UIColor colorForHex: @"FF53A0"];
}

- (UIFont*)selectedFont {
    UIFont *font = [UIFont fontWithName: @"PingFangSC-Medium" size: 14];
    if (nil == font) {
        font = [UIFont boldSystemFontOfSize: 14];
    }
    return font;
}

- (UIFont *)unSelectedFont {
    UIFont *font = [UIFont fontWithName: @"PingFangSC-Regular" size: 14];
    if (nil == font) {
        font = [UIFont systemFontOfSize: 14];
    }
    return font;
}

- (void)messageCenterStatusChanged {
    NSInteger numberOfMessages = [[HJMessageCenterManager sharedManager] numberOfAllUnreadPrivateChat];
    if (numberOfMessages > 0) {
        [self setPrivateChatBadgeValue: numberOfMessages];
    }
    else {
        numberOfMessages = [[HJMessageCenterManager sharedManager] numberOfAllUnreadSystemMessage];
        
        if (numberOfMessages > 0) {
            [self setPrivateChatBadgeValue: 0];
        }
        else {
            [self setPrivateChatBadgeValue: -1];
        }
    }
}

- (void)setPrivateChatBadgeValue: (NSInteger)value {
    NSInteger badgeTag = 100;
    UIButton* privateBT = _titleBtnArray.count > 2 ? _titleBtnArray[1] : nil;
    
    if(privateBT){
        UIView *badgeView = [privateBT viewWithTag: badgeTag];
        if (!badgeView) {
            badgeView = [[UIView alloc] init];
            badgeView.backgroundColor = [UIColor colorForHex: @"FE4945"];
            badgeView.tag = badgeTag;
            [privateBT addSubview: badgeView];
            
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize: 12];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [badgeView addSubview: label];
        }
        UILabel *badgeLabel = badgeView.subviews[0];
        if (value < 0) {
            badgeView.hidden = YES;
            return;
        }
        
        badgeView.hidden = NO;
        badgeLabel.hidden = value == 0;
        if (value == 0) {
            CGFloat width = 6;
            badgeView.frame = CGRectMake(privateBT.width/2 + 15, 12, width, width);
            badgeView.layer.cornerRadius = width/2;
            return;
        }
        
        NSString *badgeText = @"";
        if (value > 99) {
            badgeText = @"99+";
        }
        else if (value > 0){
            badgeText = [NSString stringWithFormat: @"%ld", value];
        }
        badgeLabel.text = badgeText;
        
        CGFloat minBadgeWidth = 16;
        CGRect labelRect = [badgeText boundingRectWithSize:CGSizeMake(INT_MAX, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : badgeLabel.font} context:nil];
        
        CGFloat width = (labelRect.size.width + 8) > minBadgeWidth ? (labelRect.size.width + 8) : minBadgeWidth;
        badgeView.frame = CGRectMake(privateBT.width/2 + minBadgeWidth, 5, width, minBadgeWidth);
        badgeView.layer.cornerRadius = badgeView.frame.size.height / 2.0;
        badgeLabel.frame = badgeView.bounds;
        badgeLabel.frame = RectSetY(badgeLabel, MinY(badgeLabel));
    }
}

- (void)hideBadge: (NSInteger)buttonIdx {
    NSInteger badgeTag = 200;
    UIButton* tabTitleButton = _titleBtnArray.count > buttonIdx ? _titleBtnArray[buttonIdx] : nil;
    
    if(tabTitleButton){
        UIView *badgeView = [tabTitleButton viewWithTag: badgeTag];
        if (badgeView) {
            badgeView.hidden = YES;
        }
    }
}

- (void)showBadge: (NSInteger)buttonIdx {
    NSInteger badgeTag = 200;
    UIButton* tabTitleButton = _titleBtnArray.count > buttonIdx ? _titleBtnArray[buttonIdx] : nil;
    
    if(tabTitleButton){
        UIView *badgeView = [tabTitleButton viewWithTag: badgeTag];
        if (!badgeView) {
            badgeView = [[UIView alloc] init];
            badgeView.backgroundColor = [UIColor colorForHex: @"FE4945"];
            badgeView.tag = badgeTag;
            [tabTitleButton addSubview: badgeView];
        }
        badgeView.hidden = NO;
        CGFloat width = 6;
        badgeView.frame = CGRectMake(tabTitleButton.width/2 + 25, 12, width, width);
        badgeView.layer.cornerRadius = width/2;
    }
}



-(void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    NSUInteger btnCount = _titleBtnArray.count;
    [_titleArray enumerateObjectsUsingBlock:^(NSString* title, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= btnCount) {
            *stop = YES;
            return;
        }
        [_titleBtnArray[idx] setTitle:title forState:UIControlStateNormal];
    }];
}

@end
