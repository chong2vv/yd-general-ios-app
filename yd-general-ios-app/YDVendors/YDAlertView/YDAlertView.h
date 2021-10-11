//
//  YDAlertView.h
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/11.
//

#import <UIKit/UIKit.h>
@class YDAlertAction;

NS_ASSUME_NONNULL_BEGIN

@interface YDAlertView : UIView

+ (instancetype)alertViewWith:(id)title message:(id)message;
- (void)addAction:(YDAlertAction *)action;

@end

NS_ASSUME_NONNULL_END
