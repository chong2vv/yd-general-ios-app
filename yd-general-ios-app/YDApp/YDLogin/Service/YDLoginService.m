//
//  YDLoginService.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/20.
//

#import "YDLoginService.h"
#import "YDUserConfig.h"
#import "YDMediator+YDLogin.h"
#import "AppDelegate+YDSetupVC.h"

@implementation YDLoginService

+(BOOL)checkAndLoginWithTypeComplete:(void (^)(BOOL isLogin))completion {
    
    if ([YDUserConfig shared].isLogin) {
        return YES;
    }else {
        // 如果已弹出登录 就不要再次弹出登录
        if ([self isShowLoginVc]) {
            return NO;
        }
        
        [YDLoginService startLoginWithTypeComplete:^(BOOL result) {
            if (completion) completion(result);
        }];
    }
    
    
    return NO;
}

+(void)startLoginWithTypeComplete:(void (^)(BOOL result))completion {
    // 登录成功回调
    void (^successCallback)(BOOL,NSInteger,NSDictionary *) = ^(BOOL login, NSInteger loginType, NSDictionary *successInfo){
        if (!login) {
            if (completion)  completion(NO);
            return;
        }
        
        
    };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:successCallback forKey:@"successCallback"];
    [params setObject:@(NO) forKey:@"ischeck"];
    
    
    if([YDAppDelegate currentVC])
    {
        [params setObject:[YDAppDelegate currentVC] forKey:@"showViewController"];
    }
    NSLog(@"登录params ===== %@",params);
    // 防止二次弹出登录页面逻辑 -- start
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LoginVCIsShow"] == YES) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoginVCIsShow"];
        });
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoginVCIsShow"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoginVCIsShow"];
    });
    [[YDMediator sharedInstance] startLoginParams:params];
}

///当前显示的是否是登录VC
+ (BOOL)isShowLoginVc{
    return [self currentVC];
}

/// 获取当前显示的vc
+ (BOOL)currentVC
{
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getCurrentViewControllerFromRootVC:rootVc];
}

/// 获取当前显示的vc
/// @param vc 传入rootVC
+ (BOOL)getCurrentViewControllerFromRootVC:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVc = (UINavigationController *)vc;
        for (UIViewController *vc in navVc.viewControllers) {
            if ([NSStringFromClass(vc.class) isEqualToString:@"YDLoginViewController"]) {
                NSLog(@"show vc = login %@",vc.class);
                NSLog(@"show vc = 已经弹出登录 不需要再次弹出");
                return YES;
            }
        }
        return [self getCurrentViewControllerFromRootVC:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getCurrentViewControllerFromRootVC:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getCurrentViewControllerFromRootVC:vc.presentedViewController];
        } else {
            if ([NSStringFromClass(vc.class) isEqualToString:@"YDLoginViewController"]) {
                NSLog(@"show vc = login %@",vc.class);
                NSLog(@"show vc = 已经弹出登录 不需要再次弹出登录");
                return YES;
            }
        }
    }
    return NO;
}
@end
