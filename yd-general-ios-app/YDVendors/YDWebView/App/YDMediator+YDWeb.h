//
//  YDMediator+YDWeb.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/18.
//

#import "YDMediator.h"


@interface YDMediator (YDWeb)

- (UIViewController *)startLinkerParams:(NSDictionary *)aParams
                   navigationController:(UINavigationController *)aNav;

- (UIViewController *)startLinkerParams:(NSDictionary *)aParams;

@end

