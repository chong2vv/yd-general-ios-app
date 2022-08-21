//
//  YDMediator+YDLogin.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/20.
//

#import "YDMediator.h"


@interface YDMediator (YDLogin)

- (UIViewController *)startLoginParams:(NSDictionary *)aParams
                   navigationController:(UINavigationController *)aNav;

- (UIViewController *)startLoginParams:(NSDictionary *)aParams;

@end
