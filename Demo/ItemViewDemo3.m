//
//  ItemViewDemo3.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/23.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "ItemViewDemo3.h"

@implementation ItemViewDemo3

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
    NSLog(@"Demo 3, view will appear, reason = %ld", reason);
}

- (void)viewWillDisappear:(WXTabItemViewDisappearReason)reason {
    [super viewWillDisappear: reason];
    NSLog(@"Demo 3, view will disappear, reason = %ld", reason);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell" forIndexPath: indexPath];
    cell.textLabel.text = [NSString stringWithFormat: @"Demo 3, row = %ld", indexPath.row];
    return cell;
}

@end
