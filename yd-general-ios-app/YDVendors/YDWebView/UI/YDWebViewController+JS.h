//
//  YDWebViewController+JS.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/18.
//

#import "YDWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDWebViewController (JS)

//注册事件供H5调用
- (void)registerHandler;

//调用H5注册的事件
- (void)callHandlerShareInfoComplete:(void(^)(NSDictionary *aDic))aComplete;
@end

NS_ASSUME_NONNULL_END
