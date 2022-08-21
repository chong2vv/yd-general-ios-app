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
- (void)playerEndOperating;
- (void)postPlayerObserverInterval:(CGFloat)interval;
- (void)playerStatusChange:(ZFPlayerPlaybackState)status;
- (void)playerLoadStatusChange:(ZFPlayerLoadState)status;

- (void)playerOrientationWillChange:(ZFPlayerController *)player isFullScreen:(BOOL)isFullScreen;

- (void)playerOrientationDidChanged:(ZFPlayerController *)player isFullScreen:(BOOL)isFullScreen;
@end


@interface YDPlayerView : UIView

@property (nonatomic, weak) id<YDPlayerViewDelegate>  delegate;
@property (nonatomic, assign, readonly) CGFloat totalTime;
@property (nonatomic, assign, readonly) CGFloat currentTime;

@property (nonatomic, assign, readonly) BOOL muted;

@property (nonatomic, assign) BOOL isPlaying;

- (void)recivedNewVideoUrl:(NSURL *)url startTime:(CGFloat)seconds totalTime:(CGFloat)totalTime coverURLString:( NSString *)coverUrlString;
- (void)play;
- (void)pause;
- (void)stop;
- (void)reloadPlayer;
- (void)setMuted:(BOOL)muted;
- (void)seekToTime:(CGFloat)interval isPlay:(BOOL)isPlay;
- (void)seekToTime:(CGFloat)interval complete:(void (^)(BOOL finished))complete;
- (void)enterFullScreen:(BOOL) isFull;

@end

NS_ASSUME_NONNULL_END
