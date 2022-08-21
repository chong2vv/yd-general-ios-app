//
//  YDWebViewController.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/15.
//

#import "YDWebViewController.h"
#import <YDRouter/YDRouter.h>


static NSString *kOriginalUserAgent = @"kOriginalUserAgent";
static NSString *kArtInnerHost = @".yd.com";//包含这个字符串的链接认为是内部链接

@interface YDWebViewController ()<
WKNavigationDelegate,
WKUIDelegate,
WKScriptMessageHandler>


@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebView *tmpWebView;//只用来获取UA
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebViewJavascriptBridge* bridge;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, copy) NSString *headReferer;

@end

@implementation YDWebViewController

#pragma mark - Config Bridge
- (void)configBridge{
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
//    [_bridge setWebViewDelegate:self];
    
//    [self registerHandler];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    @weakify(self);
    [self fetchUserAgentComplete:^{
        @strongify(self);
        // After this point the web view will use a custom appended user agent
        //        self.webView.customUserAgent = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserAgent"];
        [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            NSLog(@"UA = %@", result);
        }];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            } else {
                make.top.equalTo(self.view);
                // Fallback on earlier versions
            }
            make.left.right.bottom.equalTo(self.view);
        }];
        
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.webView);
            make.height.equalTo(@2.);
        }];
        
        [self configBridge];
        [self loadRequest];
    }];
}

//MARK: UserAgent 处理
- (void)fetchUserAgentComplete:(void(^)(void))complete
{
    self.tmpWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
    [self.tmpWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(NSString *result, NSError *error) {
        NSString *queryStr = [[YDUserConfig shared] userAgent];
        NSString *newUserAgent = queryStr;
        if (result.length > 0) {
            //说明是原始ua，原始ua需要拼接queryStr信息
            if ([result rangeOfString:@"&"].length <= 0) {
                [[NSUserDefaults standardUserDefaults] setObject:result forKey:kOriginalUserAgent];
                newUserAgent = [NSString stringWithFormat:@"%@&oua=%@",queryStr,result];
            } else {
                //userid 为空或者userId 变化了，重新拼接UA
                if([result rangeOfString:[NSString stringWithFormat:@"userid=%@",YDUserConfig.shared.currentUserId]].length <= 0){
                    
                    NSString *oua = [[NSUserDefaults standardUserDefaults] objectForKey:kOriginalUserAgent];
                    newUserAgent = [NSString stringWithFormat:@"%@&oua=%@",queryStr,oua];
                    // userId 为空 重新拼接UA
                }else if (YDUserConfig.shared.currentUserId.length == 0){
                    NSString *oua = [[NSUserDefaults standardUserDefaults] objectForKey:kOriginalUserAgent];
                    newUserAgent = [NSString stringWithFormat:@"%@&oua=%@",queryStr,oua];
                } else {//防止无限拼接
                    newUserAgent = result;
                }
            }
        }
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.tmpWebView.customUserAgent = newUserAgent;
        self.webView.customUserAgent = newUserAgent;
        self.tmpWebView.configuration.applicationNameForUserAgent = newUserAgent;
        self.webView.configuration.applicationNameForUserAgent = newUserAgent;
        if ([NSThread currentThread].isMainThread) {
            complete();
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete();
            });
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
        barApp.backgroundColor = [UIColor whiteColor];
        barApp.shadowColor = [UIColor whiteColor];
        self.navigationController.navigationBar.scrollEdgeAppearance = barApp;
        self.navigationController.navigationBar.standardAppearance = barApp;
        //不透明
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [self storeLocalStorage];
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //开启H5调用系统播放器的横屏功能
//    app.allowLandscape = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isClosePopGesture == YES) {
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    
    self.didAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    app.allowLandscape = NO;
    if (self.isClosePopGesture == YES) {
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        };
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)dealloc {
    NSLog(@"%s",__func__);
    //恢复原始值
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
        [self removeObserver];
    } @catch (NSException *exception) {
        NSLog(@"name:%@ \n reason:%@",exception.name,exception.reason);
    }
}

