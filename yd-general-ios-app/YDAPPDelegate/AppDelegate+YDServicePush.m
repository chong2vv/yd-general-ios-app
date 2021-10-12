//
//  AppDelegate+YDNotifications.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/9/29.
//

#import "AppDelegate+YDServicePush.h"
#import "AppDelegate+YDSetupVC.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@implementation AppDelegate (YDServicePush)

- (void)registerForRemoteNotifications:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [self configJPush:launchOptions];
    
    if (@available(iOS 11.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!granted) {
                yd_dispatch_async_main_safe(^{
                    NSLog(@"未开启推送通知!");
                });
            }
        }];
    } else {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }

    [[UIApplication sharedApplication] registerForRemoteNotifications];


    // 注册push权限，用于显示本地推送
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
}

//MARK: 远程推送注册成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
}

// 第三方 推送配置
- (void)configJPush:(NSDictionary *)launchOptions {
    
}

/**
 * 埋点“App 打开推送”事件。
 *
 * @param userInfo 包含与远程通知相关的信息的字典
 */

- (void)trackSFAppOpenNotificationWithUserInfo:(NSDictionary *)userInfo needJump:(BOOL)needJump{
    if (![[userInfo allKeys] containsObject:@"sf_data"]) {
        return;
    }
    NSMutableDictionary *pushProperties = [NSMutableDictionary dictionary]; // track 字典
    NSMutableDictionary * pushDict = [NSMutableDictionary dictionary];
    pushDict[@"pushtype"] = @(1);
    @try { // aps alert
        NSDictionary *apsAlert = userInfo[@"aps"][@"alert"];
        if ([apsAlert isKindOfClass:NSDictionary.class]) {
            pushProperties[@"$sf_msg_title"] = apsAlert[@"title"]; // 推送标题
            pushProperties[@"$sf_msg_content"] = apsAlert[@"body"]; // 推送内容
            if (needJump) {
                [self pushToJump:pushDict];
            }
        }
        else if ([apsAlert isKindOfClass:NSString.class]) {  pushProperties[@"$sf_msg_content"] = apsAlert; // 推送内容
        }
    } @catch (NSException *exception) {
    }
}

- (void)pushToJump:(NSDictionary *)userInfo{
    [self pushToJump:userInfo withAppStart:NO];
}

- (void)pushToJump:(NSDictionary*)userInfo withAppStart:(BOOL)start{
    if (self.rootTabBarController == nil) {
        @weakify(self)
        [RACObserve(self.window, rootViewController) subscribeNext:^(UIViewController *vc) {
            @strongify(self)
            if (![vc isKindOfClass:[UITabBarController class]]) {
                return;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self pushToJump:userInfo withAppStart:YES];
            });
        }];
        return;
    }
    
    BOOL appIsActiving = start ? !start : [UIApplication sharedApplication].applicationState == UIApplicationStateActive;
    static BOOL isShowingPushAlert = NO;
    if (!appIsActiving) {
        [self handleNotification:userInfo];
    }else {
        if (!isShowingPushAlert) {
            [self handleNotification:userInfo];
        }
    }
}


- (void)handleNotification:(NSDictionary *) message{
    
}

- (void)pushVC:(UIViewController *)vc {
    vc.hidesBottomBarWhenPushed = YES;
    if (self.currentVC) {
        [self.currentVC.navigationController pushViewController:vc animated:YES];
    }
}

- (void)presentVC:(UIViewController *)vc {
    vc.hidesBottomBarWhenPushed = YES;
    if (self.currentVC) {
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self.currentVC presentViewController:vc animated:YES completion:nil];
    }
}

@end
