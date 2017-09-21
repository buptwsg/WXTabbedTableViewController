//
//  TabbedTableViewControllDemo1.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/21.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "TabbedTableViewControllerDemo1.h"

@interface TabbedTableViewControllerDemo1 ()

@end

@implementation TabbedTableViewControllerDemo1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *header = [[UIView alloc] initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    header.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(100, 100, 100, 20)];
    label.text = @"这是表头";
    label.textColor = [UIColor whiteColor];
    [header addSubview: label];
    self.tableView.tableHeaderView = header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
