//
//  YDRegisterCommand.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/13.
//

#import "YDRegisterCommand.h"

@implementation YDRegisterCommand

- (NSString *)baseUrl {
    return [YDNetWorkConfig configBaseUrl];
}

- (NSString *)requestUrl {
    return @"/user/register";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (void)requestSuccess:(NSDictionary *)aDic {
    YDLogInfo(@"wyd - 注册成功 info:%@",aDic);
    NSDictionary *dic = [aDic objectForKey:@"data"];
    self.user = [[YDUser alloc] init];
    [self.user yy_modelSetWithDictionary:dic];
}

@end
