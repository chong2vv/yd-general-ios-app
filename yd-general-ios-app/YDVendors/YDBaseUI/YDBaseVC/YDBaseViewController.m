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
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    //navigation标题文字颜色
        NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor blackColor],
                              NSFontAttributeName : [UIFont systemFontOfSize:18 weight:UIFontWeightMedium]};
        if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
            barApp.backgroundColor = [UIColor whiteColor];
            barApp.shadowColor = [UIColor whiteColor];
            barApp.titleTextAttributes = dic;
            self.navigationController.navigationBar.scrollEdgeAppearance = barApp;
            self.navigationController.navigationBar.standardAppearance = barApp;
        }else{
            //背景色
            self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
            self.navigationController.navigationBar.titleTextAttributes = dic;
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        }
        //不透明
        self.navigationController.navigationBar.translucent = NO;
        //navigation控件颜色
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [self oppenHiddenFunctionVC];
}

- (void)oppenHiddenFunctionVC {
    [self.navigationController.navigationBar whenFiveTapped:^{
        YDHiddenFunctionViewController *vc = [[YDHiddenFunctionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)makeBackBt {
    
}
@end
