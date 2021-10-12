//
//  AppDelegate+YDAvoidCrash.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import "AppDelegate+YDAvoidCrash.h"
#import "YDLoggerUploadService.h"

@implementation AppDelegate (YDAvoidCrash)

- (void)becomeEffective {
    //设置防崩溃回调
    [YDAvoidCrash setupBlock:^(NSException *exception, NSString *defaultToDo, BOOL upload) {
            
    }];
    //开启防崩溃
    [YDAvoidCrash becomeAllEffectiveWithLogger:YES];
    
    YDLogInfo(@"==== 开启防崩溃 ====");
    
    [[YDLoggerUploadService shared] uploadLoggerZIP];
}

@end
