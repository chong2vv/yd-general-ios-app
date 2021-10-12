//
//  AppDelegate.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/9/29.
//

#import "AppDelegate.h"
#import "AppDelegate+YDServicePush.h"
#import "AppDelegate+YDAvoidCrash.h"
#import "AppDelegate+YDThird.h"
#import "AppDelegate+YDSetupVC.h"


#import "YDTestViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //开启YDAvoidCrash方崩溃库
    [self becomeEffective];
    
    //注册推送
    [self registerForRemoteNotifications:application didFinishLaunchingWithOptions:launchOptions];
    
    //开启第三方配置，如bugly
    [self thirdPartyConfig:application];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    //常规写法，同一界面响应时的排他性
    [[UIButton appearance] setExclusiveTouch:YES];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        [[UITabBar appearance] setTranslucent:NO];
    }
    
    //配置root vc
    [self configRootVC:application];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
}
@end
