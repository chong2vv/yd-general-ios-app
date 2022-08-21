//
//  YDMediator+YDLogin.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/20.
//

#import "YDMediator+YDLogin.h"

NSString * const kMediatorTargetLogin = @"YDAppLogin";
NSString * const kMediatorYDLogin = @"startLoginAppWithParams";

@implementation YDMediator (YDLogin)

- (UIViewController *)startLoginParams:(NSDictionary *)aParams navigationController:(UINavigationController *)aNav {
    return [self performTarget:kMediatorTargetLogin  action:kMediatorYDLogin params:[self handleParam:aParams type:1 navigationController:aNav]];
}

- (UIViewController *)startLoginParams:(NSDictionary *)aParams {
    return [self startLoginParams:aParams navigationController:nil];
}

@end
