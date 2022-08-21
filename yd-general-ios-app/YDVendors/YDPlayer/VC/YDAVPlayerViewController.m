//
//  YDAVPlayerViewController.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/21.
//

#import "YDAVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <YDSVProgressHUD/YDProgressHUD.h>

@interface YDAVPlayerViewController ()

@property (nonatomic, copy) NSString *playUrl;

@end

@implementation YDAVPlayerViewController

- (instancetype) initWithContentURLString:(NSString *)contentUrl
{
    self = [super init];
    self.playUrl = contentUrl;
    [self configurePlayer];
    return self;
}

- (void)configurePlayer
{
    NSURL *url = nil;
    self.playUrl = [self.playUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (self.playUrl.length == 0) { // url 不能为空否则执行 initWithURL: 会出错
        //        NSAssert(NO, @"播放链接不能为空");
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self showErrorText:@"该视频不存在"];xwx
            [YDProgressHUD showErrorWithStatus:@"该视频不存在"];
        });
        return;
    }
    
    if ([self.playUrl rangeOfString:@"http"].length > 0) {
        url = [NSURL URLWithString:self.playUrl];
    } else {
        url = [NSURL fileURLWithPath:self.playUrl];
    }
    self.player = [[AVPlayer alloc] initWithURL:url];
}

- (UIViewController *)getRootViewController {
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (rootViewController.presentedViewController) {
        rootViewController = rootViewController.presentedViewController;
    }
    return rootViewController;
}

- (void)show
{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    UIViewController *vc = [self getRootViewController];
    [vc presentViewController:self animated:YES completion:^{
        [self.player play];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
