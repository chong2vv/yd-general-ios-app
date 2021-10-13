//
//  YDImageUploadService.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDImageUploadService : NSObject

+ (instancetype)shared;

- (void)uploadImage:(UIImage *)image progress:(void (^)(NSProgress *))progress success:(YDSuccessHandler)success
            failure:(YDFailureHandler)failure;

@end

NS_ASSUME_NONNULL_END
