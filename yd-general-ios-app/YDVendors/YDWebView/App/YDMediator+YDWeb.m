//
//  YDMediator+YDWeb.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/18.
//

#import "YDMediator+YDWeb.h"

NSString * const kMediatorTargetWeb = @"YDAppWeb";
NSString * const kMediatorArtWeb = @"startWebAppWithParams";

@implementation YDMediator (YDWeb)

- (UIViewController *)startLinkerParams:(NSDictionary *)aParams
                   navigationController:(UINavigationController *)aNav{
    return [self performTarget:kMediatorTargetWeb action:kMediatorArtWeb params:[self handleParam:aParams type:1 navigationController:aNav]];
}

- (UIViewController *)startLinkerParams:(NSDictionary *)aParams{
    return [self startLinkerParams:aParams navigationController:nil];
}


@end
