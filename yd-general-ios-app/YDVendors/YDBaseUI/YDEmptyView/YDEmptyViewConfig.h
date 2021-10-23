//
//  YDEmptyViewConfig.h
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/23.
//

#import <Foundation/Foundation.h>

#define EmptyNoDataImage           @"noDataImage"
#define EmptyNetworkExceptionImage @"networkExceptionImage"
#define EmptyRequestExceptionImage @"requestExceptionImage"

#define EmptyButtonNormalImage      @"buttonNormalImage"
#define EmptyButtonHighlightedImage @"buttonHighlightedImage"
#define EmptyButtonDisabledImage    @"buttonDisabledImage"

NS_ASSUME_NONNULL_BEGIN

@interface YDEmptyViewConfig : NSObject

+ (NSDictionary<NSString *, UIImage *> *)emptyImage;

+ (UIImage *)defaultEmptyImage;

+ (NSDictionary<NSString *, UIImage *> *)buttonBackgroundImage;

+ (UIColor *)subButtonTitleColor;

+ (UIColor *)tipTextColor;

@end

NS_ASSUME_NONNULL_END
