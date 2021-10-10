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


@end
