//
//  YDLoginCommand.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/10.
//

#import "YDCommand.h"
#import "YDUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDLoginCommand : YDCommand

@property (nonatomic, copy)NSString *input_userAccount;
@property (nonatomic, copy)NSString *input_userPassword;
@property (nonatomic, copy)NSString *input_code;

@property (nonatomic, strong)YDUser *user;
@end

NS_ASSUME_NONNULL_END
