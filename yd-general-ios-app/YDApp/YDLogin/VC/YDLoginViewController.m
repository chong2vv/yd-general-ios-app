//
//  YDLoginViewController.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import "YDLoginViewController.h"
#import "YDHiddenFunctionViewController.h"

@interface YDLoginViewController ()

@end

@implementation YDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    [self oppenHiddenFunctionVC];
    
    UIButton *testLoginBt = [UIButton buttonWithType:UIButtonTypeSystem];
    [testLoginBt setTitle:@"测试" forState:UIControlStateNormal];
    [testLoginBt addTarget:self action:@selector(testAction) forControlEvents:UIControlEventTouchUpInside];
    testLoginBt.frame = CGRectMake(100, 100, 200, 200);
    [self.view addSubview:testLoginBt];
}

- (void)oppenHiddenFunctionVC {
    [self.navigationController.navigationBar whenFiveTapped:^{
        yd_dispatch_async_main_safe(^{
            YDHiddenFunctionViewController *vc = [[YDHiddenFunctionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            YDLogInfo(@"==== 进入隐藏功能 ====");
            NSLog(@"隐藏功能");
        });
    }];
}

//测试用 ->登录成功
- (void)testAction {
    
    [self loginOrRegisterComplete:@{@"test":@"test"}];
}

// 登录调用
- (void)loginAction {
    [YDUserConfig shared].userAccount = @"";
    [YDUserConfig shared].userPassword = @"";
    
    @weakify(self)
    [[YDUserConfig shared] userLogin:^{
        @strongify(self);
        [self loginOrRegisterComplete:nil];
        } failure:^(NSString *error) {
            @strongify(self);
            [self loginOrRegisterFailure];
        }];
}

/// 登录失败
- (void)loginOrRegisterFailure {
    
}

/// 登录成功
- (void)loginOrRegisterComplete:(NSDictionary *)successInfo {
    __weak typeof(self) weakSelf = self;
    void(^complete)(void) = ^(){
        if (weakSelf.successCallback) {
            weakSelf.successCallback(YES, YDLoginSuccessTypeLogin, successInfo);
        }
    };
    if (self.callbackAfterDismiss) {
        [self dismissVCCompletion:complete];
    } else {
        complete();
        [self dismissVCCompletion:nil];
    }
}

/// 关闭界面Action
/// @param completion block
- (void)dismissVCCompletion:(void(^)(void))completion {
    //在有键盘弹出的情况下才需要延时dismiss
    if([IQKeyboardManager sharedManager].keyboardShowing) {
        [self.view endEditing:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:completion];
        });
    } else {
        [self dismissViewControllerAnimated:YES completion:completion];
    }
}

@end
