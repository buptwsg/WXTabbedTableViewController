//
//  ViewController.m
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/17.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import "ViewController.h"
#import "TabbedTableViewControllerDemo1.h"
#import "TabbedTableViewControllerDemo2.h"
#import "TabbedTableViewControllerDemo3.h"
#import "TabbedTableViewControllerDemo4.h"
#import "TabbedTableViewControllerDemo5.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Test Cases";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *caseTitles = @[@"Use the view controller as is", @"No Tab", @"Three Tabs", @"Collection view in TabItemView", @"Self defined Tab title view"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell" forIndexPath: indexPath];
    cell.textLabel.text = caseTitles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    switch (indexPath.row) {
        case 0:
        {
            WXTabbedTableViewController *vc = [[TabbedTableViewControllerDemo1 alloc] init];
            [self.navigationController pushViewController: vc animated: YES];
        }
            break;
            
        case 1:
        {
            WXTabbedTableViewController *vc = [[TabbedTableViewControllerDemo2 alloc] init];
            [self.navigationController pushViewController: vc animated: YES];
        }
            break;
            
        case 2: {
            TabbedTableViewControllerDemo3 *vc = [[TabbedTableViewControllerDemo3 alloc] init];
            vc.horizontalScrollEnabled = NO;
            [self.navigationController pushViewController: vc animated: YES];
        }
            break;
            
        case 3: {
            UIViewController *vc = [[TabbedTableViewControllerDemo4 alloc] init];
            [self.navigationController pushViewController: vc animated: YES];
        }
            break;
            
        case 4: {
            UIViewController *vc = [[TabbedTableViewControllerDemo5 alloc] init];
            [self.navigationController pushViewController: vc animated: YES];
        }
            break;
            
        default:
            break;
    }
}
@end
