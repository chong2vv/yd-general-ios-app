//
//  YDTestViewController.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/9/29.
//

#import "YDTestViewController.h"

@interface YDTestViewController ()

@property (nonatomic, strong) UIImageView *downloadImageView;


@end

@implementation YDTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"测试专用";
    
    UIButton *bt1 = [UIButton buttonWithType:UIButtonTypeSystem];
    
}

- (void)downloadImage {
    
}

- (UIImageView *)downloadImageView {
    if (!_downloadImageView) {
        _downloadImageView = [[UIImageView alloc] init];
    }
    return _downloadImageView;
}

@end
