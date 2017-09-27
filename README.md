# About WXTabbedTableViewController
WXTabbedTableViewController is a handy view controller class, it manages a table view which can have one or more table views or collection views as pages. 
These pages can be switched by horizontal scrolling or clicking their title.

See below gif for what this view controller can do.

![](https://github.com/buptwsg/WXTabbedTableViewController/blob/master/Demo.gif)

# Usage
To use this view controller, all you have to do is:
* Subclass your view controller from WXTabbedTableViewController
* Subclass your tab item view from WXTabItemBaseView
* override `- (NSArray<NSString *> *)tabTitles` to set tab title strings
* override `- (WXTabItemBaseView*)itemViewAtIndex: (NSUInteger)index size: (CGSize)viewSize` to create instance of your own tab item view

The framework provides a default tab title view, and you can customize its appearance through the properties of WXTabTitleView. If you want to
use your own title view, then you must:
* Subclass your title view from UIView and conforms to protocol `WXTabTitleViewProtocol`
* In your subclass of WXTabbedTableViewController, override `- (UIView<WXTabTitleViewProtocol> *)tabTitleView` to create instance of your own tab title view

For example usage, see demos.

# Prerequisites
* iOS 7.0 or higher
* Xcode 9 or higher

# Installation
To install using [CocoaPods](https://github.com/cocoapods/cocoapods), add the following to your project Podfile:
```
pod 'TabbedTableViewController'
```

To install using [Carthage](https://github.com/carthage/carthage), add the following to your project Cartfile:
```
github "buptwsg/WXTabbedTableViewController"
```

To install manually, drag and drop folder TabbedTableViewController into your Xcode project, agreeing to copy files if needed. 

Having installed using CocoaPods or Carthage, add the following to import in Objective-C:
```objective-c
#import <WXTabbedTableViewController/WXTabbedTableViewController.h>
```

## License
WXTabbedTableViewController is released under a MIT License. See LICENSE file for details.
