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

@implementation AppDelegate (YDSetupVC)

- (void)configRootVC:(UIApplication *)application {
    if ([[YDUserConfig shared] isLogin]) {
        [self configTabVC];
    }else{
        [self configLoginVC];
    }
    [self loadUserLoginNotification];
}

// 配置登录VC
- (void)configLoginVC {
    YDLoginViewController *vc = [[YDLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

// 配置tabbar
- (void)configTabVC {
    self.window.rootViewController = [self setupViewControllers];
    [self.window makeKeyAndVisible];
}

//登录、登出消息通知处理
- (void)loadUserLoginNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userLogin) name:YDUserNotificationUserLogin object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userLogout) name:YDUserNotificationUserLogout object:nil];
}

- (void)_userLogin {
    [self configTabVC];
}

- (void)_userLogout {
    [self configLoginVC];
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
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
//    [[UITabBar appearance] setBackgroundColor:mainBlck];
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


@end
