//
//  YDCameraPermissionUtil.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, EYDAuthorization) {
    EYDAuthorizationPhoto,
    EYDAuthorizationCamera,
    EYDAuthorizationMicrophone
};

typedef NS_ENUM(NSUInteger, EYDAuthorizationStatus) {
    EYDAuthorizationStatusNotDetermined,//尚未决定
    EYDAuthorizationStatusRestricted,//限制
    EYDAuthorizationStatusDenied,//拒绝
    EYDAuthorizationStatusAuthorized,//已授权 定位时:使用AuthorizedAlways 或 AuthorizedWhenInUse
    EYDAuthorizationStatusAuthorizedAlways,//定位使用 总是授权
    EYDAuthorizationStatusAuthorizedWhenInUse,//定位使用 使用时授权
};

@interface YDAuthorizationUtil : NSObject


+ (EYDAuthorizationStatus)authorizedStatusWithType:(EYDAuthorization)authorizationType;

+ (BOOL)authorizedWithType:(EYDAuthorization)authorizationType;

+ (void)authorizeWithType:(EYDAuthorization)type completion:(void(^)(BOOL authorized))completion;

////拍照并存储相册 需要请求相机、相册两个权限
+ (void)authorizedForTakePhotoAndSaveWithCompletion:(void(^)(BOOL authorized))completion;

//录制视频 需要相机、相册、麦克风三个权限 其中只要有一个权限无法获取，都会导致录制出错
+ (void)authorizedForRecordVideoWithCompletion:(void(^)(BOOL authorized))completion;

//语音
+ (void)authorizedForRecordWithCompletion:(void(^)(BOOL authorized))completion;

//相册
+ (void)authorizedForPhotoWithCompletion:(void(^)(BOOL authorized))completion;

//相机
+ (void)authorizedForCameraWithCompletion:(void(^)(BOOL authorized))completion;

//相机，是否弹窗
+ (void)authorizedForCameraWithCompletion:(void(^)(BOOL authorized))completion needAlert:(BOOL)needAlert;

//去授权
+ (void)gotoSetting;


@end

NS_ASSUME_NONNULL_END