- (void)removeObserver {

}

- (void)closeAction{
    UINavigationController *nav = self.navigationController;
    if ([self.webView canGoBack]) {
        [self goBackToFirstItemInHistory];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (nav.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

//返回到第一个界面
- (void)goBackToFirstItemInHistory{
    NSString *script = @"window.history.go(-(window.history.length - 1));";
    [self.webView evaluateJavaScript:script completionHandler:^(id aa, NSError * error) {
        NSLog(@"-----%@",[error localizedDescription]);
    }];
}

//MARK: 加载URL
- (void)reload {
    [self loadRequest];
    NSLog(@"%s",__func__);
}

- (void)loadRequest {
    [self loadRequestURlString:self.urlString];
}

- (void)loadRequestURlString:(NSString *)urlString {
    if (urlString == nil) {
        urlString = self.urlString;
    }
    self.webView.hidden = NO;
    self.tmpWebView.hidden = NO;
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if (IOS9) {
        //self.webView.customUserAgent = [ArtCommandConfig.shared getUserAgent];
    }else{
        [self addRequestHeader:request];
    }
    [self.webView loadRequest:request];
}

- (void)addRequestHeader:(NSMutableURLRequest *)request
{
    NSDictionary *dic = @{};
    NSMutableDictionary *headDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [headDic setObject:@"" forKey:@"useragent"];
    [headDic setObject:@"" forKey:@"User-Agent"];
    [headDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
}


- (void)storeLocalStorage
{
    if ([YDUserConfig shared].isLogin == YES) {
        WKUserContentController *userContent = self.webView.configuration.userContentController;
        NSString *tokenStr = [NSString stringWithFormat:@"localStorage.setItem('token', '%@')",YDUserConfig.shared.authorization];
        WKUserScript *tokenUserScript = [[WKUserScript alloc] initWithSource:tokenStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContent addUserScript:tokenUserScript];
        [self.webView evaluateJavaScript:tokenStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"增加localstorage token");
        }];
        
        NSString *userStr = [NSString stringWithFormat:@"localStorage.setItem('user', '%@')",YDUserConfig.shared.currentUserId];
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:userStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContent addUserScript:userScript];
        [self.webView evaluateJavaScript:userStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"增加localstorage user");
        }];
    } else {
        WKUserContentController *userContent = self.webView.configuration.userContentController;
        NSString *tokenStr = [NSString stringWithFormat:@"localStorage.removeItem('token')"];
        WKUserScript *tokenUserScript = [[WKUserScript alloc] initWithSource:tokenStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContent addUserScript:tokenUserScript];
        [self.webView evaluateJavaScript:tokenStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"移除localstorage token");
        }];
        
        NSString *userStr = [NSString stringWithFormat:@"localStorage.removeItem('user')"];
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:userStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContent addUserScript:userScript];
        [self.webView evaluateJavaScript:userStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"移除localstorage user");
        }];
    }
    
}


