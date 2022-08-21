//
//  YDAppLogin.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/20.
//

#import "YDAppLogin.h"
#import "YDLoginViewController.h"
#import "YDLoginConfig.h"

@implementation YDAppLogin

- (UIViewController *)startLoginAppWithParams:(NSDictionary *)aParams {
    YDLoginViewController *vc = [[YDLoginViewController alloc] init];
    
    if (![[aParams objectForKey:kSuccessCallback] isEmpty]) {
        vc.successCallback = [aParams objectForKey:kSuccessCallback];
    }
    
    if (![[aParams objectForKey:@"showViewController"] isEmpty]) {
        UIViewController *currentVC = [aParams objectForKey:@"showViewController"];
        [currentVC presentViewController:vc animated:YES completion:nil];
    }
    
    return vc;
}

@end
