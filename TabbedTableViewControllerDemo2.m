//
//  TabbedTableViewControllerDemo2.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/23.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "TabbedTableViewControllerDemo2.h"
#import "ItemViewDemo1.h"

@interface TabbedTableViewControllerDemo2 ()

@end

@implementation TabbedTableViewControllerDemo2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray<NSString*> *)tabTitles {
    return @[@"First"];
}

- (WXTabItemBaseView*)itemViewAtIndex:(NSUInteger)index size:(CGSize)viewSize {
    return [[ItemViewDemo1 alloc] initWithIndex: index size: viewSize];
}

@end
