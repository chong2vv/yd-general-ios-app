//
//  YDWebViewController+JS.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/18.
//

#import "YDWebViewController+JS.h"
#import <YDBlockKit/UIImagePickerController+BlocksKit.h>
#import <CoreServices/CoreServices.h>
#import "YDImagePickerViewController.h"

#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface UIImage (YDOritation)

// 旋转图片
- (UIImage *)imageWithCorrectOrientation;

@end

@implementation UIImage (YDOritation)

// 旋转图片
- (UIImage *)imageWithCorrectOrientation {
      
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
      
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
              
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
              
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
      
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
              
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
      
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
              
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
      
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

@interface YDWebViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate>

@end

@implementation YDWebViewController (JS)

- (void)registerHandler
{
    WEAKSELF(weakSelf);
    
    //显示分享
    [self.bridge registerHandler:@"showShare" handler:^(NSDictionary *aData, WVJBResponseCallback responseCallback) {
        NSDictionary* params = [aData objectForKey:@"params"];
        [weakSelf showShareAction:params];
    }];
    
    // 注册获取图片
    [self.bridge registerHandler:@"getImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf getImageFromPicture];
    }];
    
    [self.bridge registerHandler:@"showFullScreenPicture" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        [weakSelf showWebBigImage:data[@"params"]];
    }];
    
    //关闭webview
    [self.bridge registerHandler:@"closeWebview" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf closeAction];
    }];
    
    // h5调用原生播放视频
    [self.bridge registerHandler:@"playVideoWithNative" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf playVideoWithNative: data[@"params"]];
    }];
    
    // 跳转到首页
    [self.bridge registerHandler:@"jumpNewHome" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf openjumpNewHome:data[@"params"]];
    }];
    
    //重置返回按钮，直接关闭webview
    [self.bridge registerHandler:@"resetBackActionToCloseWebView" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        weakSelf.isClose = YES;
    }];
}

- (void)showShareAction:(NSDictionary *)aParams
{
    BOOL isShow = [aParams[@"is_show"] boolValue];
    
}

-(void)showWebBigImage:(NSDictionary *)dic {
    NSNumber *currentIndex = dic[@"img"];
    NSArray *imageUrls = dic[@"imgList"];
    
}

// h5调用原生播放视频
- (void)playVideoWithNative: (NSDictionary *)aParams {
    
}

- (void)openjumpNewHome:(NSDictionary*)aParams {
    [self p_backToRootAndSelectedIndex:0];
}

- (void)p_backToRootAndSelectedIndex:(NSInteger)index {
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [app backToRootViewControllerCompletion:^{
//        [app.rootTabBarController setSelectedIndex:index];
//    }];
}

// 获取图片
- (void)getImageFromPicture {
    @weakify(self)
    YDActionSheetViewController * vc = [YDActionSheetViewController new];
    [vc addButtonWithTitle:@"相册" style:YDSheetButtonStyleDefault handler:^(UIButton * _Nonnull button) {
        [self pickPhotoViaAlbum:^(UIImage *image) {
            @strongify(self)
            [self callHandlerSendImage:image];
        }];

    }];
    [vc addButtonWithTitle:@"拍照" style:YDSheetButtonStyleDefault handler:^(UIButton * _Nonnull button) {

        [self takePhotoViaCamera:^(UIImage *image) {
            @strongify(self);
            [self callHandlerSendImage:image];
        }];
    }];

    [vc addCancelButtonWithTitle:@"取消" handler:^(UIButton * _Nonnull button) {
        NSLog(@"点击取消");
    }];
    [self presentViewController:vc animated:NO completion:nil];
}

//MARK - 拍照
- (void)takePhotoViaCamera:(void(^)(UIImage* image))callback
{
    //检测相机权限是否可用
    [YDAuthorizationUtil authorizedForCameraWithCompletion:^(BOOL authorized) {
        if (!authorized) {
            return;
        }
    }];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    __weak __typeof__(self) weakSelf = self;
    [imagePicker setBk_didFinishPickingMediaBlock:^(UIImagePickerController *picker, NSDictionary *info) {
        UIImage * image = info[UIImagePickerControllerOriginalImage];
        // 图片旋转为正向
        image = [image imageWithCorrectOrientation];
        if (callback) {
            callback(image);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [imagePicker setBk_didCancelBlock:^(UIImagePickerController *picker) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//MARK: callHandler, UIImagePickerControllerDelegate
- (void)callHandlerShareInfoComplete:(void(^)(NSDictionary *aDic))aComplete
{
    NSDictionary *userInfo = @{
        @"userId":[YDUserConfig shared].currentUserId,@"result":@"1"
    };
    [self.bridge callHandler:@"shareInfo" data:userInfo responseCallback:^(NSDictionary *responseData) {
        //        NSLog(@"WK:%@",responseData);
        yd_dispatch_async_main_safe(^{
            if (aComplete) {
                aComplete(responseData);
            }
        });
    }];
}


//MARK - 相册选择
- (void)pickPhotoViaAlbum:(void(^)(UIImage* image))callback
{
    //检查相册权限是否可用
    [YDAuthorizationUtil authorizedForTakePhotoAndSaveWithCompletion:^(BOOL authorized) {
        if (!authorized) {
            return;
        }
    }];
    __weak __typeof__(self) weakSelf = self;
    
    YDImagePickerViewController *imagePickerVc = [[YDImagePickerViewController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSLog(@"选择了图片");
        UIImage *image = [photos firstObject];
        if (callback) {
            callback(image);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [imagePickerVc setImagePickerControllerDidCancelHandle:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];

}

// 发送图片base64给H5
- (void)callHandlerSendImage:(UIImage *)image {
    if (!image) {
        return;
    }
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [self.bridge callHandler:@"sendImage" data:encodedImageStr responseCallback:^(NSDictionary *responseData) {
        NSLog(@"WK:%@",responseData);
    }];
}


@end

