//
//  AppDelegate+YDAvoidCrash.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import "AppDelegate+YDAvoidCrash.h"

@implementation AppDelegate (YDAvoidCrash)

- (void)becomeEffective {
    //设置防崩溃回调
    [YDAvoidCrash setupBlock:^(NSException *exception, NSString *defaultToDo, BOOL upload) {
            
    }];
    //开启防崩溃
    [YDAvoidCrash becomeAllEffectiveWithLogger:YES];
    
}

@end
