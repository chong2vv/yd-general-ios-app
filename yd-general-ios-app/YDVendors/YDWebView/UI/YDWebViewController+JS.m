//
//  YDWebViewController+JS.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/18.
//

#import "YDWebViewController+JS.h"
#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@implementation YDWebViewController (JS)

- (void)registerHandler
{
    WEAKSELF(weakSelf);
    
//    //显示分享
//    [self.bridge registerHandler:@"showShare" handler:^(NSDictionary *aData, WVJBResponseCallback responseCallback) {
//        NSDictionary* params = [aData objectForKey:@"params"];
//        [weakSelf showShareAction:params];
//    }];
//    
//    // 注册获取图片
//    [self.bridge registerHandler:@"getImage" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [weakSelf getImageFromPicture];
//    }];
//    
//    [self.bridge registerHandler:@"showFullScreenPicture" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
//        [weakSelf showWebBigImage:data[@"params"]];
//    }];
//    
//    //关闭webview
//    [self.bridge registerHandler:@"closeWebview" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [weakSelf closeAction];
//    }];
//    // h5调用原生播放视频
//    [self.bridge registerHandler:@"playVideoWithNative" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [weakSelf playVideoWithNative: data[@"params"]];
//    }];
//    
//    // 跳转到首页
//    [self.bridge registerHandler:@"jumpNewHome" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [weakSelf openjumpNewHome:data[@"params"]];
//    }];
//    
//    //重置返回按钮，直接关闭webview
//    [self.bridge registerHandler:@"resetBackActionToCloseWebView" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
//        weakSelf.isClose = YES;
//    }];
}

@end
