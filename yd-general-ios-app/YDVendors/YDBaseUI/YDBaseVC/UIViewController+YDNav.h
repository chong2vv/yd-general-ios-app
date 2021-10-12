//
//  UIViewController+YDNav.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (YDNav)

// 设置下一个返回显示的title 为特殊情况单独处理
@property (nonatomic, copy) NSString *nextBackTitle;

- (void)uploadTitleType;

- (void)back;

- (void)backAnimated:(BOOL)animated;

// 获取最近的导航控制器
- (UINavigationController *)getRecentlyNavigationController;

#pragma mark - NavigationBar 显示隐藏控制 只对 YD 前缀的控制器有效
@property (nonatomic, assign) BOOL isHiddenNavigationBar;

- (BOOL)hiddenNavigation;

//获取title 颜色
- (UIColor *)titleColor;
- (UIFont *)titleFont;

+ (UIViewController *)currentViewController;

@end

NS_ASSUME_NONNULL_END
