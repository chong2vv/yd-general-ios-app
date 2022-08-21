//
//  YDImagePickerService.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/21.
//

#import "YDImagePickerService.h"
#import <YDBlockKit/UIImagePickerController+BlocksKit.h>
#import <CoreServices/CoreServices.h>
#import "YDImagePickerViewController.h"
#import "AppDelegate+YDSetupVC.h"

#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface YDImagePickerService ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate>

@end

@implementation YDImagePickerService

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static id shared = nil;
    dispatch_once(&onceToken, ^{
         shared = [[self alloc] init];
    });
    return shared;
}


+ (void)pickPhotoViaAlbum:(void (^)(UIImage * image))callback onVC:(UIViewController *)onVC{
    //检查相册权限是否可用
    [YDAuthorizationUtil authorizedForTakePhotoAndSaveWithCompletion:^(BOOL authorized) {
        if (!authorized) {
            [YDProgressHUD showErrorWithStatus:@"未开启相机权限"];
            return;
        }
    }];
    
    YDImagePickerViewController *imagePickerVc = [[YDImagePickerViewController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:[YDImagePickerService shared] pushPhotoPickerVc:YES];
    __weak typeof (YDImagePickerViewController)* weakImagePicker = imagePickerVc;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSLog(@"选择了图片");
        UIImage *image = [photos firstObject];
        if (callback) {
            callback(image);
        }
        [weakImagePicker dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [imagePickerVc setImagePickerControllerDidCancelHandle:^{
        [weakImagePicker dismissViewControllerAnimated:YES completion:nil];
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [onVC presentViewController:imagePickerVc animated:YES completion:nil];
}

+ (void)pickPhotoArrayViaAlbum:(void (^)(NSArray<UIImage *> * imageArray))callback onVC:(UIViewController *)onVC {
    //检查相册权限是否可用
    [YDAuthorizationUtil authorizedForTakePhotoAndSaveWithCompletion:^(BOOL authorized) {
        if (!authorized) {
            [YDProgressHUD showErrorWithStatus:@"未开启相机权限"];
            return;
        }
    }];
    
    YDImagePickerViewController *imagePickerVc = [[YDImagePickerViewController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:[YDImagePickerService shared] pushPhotoPickerVc:YES];
    __weak typeof (YDImagePickerViewController)* weakImagePicker = imagePickerVc;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSLog(@"选择了图片");
        if (callback) {
            callback(photos);
        }
        [weakImagePicker dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [imagePickerVc setImagePickerControllerDidCancelHandle:^{
        [weakImagePicker dismissViewControllerAnimated:YES completion:nil];
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [onVC presentViewController:imagePickerVc animated:YES completion:nil];
}

+ (void)pickPhotoViaCamera:(void (^)(UIImage * image))callback onVC:(UIViewController *)onVC{
    //检测相机权限是否可用
    [YDAuthorizationUtil authorizedForCameraWithCompletion:^(BOOL authorized) {
        if (!authorized) {
            [YDProgressHUD showErrorWithStatus:@"未开启相机权限"];
            return;
        }
    }];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = [YDImagePickerService shared];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    __weak typeof (UIImagePickerController)* weakImagePicker = imagePicker;
    [imagePicker setBk_didFinishPickingMediaBlock:^(UIImagePickerController *picker, NSDictionary *info) {
        UIImage * image = info[UIImagePickerControllerOriginalImage];
        // 图片旋转为正向
        
        if (callback) {
            callback(image);
        }
        [weakImagePicker dismissViewControllerAnimated:YES completion:nil];
    }];
    [imagePicker setBk_didCancelBlock:^(UIImagePickerController *picker) {
        [weakImagePicker dismissViewControllerAnimated:YES completion:nil];
    }];
    imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [onVC presentViewController:imagePicker animated:YES completion:nil];

}

+ (void)previewAsset:(PHAsset *)asset onVC:(UIViewController *)onVC {
    
    BOOL isVideo = NO;
    isVideo = asset.mediaType == PHAssetMediaTypeVideo;
    if ([[asset valueForKey:@"filename"] containsString:@"GIF"]) {
        TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
        TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
        vc.model = model;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [onVC presentViewController:vc animated:YES completion:nil];
    } else if (isVideo) { // perview video / 预览视频
        TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
        TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
        vc.model = model;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [onVC presentViewController:vc animated:YES completion:nil];
    } else { // preview photos / 预览照片
        TZPhotoPreviewController *imagePickerVc = [[TZPhotoPreviewController alloc] init];
        TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
        imagePickerVc.models = [NSMutableArray arrayWithArray:@[model]];
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [onVC presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

+ (void)getVideoOutputPathWithAsset:(PHAsset *)asset presetName:(NSString *)presetName success:(void (^)(NSString *outputPath))success failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPresetLowQuality success:^(NSString *outputPath) {
        // NSData *data = [NSData dataWithContentsOfFile:outputPath];
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        if (success) {
            success(outputPath);
        }
    } failure:^(NSString *errorMessage, NSError *error) {
        if (failure) {
            failure(errorMessage, error);
        }
    }];
}
@end
