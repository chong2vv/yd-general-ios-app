//
//  YDWebViewController.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/15.
//

#import "YDWebViewController.h"

@interface YDWebViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebView *tmpWebView;//只用来获取UA
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebViewJavascriptBridge* bridge;


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
    // Do any additional setup after loading the view.
}

//MARK: 加载URL
- (void)reload{
    [self loadRequest];
    NSLog(@"%s",__func__);
}

- (void)loadRequest{
    [self loadRequestURlString:self.urlString];
}

- (void)loadRequestURlString:(NSString *)urlString{
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
