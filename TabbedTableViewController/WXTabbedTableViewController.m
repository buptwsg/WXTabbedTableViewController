//
//  WXTabbedTableViewController.m
//  TabbedTableViewController
//
//  Created by Wang Shuguang on 2017/9/18.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "WXTabbedTableViewController.h"

@interface WXTabbedTableViewController ()

@end

@implementation WXTabbedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell" forIndexPath:indexPath];
    
    return cell;
}

@end
