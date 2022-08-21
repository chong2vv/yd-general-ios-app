//
//  YDLoginConfig.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/20.
//

#ifndef YDLoginConfig_h
#define YDLoginConfig_h

// 登录成功回调类型
typedef NS_ENUM(NSUInteger, YDLoginSuccessType) {
    YDLoginSuccessTypeLogin,  // 登录
    YDLoginSuccessTypeRegist, // 注册
    YDLoginSuccessTypeForget, // 忘记密码
};

#endif /* YDLoginConfig_h */
