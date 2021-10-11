//
//  YDAlertViewController.h
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/11.
//

#import <UIKit/UIKit.h>
#import "YDAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDAlertViewController : UIViewController

#pragma mark - AlertController的便捷调用方法
/**
 AlertController的便捷调用方法
 title、message、cancelButtonTitle 支持NSString和NSAttributedString
 NSAttributedString 最少需要传入NSFontAttributeName
 */
+(void)showAlertWithTitle:(nullable id )title
                  message:(nullable id )message
        cancelButtonTitle:(nullable id )cancelButtonTitle;


/**
 AlertController的便捷调用方法
 title、message、cancelButtonTitle 支持NSString和NSAttributedString
 NSAttributedString 最少需要传入NSFontAttributeName

 @param title title
 @param message message
 @param cancelButtonTitle cancelButtonTitle
 @param otherButtonTitles otherButtonTitles
 @param didSelectBlock 选中调用block
 @param didCancelBlock 取消调用block
 */
+(void)showAlertWithTitle:(nullable id)title
                  message:(nullable id)message
        cancelButtonTitle:(nullable id)cancelButtonTitle
        otherButtonTitles:(nullable NSArray<id> *)otherButtonTitles
           didSelectBlock:(nullable void (^)(YDAlertAction * _Nullable action,NSUInteger index))didSelectBlock
           didCancelBlock:(nullable void (^)(void))didCancelBlock;


#pragma mark -
/**
 AlertController的构造方法
 title、message 支持NSString和NSAttributedString
 NSAttributedString 最少需要传入NSFontAttributeName
 */
+ (instancetype _Nonnull )alertControllerWithTitle:(nullable id)title message:(nullable id)message;

- (void)addAction:(YDAlertAction *_Nonnull)action;

- (void)presentFromViewController:(UIViewController *_Nullable)fromViewController animated:(BOOL)animated completion:(void (^_Nullable)(void))completion;

- (void)dismissWithAnimation:(BOOL)animated completion:(void (^_Nullable)(void))completion;

@end


@interface Alert : NSObject

+ (void)showBasicAlertOnVC:(UIViewController *)vc withTitle:(NSString *)title message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
