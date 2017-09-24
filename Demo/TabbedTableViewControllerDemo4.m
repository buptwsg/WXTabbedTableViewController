//
//  TabbedTableViewControllerDemo4.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/23.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "TabbedTableViewControllerDemo4.h"
#import "ItemViewDemo1.h"
#import "ItemViewDemo2.h"
#import "ItemViewDemo4_CollectionView.h"

@interface TabbedTableViewControllerDemo4 ()

@end

@implementation TabbedTableViewControllerDemo4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *header = [[UIView alloc] initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    header.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectZero];
    label.text = @"Table Header View";
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    label.frame = CGRectMake((header.frame.size.width - label.frame.size.width) / 2, (header.frame.size.height - label.frame.size.height) / 2, label.frame.size.width, label.frame.size.height);
    [header addSubview: label];
    self.tableView.tableHeaderView = header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray<NSString*> *)tabTitles {
    return @[@"Demo 1", @"Demo 2", @"Demo 3"];
}

- (WXTabItemBaseView*)itemViewAtIndex:(NSUInteger)index size:(CGSize)viewSize {
    if (0 == index) {
        return [[ItemViewDemo1 alloc] initWithIndex: index size: viewSize];
    }
    else if (1 == index) {
        return [[ItemViewDemo2 alloc] initWithIndex: index size: viewSize];
    }
    else {
        return [[ItemViewDemo4_CollectionView alloc] initWithIndex: index size: viewSize];
    }
}

@end
