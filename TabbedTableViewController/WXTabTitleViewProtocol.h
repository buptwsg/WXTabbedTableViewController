//
//  WXTabTitleViewProtocol.h
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WXTabTitleClickBlock)(NSUInteger index);

@protocol WXTabTitleViewProtocol <NSObject>

@property (copy, nonatomic) NSArray<NSString*> *tabTitles;
@property (copy, nonatomic) WXTabTitleClickBlock titleClickBlock;

- (void)setSelectedItem: (NSUInteger)item;

@end
