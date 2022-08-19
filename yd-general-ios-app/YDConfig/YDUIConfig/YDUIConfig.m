//
//  YDUIConfig.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/19.
//

#import "YDUIConfig.h"
#import <YDSVProgressHUD/YDProgressHUD.h>

@implementation YDUIConfig

@end

@implementation YDProgressHUDConfig (YDUIConfig)

+ (UIImage *)infoImage {
    return nil;
}

+ (UIImage *)successImage {
    return nil;
}

+ (UIImage *)errorImage {
    return nil;
}
// 自定义文字颜色
+ (UIColor *)foregroundColor {
    
    return [UIColor whiteColor];
}
+ (UIColor *)hudBackgroundColor {
    return [UIColor blackColor];
//    return [UIColor colorWithWhite:0 alpha:1];
}

+ (UIColor *)hudLoadingBackgroundColor {
    return [UIColor clearColor];
}

+ (UIImage *)lottieLoadingBGImage {
    return nil;
}

+ (NSString *)lottieLoadingPath {
    return [[NSBundle mainBundle] pathForResource:@"yd_loading_black" ofType:@"json"];
}

+ (BOOL)addBlurEffect
{
    return NO;
}


+ (YDProgressHUDLoadingType)loadingImageType
{
    return YDProgressHUDLoadingTypeLottie;
}

+ (CGSize)hudBackgroundSize
{
    return CGSizeMake(246/3*2, 72/3*2);
}

@end
