//
//  YDHiddenFunctionPasswordView.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YDHiddenFunctionPasswordInputDelegate <NSObject>

- (void)checkPasswordInput:(NSString *)password;

@end

@interface YDHiddenFunctionPasswordView : UIView

@property (nonatomic, weak)id<YDHiddenFunctionPasswordInputDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
