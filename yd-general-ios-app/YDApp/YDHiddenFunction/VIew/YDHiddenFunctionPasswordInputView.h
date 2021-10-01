//
//  YDHiddenFunctionPasswordView.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YDHiddenFunctionPasswordViewDelegate <NSObject>

@optional
- (void)keyViewDidEndEditing:(NSString*)key;

@end

@interface YDHiddenFunctionPasswordInputView : UIView

@property (nonatomic, weak) id<YDHiddenFunctionPasswordViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
