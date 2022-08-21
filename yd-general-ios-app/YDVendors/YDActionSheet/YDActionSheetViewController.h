//
//  YDActionSheetViewController.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/20.
//

#import <UIKit/UIKit.h>
#import "YDSheetButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDActionSheetViewController : UIViewController

@property (nonatomic, copy) NSString *actionTitle; // 顶部title文字
@property (nonatomic, assign) CGFloat actionTitleHeight; // 顶部title高度，默认54
@property (nonatomic, assign) CGFloat actionButtonHeight; // 按钮高度，默认54
@property (nonatomic, assign) CGFloat cancelButtonHeight; // 取消按钮高度，默认54
- (NSInteger)addButtonWithTitle:(nullable NSString *)title style:(YDSheetButtonStyle)stype handler:(nullable void (^)(UIButton * button))handler;
- (NSInteger)addCancelButtonWithTitle:(nullable NSString *)title handler:(nullable void (^)(UIButton * button))handler;

@end

NS_ASSUME_NONNULL_END
