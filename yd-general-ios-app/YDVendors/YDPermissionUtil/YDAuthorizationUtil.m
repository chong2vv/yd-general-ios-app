//
//  YDCameraPermissionUtil.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import "YDAuthorizationUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#define kAuthorizationAppName ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"])

@interface YDAuthorizationUtil ()
@property (nonatomic, copy) void (^permissionCompletion)(BOOL granted);
@end

@implementation YDAuthorizationUtil

+ (BOOL)authorizedWithType:(EYDAuthorization)authorizationType
{
    BOOL authorized = NO;
    switch (authorizationType) {
        case EYDAuthorizationPhoto:
            authorized = [self photoAuthorized];
            break;
        case EYDAuthorizationCamera:
            authorized = [self cameraAuthorized];
            break;
        case EYDAuthorizationMicrophone:
            authorized =  [self microphoneAuthorized];
            break;
        default:
            authorized = NO;
            break;
    }
    return authorized;
}

+ (EYDAuthorizationStatus)authorizedStatusWithType:(EYDAuthorization)authorizationType
{
    EYDAuthorizationStatus status = EYDAuthorizationStatusNotDetermined;
    switch (authorizationType) {
        case EYDAuthorizationPhoto:
            status = [self photoAuthorizationStatus];
            break;
        case EYDAuthorizationCamera:
            status = [self cameraAuthorizationStatus];
            break;
        case EYDAuthorizationMicrophone:
            status =  [self microphoneAuthorizationStatus];
            break;
        default:
            break;
    }
    return status;
}

+ (void)authorizeWithType:(EYDAuthorization)authorizationType completion:(void(^)(BOOL authorized))completion
{
    switch (authorizationType) {
        case EYDAuthorizationPhoto:
            [self photoAuthorizeWithCompletion:completion];
            break;
        case EYDAuthorizationCamera:
            [self cameraAuthorizedWithCompletion:completion];
            break;
        case EYDAuthorizationMicrophone:
            [self microphoneAuthorizedWithCompletion:completion];
            break;
        default:
            break;
    }
}

+ (UIViewController *)getRootViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (rootViewController.presentedViewController) {
//        if ([rootViewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
//            return rootViewController;
//        }
        rootViewController = rootViewController.presentedViewController;
    }
    return rootViewController;
}

//MARK: Photo
+ (BOOL)photoAuthorized
{
    return [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized;
}

+ (EYDAuthorizationStatus)photoAuthorizationStatus
{
    return (EYDAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
}

+ (void)photoAuthorizeWithCompletion:(void(^)(BOOL authorized))completion
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status) {
        case PHAuthorizationStatusAuthorized:
        {
            if (completion) {
                completion(YES);
            }
        }
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            if (completion) {
                completion(NO);
            }
        }
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(status == PHAuthorizationStatusAuthorized);
                    });
                }
            }];
        }
            break;
        default:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(NO);
                }
            });
        }
            break;
    }
}
//MARK: Microphone
+ (BOOL)microphoneAuthorized
{
    return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio] == AVAuthorizationStatusAuthorized;
}

+ (EYDAuthorizationStatus)microphoneAuthorizationStatus
{
    return (EYDAuthorizationStatus)[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
}

+ (void)microphoneAuthorizedWithCompletion:(void(^)(BOOL authorized))completion
{
    [self authorizedForMediaType:AVMediaTypeAudio completion:completion];
}

//MARK: Camera
+ (BOOL)cameraAuthorized
{
    return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized;
}

+ (EYDAuthorizationStatus)cameraAuthorizationStatus
{
    return (EYDAuthorizationStatus)[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
}

+ (void)cameraAuthorizedWithCompletion:(void(^)(BOOL authorized))completion
{
    [self authorizedForMediaType:AVMediaTypeVideo completion:completion];
}

+ (void)authorizedForMediaType:(AVMediaType)type completion:(void(^)(BOOL authorized))completion
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:type];
    switch (status) {
        case AVAuthorizationStatusAuthorized:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(YES);
                }
            });
        }
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(NO);
                }
            });
        }
            break;
        case AVAuthorizationStatusNotDetermined:
        {
            //点击弹框授权
            [AVCaptureDevice requestAccessForMediaType:type completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(granted);
                    }
                });
            }];
        }
            break;
        default:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(NO);
                }
            });
        }
            break;
    }
}


