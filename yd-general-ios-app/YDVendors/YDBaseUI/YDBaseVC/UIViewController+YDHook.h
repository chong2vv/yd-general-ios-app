//
//  UIViewController+YDHook.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (YDHook)

//是否允许
@property(nonatomic,assign) BOOL closeInteractivePopGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
