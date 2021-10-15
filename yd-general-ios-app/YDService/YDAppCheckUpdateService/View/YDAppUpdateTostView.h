//
//  YDAppUpdateTostView.h
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YDAppUpdateStyleNoUpdate = 0,
    YDAppUpdateStyleNormal = 1,
    YDAppUpdateStyleForce = 2,
} YDAppUpdateStyle;

@interface YDAppUpdateTostView : UIView

- (void)showTitle:(NSString *)title content:(NSString *)content style:(YDAppUpdateStyle)style cancelAction:(YDCancelActionBlock) cancelAction confirmAction:(YDConfirmActionBlock)confirmAction;

@end

NS_ASSUME_NONNULL_END
