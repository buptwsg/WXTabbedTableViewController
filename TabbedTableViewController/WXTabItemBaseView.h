//
//  WXTabItemBaseView.h
//  TabbedTableViewController
//
//  Created by Shuguang Wang on 2017/9/19.
//  Copyright © 2017年 Shuguang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXTabbedTableViewControllerConstant.h"

NS_ASSUME_NONNULL_BEGIN

/**
 This is the base class from which you should subclass your tab item view. By default, it creates a table view to display data, but you can alternatively uses a
 collection view.
 */
@interface WXTabItemBaseView : UIView <UITableViewDataSource, UITableViewDelegate>

/**
 The scroll view that the tab item view manages. By default, it is an instance of UITableView. Subclass can create an instance of UICollectionView, and assign it to this property.
 */
@property (strong, nonatomic, nonnull) UIScrollView *scrollView;

/**
 @brief the initializer method
 @param index the index of the tab item view
 @param viewSize the width and height of the tab item view.
 */
- (nonnull instancetype)initWithIndex: (NSUInteger)index size: (CGSize)viewSize;

/**
 @brief subclass can override this method to handle view appear.
 @param reason the reason of view appear.
 */
- (void)viewWillAppear: (WXTabItemViewAppearReason)reason;

/**
 @brief subclass can override this method to handle view disappear.
 @param reason the reason of view disappear
 */
- (void)viewWillDisappear: (WXTabItemViewDisappearReason)reason;

@end

NS_ASSUME_NONNULL_END
