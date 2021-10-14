//
//  YDUserConfig.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import <Foundation/Foundation.h>
#import "YDUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDUserConfig : NSObject
@property (nonatomic, assign)BOOL isLogin;
//用户登录前需要先传用户登录必须字段
@property (nonatomic, copy)NSString *userAccount;
@property (nonatomic, copy)NSString *userPassword;
@property (nonatomic, copy)NSString *userCode;

+ (instancetype)shared;

- (YDUser *)getCurrentUser;

- (NSString *)currentUserId;

//用户注册
- (void)userRegister:(YDSuccessHandler) success failure:(YDFailureString)failure;

//用户登录
- (void)userLogin:(YDSuccessHandler) success failure:(YDFailureString)failure;

//发送验证码
- (void)userSendCaptcha:(YDSuccessHandler)success failure:(YDFailureString)failure;

//用户退出
- (void)userLogout;

//更新用户信息
- (void)updateUser:(YDUser *)user success:(YDSuccessHandler)success failure:(YDFailureString)failure;

@end

NS_ASSUME_NONNULL_END
