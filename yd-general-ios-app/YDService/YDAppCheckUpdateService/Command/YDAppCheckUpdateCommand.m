//
//  YDAppCheckUpdateCommand.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/15.
//

#import "YDAppCheckUpdateCommand.h"

@implementation YDAppCheckUpdateCommand

- (NSString *)baseUrl {
    return [YDNetWorkConfig configBaseUrl];
}

- (NSString *)requestUrl {
    return @"/user/login";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (void)requestSuccess:(NSDictionary *)aDic {
    YDLogInfo(@"wyd - 登录成功 info:%@",aDic);
    NSDictionary *dic = [aDic objectForKey:@"data"];
    self.updateStyle = YDAppUpdateStyleNoUpdate;
}

@end
