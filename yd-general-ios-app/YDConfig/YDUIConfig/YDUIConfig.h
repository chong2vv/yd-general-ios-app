//
//  YDUIConfig.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/19.
//

#import <Foundation/Foundation.h>
#import <YDSVProgressHUD/YDProgressHUD.h>
#import <YDImageService/YDImageService.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDUIConfig : NSObject

+ (void)YDUIConfig;

@end

//YDProgressHUD 配置
@interface YDProgressHUDConfig (YDUIConfig)

@end

//YDImageService 配置
@interface YDWebImageConfig : NSObject<YDImageConfigProtocol>

@end

NS_ASSUME_NONNULL_END
