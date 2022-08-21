//
//  YDImagePickerService.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/21.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDImagePickerService : NSObject

//从相册获取单张图片
+ (void)pickPhotoViaAlbum:(void(^)(UIImage* image))callback onVC:(UIViewController *)onVC;

//从相册获取多张图片
+ (void)pickPhotoArrayViaAlbum:(void(^)(NSArray <UIImage *>* imageArray))callback onVC:(UIViewController *)onVC;

//相机拍照
+ (void)pickPhotoViaCamera:(void(^)(UIImage* image))callback onVC:(UIViewController *)onVC;

//预览
+ (void)previewAsset:(PHAsset *)asset onVC:(UIViewController *)onVC;

//到处资源
+ (void)getVideoOutputPathWithAsset:(PHAsset *)asset presetName:(NSString *)presetName success:(void (^)(NSString *outputPath))success failure:(void (^)(NSString *errorMessage, NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
