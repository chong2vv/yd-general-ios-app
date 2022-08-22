//
//  YDSendCodeCommand.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/14.
//

#import "YDSendCodeCommand.h"

@implementation YDSendCodeCommand

- (NSString *)baseUrl {
    return [YDNetWorkConfig configBaseUrl];
}

- (NSString *)requestUrl {
    return @"/user/send";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (void)requestSuccess:(NSDictionary *)aDic {
    YDLogInfo(@"wyd - 发送验证码成功 info:%@",aDic);
}

@end
