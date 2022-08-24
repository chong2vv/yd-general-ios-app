//
//  YDRouter+YDRegistConfig.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/24.
//

#import "YDRouter+YDRegistConfig.h"

@implementation YDRouter (YDRegistConfig)

+ (void)customResigtWithRouter:(YDRouter *)router {
    ///注册uid获取，例如pod库、扩展这些需要获取的时候可以使用
    /// NSString * const extern_currentUserId = @"ydapp://extern_currentUserId";
    ///(NSString *)currentUserId {
    ///    __block NSString * currentUserId = @"";
    ///[THEYDURLHandler handleURLStr:extern_currentUserId finish:^(id  _Nonnull result) {
    ///currentUserId = result;
    /// }];
    ///return currentUserId;
    ///}
    [YDRouter.sharedInstance registerURLPattern:@"extern_currentUserId" toHandler:^(NSDictionary * _Nonnull userInfo) {
        void(^callback)(id result) = userInfo[@"^"];
        callback([[YDUserConfig shared] currentUserId]);
    }];
}

@end
