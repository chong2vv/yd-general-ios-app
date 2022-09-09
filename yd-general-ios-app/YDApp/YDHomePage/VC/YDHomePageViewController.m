//
//  YDHomePageViewController.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import "YDHomePageViewController.h"
#import "YDHiddenFunctionViewController.h"

@interface YDHomePageViewController ()

@end

@implementation YDHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self oppenHiddenFunctionVC];
    [self configTestUI];
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

- (void)configTestUI {
    UIButton *testLoginBt = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:testLoginBt];
    [testLoginBt setTitle:@"登录判断" forState:UIControlStateNormal];
    [testLoginBt addTarget:self action:@selector(userLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [testLoginBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(20);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
    }];
}

- (void)userLoginAction {
    [YDLoginService checkAndLoginWithTypeComplete:^(BOOL isLogin) {
        if (isLogin) {
            NSLog(@"登录成功");
        }
    }];
}


@end
