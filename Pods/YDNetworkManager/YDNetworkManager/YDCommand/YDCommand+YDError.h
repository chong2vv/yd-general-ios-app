//
//  YDCommand+YDError.h
//  YDNetworkManager
//
//  Created by wangyuandong on 2021/9/30.
//

#import "YDCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDCommand (YDError)

- (void)dealWithServiceErrorStatus:(NSInteger)aStatus userInfo:(NSDictionary *)aDic;

@end

NS_ASSUME_NONNULL_END
