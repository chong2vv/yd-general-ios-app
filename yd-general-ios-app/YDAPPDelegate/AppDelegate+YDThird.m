//
//  AppDelegate+YDThird.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import "AppDelegate+YDThird.h"

#if kIosAppDev && DEBUG
#import <DoraemonKit/DoraemonManager.h>
#endif

@implementation AppDelegate (YDThird)

- (void)thirdPartyConfig:(UIApplication *)application {
    //开启bugly
    [Bugly startWithAppId:buglyKey];
    
    [MMKV initializeMMKV:nil];
    
#if kIosAppDev && DEBUG
    //DEBUG下开启哆啦A梦
    [[DoraemonManager shareInstance] install];
#endif
}

@end
