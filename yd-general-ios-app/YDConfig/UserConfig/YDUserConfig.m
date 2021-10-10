//
//  YDUserConfig.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import "YDUserConfig.h"
#import "YDDB+YDUser.h"
@interface YDUserConfig ()

@property (nonatomic, strong)YDUser *currentUser;

@end

@implementation YDUserConfig

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static id shared = nil;
    dispatch_once(&onceToken, ^{
         shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:YDPlistCurrentUserUID];
        if (uid.length > 0) {
            self.isLogin = YES;
            [[[YDDB shareInstance] selectUserWithUid:uid] subscribeNext:^(YDUser *x) {
                self.currentUser = x;
            }];
        }else{
            self.isLogin = NO;
        }
    }
    return self;
}

- (void)saveUser:(YDUser *)user {
    self.currentUser = user;
    [[[YDDB shareInstance] insertWithUserModel:user] subscribeNext:^(NSString *x) {
        NSString *uid = x;
        YDLogDebug(@"wyd - 用户保存信息成功 uid:%@", uid);
    }];
}

- (void)userLogout {
    YDLogDebug(@"wyd - 用户退出成功 uid:%@", self.currentUser.uid);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:YDPlistCurrentUserUID];
    self.isLogin = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:YDUserNotificationUserLogout object:nil];
}

- (void)userLoginWithUser:(YDUser *)user {
    self.currentUser = user;
    self.isLogin = YES;
    [[NSUserDefaults standardUserDefaults] setValue:user.uid forKey:YDPlistCurrentUserUID];
    [[NSNotificationCenter defaultCenter] postNotificationName:YDUserNotificationUserLogin object:nil];
    [[[YDDB shareInstance] insertWithUserModel:user] subscribeNext:^(NSString *x) {
        NSString *uid = x;
        YDLogDebug(@"wyd - 用户登录保存信息成功 uid:%@", uid);
    }];
}

- (YDUser *)getCurrentUser {
    return self.currentUser;
}

- (YDUser *)currentUser {
    if (!_currentUser) {
        _currentUser = [[YDUser alloc] init];
    }
    return _currentUser;
}

@end
