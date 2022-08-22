//
//  YDLaunchScreenViewModel.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/22.
//

#import "YDLaunchScreenViewModel.h"
#import "YDLaunchScreenModel.h"

@interface YDLaunchScreenViewModel ()
{
    NSTimeInterval _duration; // 广告持续时间
    NSTimeInterval _delayTime; //页面无数据等待时间
}

// 当前需要展示的广告
@property (nonatomic, strong) YDLaunchScreenModel *startPage;
// 显示跳过
@property (nonatomic, assign, readwrite) BOOL showSkip;
//广告视图
@property (nonatomic, strong) UIImage *adImage;
// 底部按钮视图
@property (nonatomic, strong) UIImage *adTipButtomImage;
// 倒计时
@property (nonatomic, assign, readwrite) NSTimeInterval countdownTime;
// 倒计时字符串
@property (nonatomic, strong, readwrite) NSString *countdownString;
// 广告点击上报信号
@property (nonatomic, strong, readwrite) RACSubject *adClickUploadSubject;
// 广告统计信号
@property (nonatomic, strong, readwrite) RACSubject *adStatisticsSubject;
// 关闭广告信号
@property (nonatomic, strong, readwrite) RACSubject *closeAdSubject;
// 广告显示信号
@property (nonatomic, strong, readwrite) RACSubject *showAdImageSubject;
// 广告按钮显示信号
@property (nonatomic, strong, readwrite) RACSubject *showAdTipBtnImageSubject;

@property (nonatomic, strong) RACDisposable *delayDisposable;
@end

@implementation YDLaunchScreenViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _duration = 3;
        _delayTime = 4;
        
        @weakify(self)
        // 启动页广告通知
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"kYDLaunchNotification" object:nil] subscribeNext:^(NSNotification *x) {
            @strongify(self)
            
//            self.startPage = [self currentStartPage];
            [self loadAdImage];
        }];
        
        self.delayDisposable = [[[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] take:_delayTime] subscribeNext:^(id x) {
            @strongify(self)
            self->_delayTime--;
            NSLog(@"%f秒后关闭启动页", self->_delayTime);
            
            if (self.adImage) {
                NSLog(@"开始展示启动页广告图");
                [self.delayDisposable dispose];
                // 开始展示广告图
                self.showSkip = YES;
                [self addGuideTimer];
                [self.showAdImageSubject sendNext:self.adImage];
                [self.showAdTipBtnImageSubject sendNext:self.adTipButtomImage];
            }
            
            // 当延迟倒计时计时完成的时候仍然没有下载到广告视图，则关闭当前控制器
            if (self->_delayTime <= 0) {
                [self.delayDisposable dispose];
                [self.closeAdSubject sendNext:@(YES)];
            }
            
        }];
        
    }
    return self;
}

// 下载广告图
- (void)loadAdImage
{
    
    NSString *imageUrl = self.startPage.imageUrl;
    NSLog(@"开屏广告url%@",imageUrl);
    @weakify(self)
    [[YDImageService shared] downloadImageWithURL:imageUrl completed:^(UIImage *image, NSError *error) {
        @strongify(self)
        if (image) {
            NSLog(@"开屏广告下载成功");
            self.adImage = image;
            
        } else {
            NSLog(@"开屏广告下载失败 %@",error.localizedDescription);
        }
    }];
    
    if (![self.startPage.buttonImage isEmpty]) {
        [[YDImageService shared] downloadImageWithURL:self.startPage.buttonImage completed:^(UIImage *image, NSError *error) {
            @strongify(self)
            if (image) {
                self.adTipButtomImage = image;
            } else {
                NSLog(@"开屏广告底部视图下载失败 %@",error.localizedDescription);
            }
        }];
    }
    
}

// 广告图片点击
- (void)tapImage
{
    NSString *openUrl;
    if (UI_IS_IPAD) {
        openUrl = @"";
    }else{
        openUrl = @"";
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LAUNCHSCREEN_AD_DID_CLICK" object:nil];
    if (openUrl.length > 0) {
        [self.adClickUploadSubject sendNext:openUrl];
    }
    [self.closeAdSubject sendNext:@(YES)];
}


// 添加倒计时
-(void)addGuideTimer
{
    @weakify(self)
    [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] take:_duration] subscribeNext:^(id x) {
        @strongify(self)
        if (self) {
            self->_duration--;
            if (self->_duration <= 0) [self.closeAdSubject sendNext:@(YES)];
            self.countdownString = [NSString stringWithFormat:@"跳过 %ld ",(long)self->_duration];
        }
    }];
}

#pragma mark - lazy
- (NSString *)countdownString
{
    if (!_countdownString) {
        return [NSString stringWithFormat:@"跳过 %ld ",(long)self->_duration];
    }
    return _countdownString;
}
- (RACSubject *)adClickUploadSubject
{
    if (!_adClickUploadSubject) {
        _adClickUploadSubject = [RACSubject subject];
    }
    return _adClickUploadSubject;
}
- (RACSubject *)closeAdSubject
{
    if (!_closeAdSubject) {
        _closeAdSubject = [RACSubject subject];
    }
    return _closeAdSubject;
}
- (RACSubject *)showAdImageSubject
{
    if (!_showAdImageSubject) {
        _showAdImageSubject = [RACSubject subject];
    }
    return _showAdImageSubject;
}

- (RACSubject *)showAdTipBtnImageSubject
{
    if (!_showAdTipBtnImageSubject) {
        _showAdTipBtnImageSubject = [RACSubject subject];
    }
    return _showAdTipBtnImageSubject;
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
