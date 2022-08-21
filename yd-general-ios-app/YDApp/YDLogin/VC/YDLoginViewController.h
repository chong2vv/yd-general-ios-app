//
//  YDLoginViewController.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import "YDBaseViewController.h"
#import "YDLoginConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDLoginViewController : YDBaseViewController

@property (nonatomic, assign) BOOL callbackAfterDismiss;

@property (nonatomic,   copy) dispatch_block_t customSuccessAction;
//登录/注册/修改密码 成功的回调
@property (nonatomic,   copy) void(^successCallback)(BOOL logined, YDLoginSuccessType loginType, NSDictionary *successInfo);

@end

NS_ASSUME_NONNULL_END
