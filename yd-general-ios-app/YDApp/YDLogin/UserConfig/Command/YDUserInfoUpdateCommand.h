//
//  YDUserInfoUpdateCommand.h
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/14.
//

#import "YDCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDUserInfoUpdateCommand : YDCommand

@property (nonatomic, copy)NSString *input_uid;
@property (nonatomic, copy)NSString *input_user;

@property (nonatomic, strong)YDUser *user;
@end

NS_ASSUME_NONNULL_END
