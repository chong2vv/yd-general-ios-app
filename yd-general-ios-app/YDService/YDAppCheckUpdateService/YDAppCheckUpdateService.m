//
//  YDCheckUpdateService.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/15.
//

#import "YDAppCheckUpdateService.h"
#import "YDAppUpdateTostView.h"
#import "YDAppCheckUpdateCommand.h"

@interface YDAppCheckUpdateService ()

@end

@implementation YDAppCheckUpdateService


+ (void)checkAppUpdateOnVC:(UIViewController *)vc {
    [YDAppCheckUpdateCommand ydCommandSetParame:^(__kindof YDAppCheckUpdateCommand * _Nonnull request) {
            
        } completion:^(__kindof YDAppCheckUpdateCommand * _Nonnull request) {
            yd_dispatch_async_main_safe(^{
                if (request.error) {
                    YDLogError(@"检测app更新失败");
                    return;
                }
                if (request.updateStyle != YDAppUpdateStyleNoUpdate) {
                    YDAppUpdateTostView *view = [[YDAppUpdateTostView alloc] init];
                    [vc.view.window addSubview:view];
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(vc.view.window);
                    }];
                    [view showTitle:@"提示" content:@"请前往App Store更新" style:YDAppUpdateStyleNormal cancelAction:^{
                        [view removeFromSuperview];
                                        } confirmAction:^{
                                            //点击确认后跳转升级
                                            NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1142110895"];
                                               if (@available(iOS 10.0, *)){
                                                    [[UIApplication sharedApplication]openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:^(BOOL success) {
                                                        if (success) {
                                                            NSLog(@"10以后可以跳转url");
                                                        }else{
                                                            NSLog(@"10以后不可以跳转url");
                                                        }
                                                    }];
                                                }else{
                                                    BOOL success = [[UIApplication sharedApplication]openURL:url];
                                                    if (success) {
                                                         NSLog(@"10以前可以跳转url");
                                                    }else{
                                                         NSLog(@"10以前不可以跳转url");
                                                    }
                                                }
                                        }];
                }
            });
        }];
}

@end
