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
@property (nonatomic, copy)NSString *userAccount;
@property (nonatomic, copy)NSString *userPassword;
@property (nonatomic, copy)NSString *userCode;

+ (instancetype)shared;

- (YDUser *)getCurrentUser;

//保存 or 更新用户信息
- (void)saveUser:(YDUser *)user;

//用户注册
- (void)userRegister:(YDSuccessHandler) success failure:(YDFailureString)failure;

//用户登录
- (void)userLogin:(YDSuccessHandler) success failure:(YDFailureString)failure;

//用户退出
- (void)userLogout;

@end

NS_ASSUME_NONNULL_END
