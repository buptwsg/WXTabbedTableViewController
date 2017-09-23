//
//  WXTabItemBaseView.h
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXTabItemBaseView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

- (instancetype)initWithIndex: (NSUInteger)index size: (CGSize)viewSize;

@end
