//
//  YDAlertAction.h
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YDAlertAction;

typedef NS_ENUM(NSInteger,YDAlertActionStyle) {
    YDAlertActionStyleDefault = 0,
    YDAlertActionStyleCancel,
    YDAlertActionStyleDone
};

typedef void(^YDAlertActionHandler)(YDAlertAction *_Nonnull);

@interface YDAlertAction : UIButton

/**
 按钮title
 */
@property (nonatomic, copy, nullable) NSString *title;

@property (nonatomic, assign) YDAlertActionStyle style;

@property (nonatomic, copy, nullable) YDAlertActionHandler handler;

+ (instancetype _Nonnull )actionWithTitle:(nullable NSString *)title style:(YDAlertActionStyle)style handler:(YDAlertActionHandler _Nullable)hanlder;

@end

NS_ASSUME_NONNULL_END
