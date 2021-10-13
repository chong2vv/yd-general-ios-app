//
//  YDNetWorkConfig.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import "YDNetWorkConfig.h"

@implementation YDNetWorkConfig

+ (NSString *)configBaseUrl {
    return kYDBaseURLString;
}

+ (NSString *)configDataAcquisitionURL {
    return kYDDataAcquisitionBaseURLString;
}

+ (NSString *)configOSSBaseUrl {
    return kYDOSSBaseURLString;
}

+ (NSDictionary<NSString *,NSString *> *)configHeader {
    NSMutableDictionary *requestHeaders = [[NSMutableDictionary alloc] init];
    
    
    return requestHeaders;
}

+ (void)configRequestCompleteFilter:(YDCommand *)command {
    YDLogInfo(@"请求成功%@_%@",command.requestUrl,command.requestArgument);
}

+ (void)configRequestFailedFilter:(YDCommand *)command {
    YDLogInfo(@"请求失败%@_%@_Error:%@",command.requestUrl,command.requestArgument, command.error.localizedDescription);
}
@end