//MARK: 艺信 未授权有提示
+ (void)authorizedForRecordVideoWithCompletion:(void(^)(BOOL authorized))completion
{
    __weak typeof(self) weakSelf = self;
    [self authorizeWithType:EYDAuthorizationCamera completion:^(BOOL authorized) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!authorized) {
            NSString *des = [NSString stringWithFormat:@"请在设备的\"设置-隐私-相机\"选项中允许%@访问你的相机",kAuthorizationAppName];
            [strongSelf alertActionTitle:@"无法打开相机" message:des completion:completion];
            return;
        }
        
        [strongSelf authorizeWithType:EYDAuthorizationMicrophone completion:^(BOOL authorized) {
            if (!authorized) {
                NSString *des = [NSString stringWithFormat:@"请在设备的\"设置-隐私-麦克风\"选项中允许%@访问你的麦克风",kAuthorizationAppName];
                [strongSelf alertActionTitle:@"无法打开麦克风" message:des completion:completion];
                return;
            }
            if(completion){
                completion(YES);
            }
//            [strongSelf authorizeWithType:EYDAuthorizationPhoto completion:^(BOOL authorized) {
//                if (!authorized) {
//                    NSString *des = [NSString stringWithFormat:@"请在设备的\"设置-隐私-相册\"选项中允许%@访问你的相册",kAuthorizationAppName];
//                    [strongSelf alertActionTitle:@"无法打开相册" message:des completion:completion];
//                    return;
//                }
//            }];
        }];
    }];
}

+ (void)authorizedForTakePhotoAndSaveWithCompletion:(void(^)(BOOL authorized))completion
{
    __weak typeof(self) weakSelf = self;
    [self authorizeWithType:EYDAuthorizationCamera completion:^(BOOL authorized) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!authorized) {
            NSString *des = [NSString stringWithFormat:@"请在设备的\"设置-隐私-相机\"选项中允许%@访问你的相机",kAuthorizationAppName];
            [strongSelf alertActionTitle:@"无法打开相机" message:des completion:completion];
            return;
        }
        [strongSelf authorizeWithType:EYDAuthorizationPhoto completion:^(BOOL authorized) {
            if (!authorized) {
                NSString *des = [NSString stringWithFormat:@"请在设备的\"设置-隐私-相册\"选项中允许%@访问你的相册",kAuthorizationAppName];
                [strongSelf alertActionTitle:@"无法打开相册" message:des completion:completion];
                return;
            }
            if(completion){
                completion(YES);
            }
        }];
    }];
}

+ (void)authorizedForRecordWithCompletion:(void(^)(BOOL authorized))completion {
    __weak typeof(self) weakSelf = self;
    [weakSelf authorizeWithType:EYDAuthorizationMicrophone completion:^(BOOL authorized) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!authorized) {
            NSString *des = [NSString stringWithFormat:@"请在设备的\"设置-隐私-麦克风\"选项中允许%@访问你的麦克风",kAuthorizationAppName];
            [strongSelf alertActionTitle:@"无法打开麦克风" message:des completion:completion];
            return;
        }
        if(completion){
            completion(YES);
        }
    }];
}

+ (void)authorizedForCameraWithCompletion:(void(^)(BOOL authorized))completion
{
    [self authorizedForCameraWithCompletion:completion needAlert:YES];
}
+ (void)authorizedForCameraWithCompletion:(void(^)(BOOL authorized))completion needAlert:(BOOL)needAlert
{
    __weak typeof(self) weakSelf = self;
    [self authorizeWithType:EYDAuthorizationCamera completion:^(BOOL authorized) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!authorized) {
            if (needAlert) {
                NSString *des = [NSString stringWithFormat:@"请在设备的\"设置-隐私-相机\"选项中允许%@访问你的相机",kAuthorizationAppName];
                [strongSelf alertActionTitle:@"无法打开相机" message:des completion:completion];
            }
            return;
        }
        if(completion){
            completion(YES);
        }
    }];
}

+ (void)authorizedForPhotoWithCompletion:(void(^)(BOOL authorized))completion
{
    __weak typeof(self) weakSelf = self;
    [self authorizeWithType:EYDAuthorizationPhoto completion:^(BOOL authorized) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!authorized) {
            NSString *des = [NSString stringWithFormat:@"请在设备的\"设置-隐私-相册\"选项中允许%@访问你的相册",kAuthorizationAppName];
            [strongSelf alertActionTitle:@"无法打开相册" message:des completion:completion];
            return;
        }
        if(completion){
            completion(YES);
        }
    }];
}


+ (void)alertActionTitle:(NSString *)title message:(NSString *)message completion:(void(^)(BOOL authorized))completion {
//    [YDAlertController showAlertWithTitle:title message:message cancelButtonTitle:@"去设置" otherButtonTitles:[YDSharedConfig shared].startConfig.ischeck ? @[@"取消"] : nil didSelectBlock:^(YDAlertAction *action, NSUInteger index) {
//        if (completion) {
//            completion(NO);
//        }
//    } didCancelBlock:^{
//        [self gotoSetting];
//        if (completion) {
//            completion(NO);
//        }
//    }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(completion){
            completion(NO);
        }
    }];
    [alertController addAction:enterAction];

    UIAlertAction *szAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoSetting];
        if (completion) {
            completion(NO);
        }
    }];
    [alertController addAction:szAction];

    [[self getRootViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (void)gotoSetting {
    //跳转到定位权限页面
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if( [[UIApplication sharedApplication] canOpenURL:url] ) {
        [[UIApplication sharedApplication] openURL:url];
    }
}


@end
