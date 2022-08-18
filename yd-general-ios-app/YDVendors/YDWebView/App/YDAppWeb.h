//
//  YDAppWeb.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/18.
//

#import "YDApp.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDAppWeb : YDApp

/*
 #import "YDMediator+YDWeb.h"
 #import "YDWebConfig.h"
 [[YDMediator shared] startLinkerParams:@{kLinkUrl:url, kWebTitle:title} navigationController:nav];
 */

- (UIViewController *)startWebAppWithParams:(NSDictionary *)aParams;

@end

NS_ASSUME_NONNULL_END
