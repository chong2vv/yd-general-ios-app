//
//  YDButton.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDButton : UIButton

- (RACSignal *)click;

@end

NS_ASSUME_NONNULL_END
