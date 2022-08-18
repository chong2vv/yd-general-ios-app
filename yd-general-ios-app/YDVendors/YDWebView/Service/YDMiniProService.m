//
//  YDMiniProService.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/17.
//

#import "YDMiniProService.h"

NSString *const kMiniProName = @"username";
NSString *const kMiniProPath = @"path";
NSString *const kMiniProId = @"id";
NSString *const kMiniProType = @"type";

@interface YDMiniProService ()

@property (nonatomic, assign)CGFloat delay;

@end


@implementation YDMiniProService

+ (void)launchMiniProWithUrl:(NSString *)url delay:(CGFloat)delay{
    YDMiniProService *service = [[self alloc] init];
    service.delay = delay;
    [service launchMiniProWithParams:[self paramsMiniProUrl:url]];
}

//解析小程序url返回参数
+ (NSDictionary *)paramsMiniProUrl:(NSString *)url{
    /*
    @"miniPro://gh_77f439449d46/pages/detail/index?id=wx4096e434de6f8f12";
     url.scheme = miniPro
     url.path = @"/pages/detail/index"
     url.host = @"gh_77f439449d46"
     url.query = @"id=wx4096e434de6f8f12";  这个小程序id目前用不上
     */
    
    NSURL *aUrl = [NSURL URLWithString:url];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (aUrl.host.length) {
        params[kMiniProName] = aUrl.host;
    }
    if (aUrl.path.length) {
        params[kMiniProPath] = aUrl.path;
    }
    if (aUrl.query.length > 0) {
        NSString *query = aUrl.query;
        NSArray *arr = [query componentsSeparatedByString:@"&"];
        for (NSString *tempStr in arr) {
            NSArray *subArr = [tempStr componentsSeparatedByString:@"="];
            if (subArr.count == 2) {
                [params setObject:subArr.lastObject forKey:subArr.firstObject];
            }
        }
    }
    if (!params.count) {
        return nil;
    }
    return [params copy];
}

// app 唤起小程序
- (void)launchMiniProWithParams:(NSDictionary *)params{
    if (!params || !params.count) return;
    
    /***********************  使用时引入wx库，去掉注释   ************************/
//    WXLaunchMiniProgramReq *launch = [WXLaunchMiniProgramReq object];
//    //拉起的小程序的username 必填 "gd_"
//    if ([params.allKeys containsObject:kMiniProName]) {
//       launch.userName = params[kMiniProName];
//    }
//    // 0<正式版> 1<开发版> 2<体验版> 必填
//    if ([params.allKeys containsObject:kMiniProType]) {
//        launch.miniProgramType = [params[kMiniProType] integerValue];
//    }
//    //这个地方是指定小程序的定位页面,不填写就是小程序首页 选填
//    if ([params.allKeys containsObject:kMiniProPath]) {
//        launch.path = params[kMiniProPath];
//    }
//    if (self.delay > 0) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [WXApi sendReq:launch completion:^(BOOL success) {
//                if (success) {
//                    NSLog(@"唤醒小程序成功");
//                }else{
//                    NSLog(@"唤醒小程序失败");
//                }
//            }];
//
//        });
//    }else{
//        [WXApi sendReq:launch completion:^(BOOL success) {
//            if (success) {
//                NSLog(@"唤醒小程序成功");
//            }else{
//                NSLog(@"唤醒小程序失败");
//            }
//        }];
//    }
}

@end
