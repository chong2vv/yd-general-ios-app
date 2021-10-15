//
//  YDAppCheckUpdateCommand.h
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/15.
//

#import "YDCommand.h"
#import "YDAppUpdateTostView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YDAppCheckUpdateCommand : YDCommand

@property (nonatomic, assign)YDAppUpdateStyle updateStyle;

@end

NS_ASSUME_NONNULL_END
