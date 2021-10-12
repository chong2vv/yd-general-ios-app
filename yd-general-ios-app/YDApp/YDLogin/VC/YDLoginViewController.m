//
//  YDLoginViewController.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import "YDLoginViewController.h"
#import "YDHiddenFunctionViewController.h"
#import "YDLoginCommand.h"
@interface YDLoginViewController ()

@end

@implementation YDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
}

- (void)login {
    
    [SVProgressHUD show];
    [YDLoginCommand ydCommandSetParame:^(__kindof YDLoginCommand * _Nonnull request) {
            
        } completion:^(__kindof YDLoginCommand * _Nonnull request) {
            [SVProgressHUD dismiss];
            if (request.error) {
                YDLogError(@"登录失败：%@", request.error);
            }else{
                YDUser *user = request.user;
                [[YDUserConfig shared] userLoginWithUser:user];
            }
            
        }];
}

@end
