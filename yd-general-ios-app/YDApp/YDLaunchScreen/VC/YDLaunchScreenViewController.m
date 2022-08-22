//
//  YDLaunchScreenViewController.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/22.
//

#import "YDLaunchScreenViewController.h"
#import "YDLaunchScreenViewModel.h"
#import "YDMediator+YDWeb.h"
#import "YDWebConfig.h"
#import "AppDelegate+YDSetupVC.h"

@interface YDLaunchScreenViewController ()

@property (nonatomic, strong) YDLaunchScreenViewModel  *launchVM;
// 背景视图
@property (nonatomic, strong) UIView                    *bgView;
@property (nonatomic, strong) UIButton                  *skipBtn;
@property (nonatomic, strong) UIImageView       *adImageView;
@property (nonatomic, strong) UIButton                   *adBottomTipBtn;

@end

@implementation YDLaunchScreenViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self setNeedsStatusBarAppearanceUpdate];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    @weakify(self)
    [RACObserve(self.launchVM, countdownString) subscribeNext:^(id x) {
        @strongify(self)
        [self.skipBtn setTitle:x forState:UIControlStateNormal];
    }];
    [RACObserve(self.launchVM, showSkip) subscribeNext:^(id x) {
        @strongify(self)
        self.skipBtn.hidden = ![x boolValue];
    }];
    [self.launchVM.showAdImageSubject subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"开屏广告 显示");
        self.adImageView.image = x;
    }];
    [self.launchVM.showAdTipBtnImageSubject subscribeNext:^(id x) {
        @strongify(self)
       [self.adBottomTipBtn setImage:x forState:UIControlStateNormal];
    }];
    [self.launchVM.adClickUploadSubject subscribeNext:^(id x) {
        UIViewController *vc = [[YDMediator sharedInstance] startLinkerParams:@{kLinkUrl:x,kVcShowType:@(EYDMediatorShowTypePush)}];
        NSUInteger selectedIndex = [[YDAppDelegate rootTabBarController] selectedIndex];
        UINavigationController *nav = [[YDAppDelegate rootTabBarController].viewControllers objectAtIndex:selectedIndex];
        [nav pushViewController:vc animated:NO];
    }];
    [self.launchVM.closeAdSubject subscribeNext:^(id x) {
        @strongify(self)
        [self closeLaunchAd];
    }];
}

-(void)setUpViews
{
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.adImageView];
    [self.view addSubview:self.skipBtn];
    [self.view addSubview:self.adBottomTipBtn];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-100 - [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom);
        } else {
            make.bottom.mas_equalTo(-100);
        }
    }];
    
    [self.adBottomTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@328);
        make.height.equalTo(@81);
        make.centerX.equalTo(self.adImageView.mas_centerX);
        make.bottom.equalTo(self.adImageView.mas_bottom).offset(-36);
    }];

    [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(30.0f);
        } else {
            make.top.equalTo(self.view).offset(30.0f);
        }
        make.right.equalTo(self.view.mas_right).offset(-16*kScaleFactor);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(35);
    }];
}

- (BOOL)hiddenNavigation
{
    return YES;
}

- (void)closeLaunchAd
{
    [UIView transitionWithView:YDAppDelegate.adWindow duration:0.8 options:UIViewAnimationOptionTransitionNone animations:^{
        YDAppDelegate.adWindow.alpha = 0;
    } completion:^(BOOL finished) {
        [self remove];
    }];
}

- (void)tapImage
{
    [self.launchVM tapImage];
}

- (void)remove
{
    if(YDAppDelegate.adWindow){
        [YDAppDelegate.adWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
            obj = nil;

        }];
        YDAppDelegate.adWindow.hidden = YES;
        YDAppDelegate.adWindow = nil;
    }
}

#pragma mark - lazy
- (UIView *)bgView
{
    if (!_bgView) {
        UIViewController * vc = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        _bgView = vc.view;
    }
    return _bgView;
}

- (UIImageView *)adImageView
{
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc]init];
        _adImageView.userInteractionEnabled = YES;
        _adImageView.contentMode = UIViewContentModeScaleAspectFill;
        _adImageView.clipsToBounds = YES;
    }
    return _adImageView;
}

- (UIButton *)adBottomTipBtn
{
    if (!_adBottomTipBtn) {
        _adBottomTipBtn = [[UIButton alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
        [_adBottomTipBtn addGestureRecognizer:tap];
    }
    return _adBottomTipBtn;
}

- (UIButton *)skipBtn
{
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _skipBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _skipBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [_skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_skipBtn setTitle:@"跳过 4" forState:UIControlStateNormal];
        _skipBtn.layer.cornerRadius = 17;
        _skipBtn.layer.masksToBounds = YES;
        [_skipBtn addTarget:self action:@selector(closeLaunchAd) forControlEvents:UIControlEventTouchUpInside];
        _skipBtn.hidden = YES;
    }
    return _skipBtn;
}

- (YDLaunchScreenViewModel *)launchVM
{
    if (!_launchVM) {
        _launchVM = [YDLaunchScreenViewModel new];
    }
    return _launchVM;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
