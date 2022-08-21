//
//  YDWebViewController+JS.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/18.
//

#import "YDWebViewController+JS.h"
#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@implementation YDWebViewController (JS)

- (void)registerHandler
{
    WEAKSELF(weakSelf);
    
//    //显示分享
//    [self.bridge registerHandler:@"showShare" handler:^(NSDictionary *aData, WVJBResponseCallback responseCallback) {
//        NSDictionary* params = [aData objectForKey:@"params"];
//        [weakSelf showShareAction:params];
//    }];
//    
    // 注册获取图片
    [self.bridge registerHandler:@"getImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf getImageFromPicture];
    }];
//    
//    [self.bridge registerHandler:@"showFullScreenPicture" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
//        [weakSelf showWebBigImage:data[@"params"]];
//    }];
//    
//    //关闭webview
//    [self.bridge registerHandler:@"closeWebview" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [weakSelf closeAction];
//    }];
//    // h5调用原生播放视频
//    [self.bridge registerHandler:@"playVideoWithNative" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [weakSelf playVideoWithNative: data[@"params"]];
//    }];
//    
//    // 跳转到首页
//    [self.bridge registerHandler:@"jumpNewHome" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [weakSelf openjumpNewHome:data[@"params"]];
//    }];
//    
//    //重置返回按钮，直接关闭webview
//    [self.bridge registerHandler:@"resetBackActionToCloseWebView" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
//        weakSelf.isClose = YES;
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
//    if (![ArtUtil checkUseCamera]) return;
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.delegate = self;
//    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
//    __weak __typeof__(self) weakSelf = self;
//    [imagePicker setBk_didFinishPickingMediaBlock:^(UIImagePickerController *picker, NSDictionary *info) {
//        UIImage * image = info[UIImagePickerControllerOriginalImage];
//        // 图片旋转为正向
//        image = [image imageWithCorrectOrientation];
//        if (callback) {
//            callback(image);
//        }
//        [weakSelf dismissViewControllerAnimated:YES completion:nil];
//    }];
//    [imagePicker setBk_didCancelBlock:^(UIImagePickerController *picker) {
//        [weakSelf dismissViewControllerAnimated:YES completion:nil];
//    }];
//    imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:imagePicker animated:YES completion:nil];
}


//MARK - 相册选择
- (void)pickPhotoViaAlbum:(void(^)(UIImage* image))callback
{
    [YDAuthorizationUtil authorizedForTakePhotoAndSaveWithCompletion:^(BOOL authorized) {
        if (!authorized) {
            return;
        }
    }];
    __weak __typeof__(self) weakSelf = self;
//    [ArtPhotoPickerService requestAuthorization:^() {
//        ArtPhotoPickerViewController *vc = [[ArtPhotoPickerViewController alloc] init];
//        vc.maximumNumberOfSelection = 1;
//        vc.showType = EArtPickerShowTypeDefault;
//        vc.modalPresentationStyle = UIModalPresentationFullScreen;
//        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        vc.pickerDelegate = self;
//        [weakSelf presentViewController:vc animated:YES completion:nil];
//        [[[weakSelf rac_signalForSelector:@selector(photoPicker:didSelectedPhotos:origin:) fromProtocol:@protocol(ArtPhotoPickerViewControllerDelegate)] takeUntil:[vc rac_willDeallocSignal]]subscribeNext:^(RACTuple *x) {
//            NSLog(@"选择了图片");
//            NSArray<PHAsset *> *photos = x.second;
//            PHAsset * asset = photos.firstObject;
//
//            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//            // 同步获得图片, 只会返回1张图片
//            options.synchronous = YES;
//            options.resizeMode = PHImageRequestOptionsResizeModeFast;
//            options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
//
//            [PHImageManager.defaultManager requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//
//                UIImage *image = [UIImage imageWithData:imageData];
//                if (callback) {
//                    callback(image);
//                }
//            }];
//
//            [weakSelf dismissViewControllerAnimated:YES completion:nil];
//        }];
//        [[[weakSelf rac_signalForSelector:@selector(photoPickerDidCancel:) fromProtocol:@protocol(ArtPhotoPickerViewControllerDelegate)] takeUntil:[vc rac_willDeallocSignal]]subscribeNext:^(RACTuple *x) {
//            NSLog(@"photoPickerDidCancel:");
//            [weakSelf dismissViewControllerAnimated:YES completion:nil];
//        }];
//        //?
//        [[[weakSelf rac_signalForSelector:@selector(photoPickerListClick:) fromProtocol:@protocol(ArtPhotoPickerViewControllerDelegate)] takeUntil:[vc rac_willDeallocSignal]]subscribeNext:^(RACTuple *x) {
//            NSLog(@"photoPickerListClick");
//            [weakSelf dismissViewControllerAnimated:YES completion:nil];
//        }];
//    }];
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


- (void)showShareAction:(NSDictionary *)aParams {
    BOOL isShow = [aParams[@"is_show"] boolValue];
}


@end
