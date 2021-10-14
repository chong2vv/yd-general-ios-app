//
//  YDUserConfig.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import "YDUserConfig.h"
#import "YDDB+YDUser.h"
#import "YDLoginCommand.h"
#import "YDRegisterCommand.h"
#import "YDUserInfoUpdateCommand.h"

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
        NSString *uid = [[MMKV defaultMMKV] getStringForKey:YDPlistCurrentUserUID];
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
    [[MMKV defaultMMKV] setString:user.uid forKey:YDPlistCurrentUserUID];
    [[[YDDB shareInstance] insertWithUserModel:user] subscribeNext:^(NSString *x) {
        NSString *uid = x;
        YDLogDebug(@"wyd - 用户保存信息成功 uid:%@", uid);
    }];
}

- (void)userLogout {
    YDLogDebug(@"wyd - 用户退出成功 uid:%@", self.currentUser.uid);
    [self clearUserInfo];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:YDPlistCurrentUserUID];
    self.isLogin = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:YDUserNotificationUserLogout object:nil];
}

- (void)clearUserInfo {
    self.userAccount = @"";
    self.userPassword = @"";
    self.userCode = @"";
}

- (void)userLoginWithUser:(YDUser *)user {
    self.currentUser = user;
    self.isLogin = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:YDUserNotificationUserLogin object:nil];
    [self saveUser:user];
}

- (void)userSendCaptcha:(YDSuccessHandler)success failure:(YDFailureString)failure {
    
}

- (void)userLogin:(YDSuccessHandler)success failure:(YDFailureString)failure {
    if (self.isLogin) {
        [SVProgressHUD showWithStatus:@"当前已登录"];
        return;
    }
    
    if (self.userAccount.length == 0) {
        if (failure) {
            failure(@"用户名不能为空");
        }
        return;
    }
    
    if (self.userPassword.length == 0 && self.userCode.length == 0) {
        if (self.userCode.length == 0) {
            if (failure) {
                failure(@"验证码不能为空");
                return;
            }
        }
        
        if (self.userPassword.length == 0) {
            if (failure) {
                failure(@"密码不能为空");
                return;
            }
        }
    }
    
    [SVProgressHUD show];
    @weakify(self);
    [YDLoginCommand ydCommandSetParame:^(__kindof YDLoginCommand * _Nonnull request) {
        request.input_userAccount = self.userAccount;
        request.input_userPassword = self.userPassword;
        request.input_userPassword = self.userCode;
        } completion:^(__kindof YDLoginCommand * _Nonnull request) {
            @strongify(self)
            [SVProgressHUD dismiss];
            if (request.error) {
                if (failure) {
                    failure(request.error.localizedDescription);
                }
                YDLogError(@"登录失败：%@", request.error);
            }else{
                YDUser *user = request.user;
                [[MMKV defaultMMKV] setString:self.userAccount forKey:YDPlistCurrentUserUID];
                [self userLoginWithUser:user];
                if (success) {
                    success();
                }
            }
            
        }];
}

- (void)userRegister:(YDSuccessHandler)success failure:(YDFailureString)failure {
    if (self.isLogin) {
        [SVProgressHUD showWithStatus:@"当前已登录"];
        return;
    }
    
    if (self.userAccount.length == 0) {
        if (failure) {
            failure(@"用户名不能为空");
        }
        return;
    }
    
    if (self.userPassword.length == 0 && self.userCode.length == 0) {
        if (self.userCode.length == 0) {
            if (failure) {
                failure(@"验证码不能为空");
                return;
            }
        }
        
        if (self.userPassword.length == 0) {
            if (failure) {
                failure(@"密码不能为空");
                return;
            }
        }
    }
    
    [SVProgressHUD show];
    @weakify(self);
    [YDRegisterCommand ydCommandSetParame:^(__kindof YDRegisterCommand * _Nonnull request) {
        request.input_userAccount = self.userAccount;
        request.input_userPassword = self.userCode;
        request.input_userPassword = self.userPassword;
        } completion:^(__kindof YDRegisterCommand * _Nonnull request) {
            @strongify(self)
            [SVProgressHUD dismiss];
            if (request.error) {
                if (failure) {
                    failure(request.error.localizedDescription);
                }
                YDLogError(@"注册失败：%@", request.error);
            }else{
                YDUser *user = request.user;
                [self userLoginWithUser:user];
                if (success) {
                    success();
                }
            }
            
        }];
}

- (void)updateUser:(YDUser *)user success:(YDSuccessHandler)success failure:(YDFailureString)failure {
    [SVProgressHUD show];
    @weakify(self);
    [YDUserInfoUpdateCommand ydCommandSetParame:^(__kindof YDUserInfoUpdateCommand * _Nonnull request) {
        request.input_uid = self.currentUser.uid;
        request.input_user = [user yy_modelToJSONString];

        } completion:^(__kindof YDUserInfoUpdateCommand * _Nonnull request) {
            @strongify(self)
            [SVProgressHUD dismiss];
            if (request.error) {
                if (failure) {
                    failure(request.error.localizedDescription);
                }
                YDLogError(@"注册失败：%@", request.error);
            }else{
                YDUser *user = request.user;
                [self saveUser:user];
                if (success) {
                    success();
                }
            }
            
        }];
}

- (NSString *)currentUserId {
    return self.currentUser.uid;
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
