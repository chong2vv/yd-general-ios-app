//
//  UINavigationController+YDHookStatusBar.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (YDHookStatusBar)

@property (nonatomic, assign) BOOL forbidHookHandler;//禁止hook后的处理,禁止后直接调用原方法

@end

NS_ASSUME_NONNULL_END
