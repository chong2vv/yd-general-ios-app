//
//  YDViewReusePool.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//view的重用池
@interface YDViewReusePool : NSObject

//获取可重用的view
- (UIView *)dequeueResableView;
//添加新使用view
- (void)addUsingView:(UIView *)view;
//重置
- (void)reset;

@end

NS_ASSUME_NONNULL_END
