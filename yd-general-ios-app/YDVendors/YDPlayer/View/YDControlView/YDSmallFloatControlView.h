//
//  YDSmallFloatControlView.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDSmallFloatControlView : UIView

@property (nonatomic, copy, nullable) void(^closeClickCallback)(void);

@end

NS_ASSUME_NONNULL_END
