//
//  YDLaunchScreenCommand.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/22.
//

#import "YDLaunchScreenCommand.h"
#import "YDLaunchScreenModel.h"

@implementation YDLaunchScreenCommand

- (NSString *)baseUrl {
    return [YDNetWorkConfig configBaseUrl];
}

-(NSString *)requestUrl {
    return @"/api/platform/app/ad/v2/launch";
}

- (NSTimeInterval)requestTimeoutInterval {
    return 5.f;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}


- (void)requestSuccess:(NSDictionary *)aDic {
    NSArray *lauchArray = aDic[@"payload"];
    NSArray *lauchModelArray = [NSArray yy_modelArrayWithClass:YDLaunchScreenModel.class json:lauchArray];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kArtLaunchNotification" object:lauchModelArray];
    NSLog(@"开屏广告接口数据%@",aDic);
}

@end
