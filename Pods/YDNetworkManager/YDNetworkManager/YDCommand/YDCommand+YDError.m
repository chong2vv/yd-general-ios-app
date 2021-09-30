//
//  YDCommand+YDError.m
//  YDNetworkManager
//
//  Created by wangyuandong on 2021/9/30.
//

#import "YDCommand+YDError.h"

@implementation YDCommand (YDError)

- (void)dealWithServiceErrorStatus:(NSInteger)aStatus userInfo:(NSDictionary *)aDic {
    
//    switch (aStatus) {
//        case -1: // 授权被停用 要重新授权
//        {
//            NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
//            if (aDic[@"msg"]) {
//                dicM[kAuthorizationError] = aDic[@"msg"];
//            }
//            if (aDic[@"device"]) {
//                dicM[kAuthorizationDevice] = aDic[@"device"];
//            }
//            if (aDic[@"phone"]) {
//                dicM[kAuthorizationPhone] = aDic[@"phone"];
//            }
//            [ArtAppDelegate reauthorizationBy:[dicM copy]];
//
//        }
//            break;
//
//        default:
//            break;
//    }
}

@end
