//
//  AppDelegate+YDNotifications.h
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/9/29.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (YDServicePush)

-(void)registerForRemoteNotifications:(UIApplication *)application;

@end

NS_ASSUME_NONNULL_END
