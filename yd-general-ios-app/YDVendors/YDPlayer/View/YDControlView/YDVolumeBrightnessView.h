//
//  YDVolumeBrightnessView.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/22.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFVolumeBrightnessView.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDVolumeBrightnessView : UIView

@property (nonatomic, assign, readonly) ZFVolumeBrightnessType volumeBrightnessType;
@property (nonatomic, strong, readonly) UIProgressView *progressView;
@property (nonatomic, strong, readonly) UIImageView *iconImageView;

- (void)updateProgress:(CGFloat)progress withVolumeBrightnessType:(ZFVolumeBrightnessType)volumeBrightnessType;

/// 添加系统音量view
- (void)addSystemVolumeView;

/// 移除系统音量view
- (void)removeSystemVolumeView;
@end

NS_ASSUME_NONNULL_END
