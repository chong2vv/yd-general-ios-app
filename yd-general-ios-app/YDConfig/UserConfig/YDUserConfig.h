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

+ (instancetype)shared;

- (YDUser *)getCurrentUser;

//保存 or 更新用户信息
- (void)saveUser:(YDUser *)user;

//用户退出
- (void)userLogout;

//用户登录
- (void)userLoginWithUser:(YDUser *)user;

@end

NS_ASSUME_NONNULL_END
