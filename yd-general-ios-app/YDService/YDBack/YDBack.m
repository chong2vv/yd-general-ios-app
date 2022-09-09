//
//  YDBack.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/9/8.
//

#import "YDBack.h"

@interface YDBack ()


@end

@implementation YDBack

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self ga_setupApplicationHoldRunning];
    });
}

// 开启后台任务，延长运行时间
static dispatch_semaphore_t kBGDsem = NULL;
static BOOL kBGDsemAction = NO;

+ (void)ga_setupApplicationHoldRunning {
    static id observer = nil;
    /// FIFO 先进先出原则，所以我们要最后添加
    if (observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                                 object:nil
                                                                  queue:nil
                                                             usingBlock:^(NSNotification *_Nonnull note) {
                                                                 /// 保证前面执行了 才能加锁等待
                                                                 if (kBGDsemAction) {
                                                                     dispatch_semaphore_wait(kBGDsem, DISPATCH_TIME_FOREVER);
                                                                     kBGDsemAction = NO;
                                                                 }
                                                             }];
    /// 每隔10秒移除原先的监听，并重新加到最后
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self ga_setupApplicationHoldRunning];
    });
}

+ (void)ga_applicationDidEnterBackgroundNotification {
    /// 延长下正常退到后台的运行时间
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kBGDsem = dispatch_semaphore_create(0);
    });
    // 保证页面数据先存到数据库
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), self.gaQueue, ^{
//        // 埋点数据发送等...
//        [self handleBatchTimerExpired];
//        // 可能还在网络请求，强制保活1秒，之后才允许其他代码执行
//
//        [NSObject imy_asyncBlock:^{
//            dispatch_semaphore_signal(kBGDsem);
//        } afterSecond:1];
//    });
    kBGDsemAction = YES;
}

@end
