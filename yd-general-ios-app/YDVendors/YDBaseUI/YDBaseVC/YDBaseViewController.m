//
//  YDBaseViewController.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import "YDBaseViewController.h"
#import "YDHiddenFunctionViewController.h"
@interface YDBaseViewController ()

@end

@implementation YDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar whenFiveTapped:^{
        YDHiddenFunctionViewController *vc = [[YDHiddenFunctionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
