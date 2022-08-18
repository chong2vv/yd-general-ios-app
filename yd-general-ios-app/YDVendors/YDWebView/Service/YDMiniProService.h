//
//  YDMiniProService.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const kMiniProName;//小程序原始id
UIKIT_EXTERN NSString *const kMiniProPath;//小程序内部的路劲
UIKIT_EXTERN NSString *const kMiniProId;//小程序id
UIKIT_EXTERN NSString *const kMiniProType;//小程序类型 体验版,正式版

//小程序服务
@interface YDMiniProService : NSObject

/// 推荐方法
/// @param url 小程序url
/// @param delay 延迟执行xx秒
+ (void)launchMiniProWithUrl:(NSString *)url delay:(CGFloat)delay;

/// 解析url返回唤醒小程序参数
/// @param url 小程序url
+ (NSDictionary *)paramsMiniProUrl:(NSString *)url;

/// 唤醒小程序
/// @param params 需要的参数
- (void)launchMiniProWithParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
