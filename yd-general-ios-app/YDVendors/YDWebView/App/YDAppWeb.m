//
//  YDAppWeb.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/18.
//

#import "YDAppWeb.h"
#import "YDWebConfig.h"
#import "YDWebViewController.h"
#import "YDWebViewController+JS.h"
#import "YDMiniProService.h"
#import <YDRouter/YDRouter.h>

typedef NS_ENUM(NSInteger, EYDAPPLinkType) {
    EYDAPPLinkTypeWebUrl,        //跳转webview
    EYDAPPLinkTypeMiniPro,        //唤醒小程序
    EYDAPPLinkTypeVc,           //内部VC
};

@implementation YDAppWeb

- (UIViewController *)startWebAppWithParams:(NSDictionary *)aParams{
    NSString *linkUrl = aParams[kLinkUrl];
    EYDAPPLinkType type = [self linkTypeWithUrl:linkUrl];
    self.navigationController = [aParams objectForKey:@"nav"];
    UIViewController *vc = nil;
    switch (type) {
        case EYDAPPLinkTypeWebUrl:
            if ([self checkLoginWithUrl:aParams[kLinkUrl]]) { // 判断需要登录的先弹出登录
                
            }
            vc = [self presentWebURL:aParams];
            
            break;
        case EYDAPPLinkTypeMiniPro:
            //唤醒小程序
        {
            CGFloat delay = 0;
            if ([aParams.allKeys containsObject:kDelayLaunch]) {
                delay = [aParams[kDelayLaunch] floatValue];
            }
            [YDMiniProService launchMiniProWithUrl:linkUrl delay:delay];
        }
        case EYDAPPLinkTypeVc:
        {
            [self pushToVc:linkUrl];
        }
        default:
            break;
    }
    return vc;
}

// url 会拼接 islogin 参数
- (BOOL)checkLoginWithUrl:(NSString *)str{
    YDURLHelper *urlHelper = [YDURLHelper URLWithString:str];
    if ([[urlHelper.params objectForKey:@"islogin"] integerValue] == 1) {
        return YES;
    }
    return NO;
}

- (UIViewController *)presentWebURL:(NSDictionary *)aParams{
    //相同链接 不做重复跳转
    NSString *url = aParams[kLinkUrl];
    
    self.navigationController = [aParams objectForKey:@"nav"];
    if ([self isRepeatUrlTo:url]) {return nil;}
    YDWebViewController *vc = [[YDWebViewController alloc] init];
    vc.urlString = url;
    vc.hidesBottomBarWhenPushed = YES;
    [self showViewController:vc showType:[aParams[kVcShowType] integerValue] animated:YES completion:nil];
    return vc;
}

// 目前只能跳转到
- (void)pushToVc:(NSString *)linkUrl
{
    YDURLHelper *urlHelper = [YDURLHelper URLWithString:linkUrl];
    if (urlHelper.host && [urlHelper.host.lowercaseString isEqualToString:@"chong2vv.com"]) {
        UIViewController *vc = nil;
        if ([urlHelper.path.lowercaseString containsString:@"other_page"]) {
            
        }else {
//            [UIViewController showText:[NSString stringWithFormat:@"错误跳转%@",linkUrl]];
            
        }
        if (vc) {
            [self showViewController:vc showType:EYDMediatorShowTypePush animated:YES completion:nil];
        }

    }
}

- (BOOL)isRepeatUrlTo:(NSString *)url{
    __block BOOL isEqualUrl = NO;
    if ([self.navigationController.topViewController isKindOfClass:[YDWebViewController class]]) {
        YDWebViewController *vc = (YDWebViewController *)self.navigationController.topViewController;
        isEqualUrl = url.length > 0 && [vc.urlString isEqualToString:url];
        return isEqualUrl;
    } else {
        return isEqualUrl;
    }
}

//过滤url,判断类型
- (EYDAPPLinkType)linkTypeWithUrl:(NSString *)url{
    NSURL *aurl = [NSURL URLWithString:url];
    if ([aurl.scheme.lowercaseString isEqualToString:@"minipro"]) {
        return EYDAPPLinkTypeMiniPro;
    } else if ([aurl.scheme.lowercaseString isEqualToString:@"ydapp"]) {
        return EYDAPPLinkTypeVc;
    }
    return EYDAPPLinkTypeWebUrl;
}

@end
