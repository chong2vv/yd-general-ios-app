//
//  YDUser.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/9.
//

#import "YDUser.h"

@implementation YDUser

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"uid" : @[@"id", @"ID", @"user_id", @"_id", @"uid"]};
}

@end
