//
//  YDLoginService.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDLoginService : NSObject

+(BOOL)checkAndLoginWithTypeComplete:(void (^)(BOOL isLogin))completion;

@end

NS_ASSUME_NONNULL_END
