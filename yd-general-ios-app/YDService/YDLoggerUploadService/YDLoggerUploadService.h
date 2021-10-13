//
//  YDLoggerUploadService.h
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDLoggerUploadService : NSObject

+ (instancetype)shared;

- (void)uploadLoggerZIP:(BOOL) upload;
@end

NS_ASSUME_NONNULL_END