//MARK: 清除缓存
+ (void)clearCache
{
    //// Optional data
    NSSet *websiteDataTypes
    = [NSSet setWithArray:@[
        WKWebsiteDataTypeDiskCache,
        //                            WKWebsiteDataTypeOfflineWebApplicationCache,
        WKWebsiteDataTypeMemoryCache,
        //                            WKWebsiteDataTypeLocalStorage,
        //                            WKWebsiteDataTypeCookies,
        //                            WKWebsiteDataTypeSessionStorage,
        //                            WKWebsiteDataTypeIndexedDBDatabases,
        //                            WKWebsiteDataTypeWebSQLDatabases
    ]];
    //// All kinds of data
    //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    //// Date from
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    //// Execute
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        // Done
        yd_dispatch_async_main_safe(^{
            [YDProgressHUD showSuccessWithStatus:@"清除缓存"];
        });
    }];
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"%s",__func__);
    /*
     https://zhuanlan.zhihu.com/p/24990222
     如果 WKWebView 退出的时候，JS刚好执行了window.alert(), alert 框可能弹不出来，completionHandler 最后没有被执行，导致 crash；另一种情况是在 WKWebView 一打开，JS就执行window.alert()，这个时候由于 WKWebView 所在的 UIViewController 出现（push或present）的动画尚未结束，alert 框可能弹不出来，completionHandler 最后没有被执行，导致 crash
     */
    if (self.animated) {//push或present 动画结束前就弹alert的过滤掉
        completionHandler();
        self.animated = NO;
        return;
    }
    //bug fix <UIAlertController: 0x1233125d0>  on <ArtWebViewController: 0x123334980> which is already presenting (null)
    if ([self.presentedViewController isKindOfClass:[UIAlertController class]]) {
        completionHandler();
        return;
    }
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertView addAction:alertAction];
    
    if (webView) {
        [self presentViewController:alertView animated:YES completion:nil];
    } else {
        completionHandler();
    }
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    NSLog(@"createWebViewWithConfiguration");
    if (!navigationAction.targetFrame.isMainFrame) {
        self.urlString = navigationAction.request.URL.absoluteString;
        [self loadRequest];
    }
    return nil;
}

#pragma mark WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"#######===%s",__func__);
    //每次重新加载一个界面的时候先置空
    NSLog(@"leoliu:url = %@",webView.URL.absoluteString);
    // 所有外部h5 都显示分享按钮
    if ([webView.URL.absoluteString rangeOfString:kArtInnerHost].length > 0) {
        
    } else {
        
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"#######===%s",__func__);
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.webView.hidden = NO;
    self.tmpWebView.hidden = NO;
    NSLog(@"#######===%s; current url:%@; host = %@",__func__,webView.URL.absoluteString,webView.URL.host);
    //分享链接
//    self.shareUrl = webView.URL.absoluteString;
    if ([webView.URL.host rangeOfString:kArtInnerHost].length > 0) {
        
    } else {
        
    }
    // 禁用选中效果
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none'" completionHandler:nil];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none'" completionHandler:nil];
}

//- (NSString *)formatWebContent:(NSString *)webContent
//{
//    webContent = [webContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
//    webContent = [webContent stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    webContent = [webContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    webContent = [webContent stringByReplacingOccurrencesOfString:@" " withString:@""];
//    return webContent;
//}


// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error
{
    //    if (error.code == NSURLErrorCancelled) {
    //        return;
    //    }
    [self showErrorView:error];
}

- (void)showErrorView:(NSError *)error {
    [YDProgressHUD showErrorWithStatus:error.localizedDescription];
}

- (void)handleRetry {
    [self loadRequestURlString:self.webView.URL.absoluteString];
}


// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"#######===%s",__func__);
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"#######===%s",__func__);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"#######===%s",__func__);

    // 在这里拦截url请求，使用decisionHandler(WKNavigationActionPolicyCancel)驳回请求
    NSURL *url = navigationAction.request.URL;
    NSLog(@"host-----%@",url.host);
    UIApplication *app = [UIApplication sharedApplication];
    if (!navigationAction.targetFrame) {
        if ([app canOpenURL:url]) {
            [app openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    //允许跳转到 app store
    if ([url.scheme containsString:@"artworld"])
    {
        YDURLHelper *helper = [YDURLHelper URLWithString:url.absoluteString];
        if ([helper.host isEqualToString:@"yd.com"]) { // 右上角按钮处理
            NSDictionary *dict = helper.params;
            NSString *type = dict[@"type"];
            if ([type isEqualToString:@"showMailOrderButton"]) {
                // 二期暂时隐藏 商城订单 入口
//                if ([ArtConfig shared].iosPublish == NO) {
//                BOOL show = [dict[@"show"] boolValue];
//                if (show) {
//                    NSString *pushUrl = dict[@"url"];
//                    [self configRightBarWithJumpUrl:[pushUrl stringByRemovingPercentEncoding] btnTitle:@"商城订单"];
//                } else {
//                    self.navigationItem.rightBarButtonItem = nil;
//                }
//                }
            } else if ([type.lowercaseString isEqualToString:@"orderbrowsing"]) {
                NSInteger tag = [dict[@"tag"] integerValue];
                // 0全部 1、2、3、4
                
                
            } else if ([type.lowercaseString isEqualToString:@"open"]) {
                NSString * page = dict[@"page"];
                
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    //允许跳转到 app store
    if ([url.scheme isEqualToString:@"itms-appss"])
    {
        if ([app canOpenURL:url])
        {
            [app openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    //允许打电话
    if ([url.scheme isEqualToString:@"tel"])
    {
        if ([app canOpenURL:url])
        {
            [app openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    //  先判断一下，找到需要跳转的再做处理
    if ([navigationAction.request.URL.scheme isEqualToString:@"alipay"]) {
          //  1.以？号来切割字符串
          NSArray * urlBaseArr = [navigationAction.request.URL.absoluteString componentsSeparatedByString:@"?"];
          NSString * urlBaseStr = urlBaseArr.firstObject;
          NSString * urlNeedDecode = urlBaseArr.lastObject;
          //  2.将截取以后的Str，做一下URLDecode，方便我们处理数据
          NSMutableString * afterDecodeStr = [NSMutableString stringWithString:[urlNeedDecode stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
          //  3.替换里面的默认Scheme为自己的Scheme
          NSString * afterHandleStr = [afterDecodeStr stringByReplacingOccurrencesOfString:@"alipays" withString:@"yd"];
          //  4.然后把处理后的，和最开始切割的做下拼接，就得到了最终的字符串
          NSString * finalStr = [NSString stringWithFormat:@"%@?%@",urlBaseStr,[afterHandleStr stringByRemovingPercentEncoding]];
          
          
//          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              //  判断一下，是否安装了支付宝APP（也就是看看能不能打开这个URL）
              if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:finalStr]]) {
                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalStr]];
              }
//          });
          
          //  2.这里告诉页面不走了 -_-
          decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    

    NSURLRequest *request = navigationAction.request;
    NSString *absoluteString = navigationAction.request.URL.absoluteString;
//    NSString *backSchemer = @"activity-1.m.duiba.com.cn";
//    NSString *backSchemer = @"test121.meishubao.com";

    if ([absoluteString hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"] &&
        [absoluteString containsString:[NSString stringWithFormat:@"redirect_url=%@",@"http"]]) {
        if ([absoluteString containsString:@"redirect_url="]) {
            NSRange redirectRange = [absoluteString rangeOfString:@"redirect_url="];
            NSString *redirectStr = [absoluteString substringFromIndex:redirectRange.location+redirectRange.length];
            NSURL *url = [NSURL URLWithString:[redirectStr stringByRemovingPercentEncoding]];
        }
    }
    
        // 拦截WKWebView加载的微信支付统一下单链接, 将redirect_url参数修改为唤起自己App的URLScheme
        if ([absoluteString hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"] &&
            ![absoluteString containsString:[NSString stringWithFormat:@"redirect_url=%@",self.headReferer]]&&
            [absoluteString containsString:@"redirect_url="]) {
            decisionHandler(WKNavigationActionPolicyCancel);
            NSString *redirectUrl = nil;
            if ([absoluteString containsString:@"redirect_url="]) {
                NSRange redirectRange = [absoluteString rangeOfString:@"redirect_url="];
                NSString *redirectStr = [absoluteString substringFromIndex:redirectRange.location+redirectRange.length];
                if ([redirectStr containsString:@"https"]) {
                    NSRange httpRange = [redirectStr rangeOfString:@"https"];
                    redirectStr = [redirectStr substringFromIndex:httpRange.location + httpRange.length];
                    redirectStr = [self.headReferer stringByAppendingString:redirectStr];
                } else if ([redirectStr containsString:@"http"]) {
                    NSRange httpRange = [redirectStr rangeOfString:@"http"];
                    redirectStr = [redirectStr substringFromIndex:httpRange.location + httpRange.length];
                    redirectStr = [self.headReferer stringByAppendingString:redirectStr];
                }
                redirectUrl = [[[absoluteString substringToIndex:redirectRange.location] stringByAppendingString:@"redirect_url="] stringByAppendingString:redirectStr];
 
                NSLog(@"redirectUrl = %@",redirectUrl);
                NSLog(@"encodedString = %@",redirectStr);

            } else {
    //            redirectUrl = [absoluteString stringByAppendingString:[NSString stringWithFormat:@"redirect_url=activity-1.m.duiba.com.cn://"]];
            }
            NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
            newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
            newRequest.URL = [NSURL URLWithString:redirectUrl];
            [newRequest setValue:self.headReferer forHTTPHeaderField:@"Referer"];
            [webView loadRequest:newRequest];
            return;
        }
        else if([absoluteString hasPrefix:[self.headReferer stringByAppendingString:@"://"]]){
            decisionHandler(WKNavigationActionPolicyCancel);
                    NSString *redirectUrl = nil;
                    if ([absoluteString containsString:[self.headReferer stringByAppendingString:@"://"]]) {
                        NSRange redirectRange = [absoluteString rangeOfString:[self.headReferer stringByAppendingString:@"://"]];
                        NSString *redirectStr = [absoluteString substringFromIndex:redirectRange.location+redirectRange.length];

                        redirectUrl = [@"https://" stringByAppendingString:redirectStr];
                    } else {
            //            redirectUrl = [absoluteString stringByAppendingString:[NSString stringWithFormat:@"redirect_url=activity-1.m.duiba.com.cn://"]];
                    }
                    NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
                    newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
                    newRequest.URL = [NSURL URLWithString:redirectUrl];
                    [webView loadRequest:newRequest];
                    return;
        }

    if ([url.scheme isEqualToString:@"weixin"]) {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    if (![url.scheme hasPrefix:@"http"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);

}

#pragma mark: WKWebView的https配置
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    } else {
        //        NSURLSessionAuthChallengeUseCredential = 0,                   使用证书
        //        NSURLSessionAuthChallengePerformDefaultHandling = 1,          忽略证书(默认的处理方式)
        //        NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2,   忽略书证, 并取消这次请求
        //        NSURLSessionAuthChallengeRejectProtectionSpace = 3,      拒绝当前这一次, 下一次再询问
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling,nil);
    }
}

#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"%s",__func__);
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.animated = NO;
}

#pragma mark - lazy load
- (WKWebView *)webView
{
    if(!_webView){
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [WKUserContentController new];
        configuration.allowsPictureInPictureMediaPlayback = NO;
        configuration.allowsInlineMediaPlayback=true;   //直播的视频播放 设置这个属性可以避免播放的时候使用系统播放器
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.javaScriptEnabled = YES;
        configuration.preferences = preferences;
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.bounces = NO;
        [self.view addSubview:_webView];
        
        if (IOS11OrLater) {
            // 智齿网页 键盘收缩会导致 不能再次弹起 所以注释下面这行
//            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _webView;
}

- (UIProgressView *)progressView
{
    if(!_progressView){
        _progressView = [[UIProgressView alloc]init];
        CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 2)];
        _progressView.tintColor = [UIColor colorWithHexString:@"24b7ed"];
        _progressView.trackTintColor = [UIColor whiteColor];
        _progressView.hidden = YES;
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)*0.6, 40.)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:18.];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleView addSubview:_titleLabel];
        _titleLabel.center = CGPointMake(self.titleView.bounds.size.width / 2., self.titleView.bounds.size.height / 2.);
    }
    return _titleLabel;
}

- (UIView *)titleView
{
    if(!_titleView){
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)*0.6, 40.)];
#ifdef DEBUG
        [_titleView whenFiveTapped:^{
            [YDWebViewController clearCache];
        }];
#endif
    }
    return _titleView;
}
@end
