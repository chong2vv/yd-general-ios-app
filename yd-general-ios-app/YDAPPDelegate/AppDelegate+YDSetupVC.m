//
//  AppDelegate+YDSetupVC.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import "AppDelegate+YDSetupVC.h"
#import "YDUserConfig.h"

#import "YDLoginViewController.h"
#import "YDHomePageViewController.h"
#import "YDMineViewController.h"
#import "CYLTabBarController.h"
#import "YDLaunchScreenViewController.h"

//app启动进入首页是否需要登录
BOOL const YDAppStartNeedLogin = NO;

@implementation AppDelegate (YDSetupVC)

- (void)configRootVC:(UIApplication *)application {
    
    [self configTabVC];
//    //根据实际项目配置是否需要初始化就登录
//    if (YDAppStartNeedLogin) {
//        if ([[YDUserConfig shared] isLogin]) {
//            [self configTabVC];
//        }else{
//            [self configLoginVC];
//        }
//    }else{
//        [self configTabVC];
//    }
/// 根据实际项目选择是否配置登录、退出通知
//    [self loadUserLoginNotification];
}

// 配置登录VC
- (void)configLoginVC {
    YDLoginViewController *vc = [[YDLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

-(void)initAppCommandDisplayMainVc {
    YDLaunchScreenViewController *launchScreenVc = [[YDLaunchScreenViewController alloc] init];
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = launchScreenVc;
    window.windowLevel = UIWindowLevelStatusBar + 3;
    window.hidden = NO;
    window.alpha = 1;
    self.adWindow = window;
}


// 配置tabbar
- (void)configTabVC {
    self.window.rootViewController = [self setupViewControllers];
    [self.window makeKeyAndVisible];
}

//登录、登出消息通知处理 看项目配置
- (void)loadUserLoginNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userLogin) name:YDUserNotificationUserLogin object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userLogout) name:YDUserNotificationUserLogout object:nil];
}

- (void)_userLogin {
    if (YDAppStartNeedLogin) {
        [self configTabVC];
    }
}

- (void)_userLogout {
    if (YDAppStartNeedLogin) {
        [self configLoginVC];
    }
}

#pragma mark ------- init window root view controller

- (CYLTabBarController *)setupViewControllers {
    //首页
    YDHomePageViewController *homeViewController = [[YDHomePageViewController alloc] init];
    UIViewController *homeNavigationController = [[UINavigationController alloc]
                                                  initWithRootViewController:homeViewController];

    //我的
    YDMineViewController *mineViewController = [[YDMineViewController alloc] init];
    UIViewController *mineNavigationController = [[UINavigationController alloc]
                                                initWithRootViewController:mineViewController];

    CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
    [self customizeTabBarForController:tabBarController];

    [tabBarController setViewControllers:@[
                                           homeNavigationController,
                                           mineNavigationController
                                           ]];
    [self customizeTabBarAppearance:tabBarController];
    return tabBarController;
}

/**
 *  TabBar自定义设置
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
    // Customize UITabBar height
    // 自定义 TabBar 高度
//    tabBarController.tabBarHeight = MIS_IPHONE_X ? 65 : 40;

    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"17253E" alpha:0.6];
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"4A31FC"];
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
//    [[UITabBar appearance] setBackgroundImage:[[UIImage imageWithColor:[UIColor whiteColor]] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
}

- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController
{
    
    NSDictionary *home      = @{
                                CYLTabBarItemTitle : @"Home",
                                CYLTabBarItemImage : @"tab_home",
                                CYLTabBarItemSelectedImage : @"tab_home_s",
                                };
    
    NSDictionary *mine    = @{
                                CYLTabBarItemTitle : @"Me",
                                CYLTabBarItemImage : @"tab_mine",
                                CYLTabBarItemSelectedImage : @"tab_mine_s",
                                };
    
    NSArray *tabBarItemsAttributes = @[home, mine];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
}


- (UIViewController *)currentVC{
    UIViewController *vc = nil;
    vc = [self getCurrentViewControllerFromRootVC:self.window.rootViewController];
    return vc;
}

/// 获取当前显示的vc
/// @param vc 传入rootVC
- (UIViewController *)getCurrentViewControllerFromRootVC:(UIViewController *)vc{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getCurrentViewControllerFromRootVC:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getCurrentViewControllerFromRootVC:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getCurrentViewControllerFromRootVC:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

- (UITabBarController *)rootTabBarController
{
    if([self.window.rootViewController isKindOfClass:[UITabBarController class]]){
        return (UITabBarController*)self.window.rootViewController;
    } else if([self.window.rootViewController isKindOfClass:[UITabBarController class]]){
        UIViewController *tabBar = self.window.rootViewController ;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {
            return (UITabBarController *)tabBar;
        }
        return nil;
    }  else {
        return nil;
    }
}

@end
