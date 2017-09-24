//
//  ItemViewDemo2.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/23.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "ItemViewDemo2.h"

@implementation ItemViewDemo2

- (instancetype)initWithIndex:(NSUInteger)index size:(CGSize)viewSize {
    self = [super initWithIndex: index size: viewSize];
    if (self) {
        UITableView *tableView = (UITableView*)self.scrollView;
        [tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"cell"];
    }
    return self;
}

- (void)viewWillAppear:(WXTabItemViewAppearReason)reason {
    [super viewWillAppear: reason];
    NSLog(@"Demo 2, view will appear, reason = %ld", reason);
}

- (void)viewWillDisappear:(WXTabItemViewDisappearReason)reason {
    [super viewWillDisappear: reason];
    NSLog(@"Demo 2, view will disappear, reason = %ld", reason);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell" forIndexPath: indexPath];
    cell.textLabel.text = [NSString stringWithFormat: @"Demo 2, row = %ld", indexPath.row];
    return cell;
}

@end
