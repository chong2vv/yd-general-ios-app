//
//  YDHomePageViewController.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import "YDHomePageViewController.h"

@interface YDHomePageViewController ()

@end

@implementation YDHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *testLoginBt = [UIButton buttonWithType:UIButtonTypeSystem];
    [testLoginBt setTitle:@"测试" forState:UIControlStateNormal];
    [testLoginBt addTarget:self action:@selector(testAction) forControlEvents:UIControlEventTouchUpInside];
    testLoginBt.frame = CGRectMake(100, 100, 200, 200);
    [self.view addSubview:testLoginBt];
    
}

- (void)testAction {
    [YDLoginService checkAndLoginWithTypeComplete:nil];
}


@end
