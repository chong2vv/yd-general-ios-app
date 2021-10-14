//
//  UpApiHelper.h
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/14.
//

#import <Foundation/Foundation.h>
#import "UpUploadModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UpApiHelper : NSObject

+ (UpUploadModel *)getUpUploadModel:(NSData *)fileData fileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
