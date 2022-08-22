//
//  YDPlayerView.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/19.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayer.h>

NS_ASSUME_NONNULL_BEGIN
@protocol YDPlayerViewDelegate <NSObject>
@optional


@end


@interface YDPlayerView : UIView

@property (nonatomic, weak) id<YDPlayerViewDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END
