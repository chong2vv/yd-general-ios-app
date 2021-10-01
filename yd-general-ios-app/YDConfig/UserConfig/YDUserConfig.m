//
//  YDUserConfig.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import "YDUserConfig.h"

@interface YDUserConfig ()

@end

@implementation YDUserConfig

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static id shared = nil;
    dispatch_once(&onceToken, ^{
         shared = [[self alloc] init];
    });
    return shared;
}

- (BOOL)isLogin {
    return NO;
}

@end
