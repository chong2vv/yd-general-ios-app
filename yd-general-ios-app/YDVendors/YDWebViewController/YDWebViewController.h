//
//  YDWebViewController.h
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/15.
//

#import <UIKit/UIKit.h>
#import "WKWebViewJavascriptBridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDWebViewController : UIViewController

@property (nonatomic, strong) NSString *urlString;
@property (strong, nonatomic ,readonly) WKWebView *webView;
@property (nonatomic, strong, readonly) WKWebViewJavascriptBridge *bridge;
@property (nonatomic, copy) NSString *outterLinkShareId;
@property (nonatomic, strong) NSDictionary *shareDic;


@end

NS_ASSUME_NONNULL_END
