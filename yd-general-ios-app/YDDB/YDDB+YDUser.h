//
//  YDDB+YDUser.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/9.
//

#import "YDDB.h"
#import "YDUser.h"
NS_ASSUME_NONNULL_BEGIN

@interface YDDB (YDUser)

- (RACSignal *)insertWithUserModel:(YDUser *)user;

- (RACSignal *)selectUserWithUid:(NSString *)uid;

- (RACSignal *)deleteUserWithUid:(NSString *)uid;
@end

NS_ASSUME_NONNULL_END
