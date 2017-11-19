//
//  WXTabTitleViewProtocol.h
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WXTabTitleClickBlock)(NSUInteger newIndex, NSUInteger oldIndex);

@protocol WXTabTitleViewProtocol <NSObject>

/**
 the tab titles array.
 */
@property (copy, nonatomic) NSArray<NSString*> *tabTitles;

/**
 when one title is touched, this block is called to notify WXTabView
 */
@property (copy, nonatomic) WXTabTitleClickBlock titleClickBlock;

/**
 save the currently selected item.
 */
@property (nonatomic) NSUInteger selectedItem;

/**
 Set a new title for specified index
 */
- (void)setTitle: (NSString*)title forIndex: (NSUInteger)index;

@end
