//
//  YDEmptyViewConfig.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/23.
//

#import "YDEmptyViewConfig.h"

@implementation YDEmptyViewConfig

+ (NSDictionary<NSString *,UIImage *> *)emptyImage {
    NSDictionary *dic = @{
        EmptyNoDataImage: @"",
        EmptyNetworkExceptionImage: @"",
        EmptyRequestExceptionImage: @""
    };
    return dic;
}

+ (UIImage *)defaultEmptyImage {
    return [UIImage new];
}

+ (NSDictionary<NSString *, UIImage *> *)buttonBackgroundImage {
    NSDictionary *dic = @{
        EmptyButtonNormalImage: @"",
        EmptyButtonHighlightedImage: @"",
        EmptyButtonDisabledImage: @""
    };
    return dic;
}

+ (UIColor *)subButtonTitleColor {
    return [UIColor blueColor];
}

+ (UIColor *)tipTextColor {
    return [UIColor grayColor];
}

@end
