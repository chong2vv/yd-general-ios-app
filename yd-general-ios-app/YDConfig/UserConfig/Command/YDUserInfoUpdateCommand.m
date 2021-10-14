//
//  YDUserInfoUpdateCommand.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/14.
//

#import "YDUserInfoUpdateCommand.h"

@implementation YDUserInfoUpdateCommand

- (NSString *)baseUrl {
    return [YDNetWorkConfig configBaseUrl];
}

- (NSString *)requestUrl {
    return @"/user/update";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (void)requestSuccess:(NSDictionary *)aDic {
    YDLogInfo(@"wyd - 更新用户信息成功 info:%@",aDic);
    NSDictionary *dic = [aDic objectForKey:@"data"];
    self.user = [[YDUser alloc] init];
    [self.user yy_modelSetWithDictionary:dic];
}

@end
