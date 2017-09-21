//
//  ViewController.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/17.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "ViewController.h"
#import "TabbedTableViewControllerDemo1.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"测试用例";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *caseTitles = @[@"直接使用ViewController", @"没有Tab", @"2个Tab", @"3个Tab", @"Collection View in TabItemView", @"自定义Tab视图"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell" forIndexPath: indexPath];
    cell.textLabel.text = caseTitles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    WXTabbedTableViewController *vc = [[TabbedTableViewControllerDemo1 alloc] init];
    [self.navigationController pushViewController: vc animated: YES];
}
@end
