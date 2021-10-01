//
//  YDCameraPermissionUtil.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDCameraPermissionUtil : NSObject

+ (BOOL)isPhotoLibraryDenied;
+ (BOOL)isPhotoLibraryNotDetermined;
+ (void)requestPhotoPermission:(YDSuccessBOOL)result;

+ (BOOL)microNotDetermined;
+ (BOOL)microDenied;
+ (void)requestAccessForMicro:(YDSuccessBOOL)result;

@end

NS_ASSUME_NONNULL_END
