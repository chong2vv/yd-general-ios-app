//
//  YDConst.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//plist key值
@interface YDPlistConst : NSObject

//用户uid
extern NSString *const YDPlistCurrentUserUID;

//用户名（上一次登录账号）
extern NSString *const YDPlistCurrentUserAccount;

@end

//消息名
@interface YDNotificationConst : NSObject

//登录
extern NSString *const YDUserNotificationUserLogin;
//退出登录
extern NSString *const YDUserNotificationUserLogout;

@end

@interface YDConst : NSObject

@end

NS_ASSUME_NONNULL_END
