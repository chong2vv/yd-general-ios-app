//
//  YDMediaPlayerManager.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/15.
//

#import "YDMediaPlayerManager.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFPlayerView.h>

#if __has_include(<KSYMediaPlayer/KSYMediaPlayer.h>)
#import <KSYMediaPlayer/KSYMediaPlayer.h>

static NSString *const kCurrentPlaybackTime = @"currentPlaybackTime";

@interface YDMediaPlayerManager () {
    ZFKVOController *_playerItemKVO;
}
@property (nonatomic, strong) KSYMoviePlayerController *player;

@end

@implementation YDMediaPlayerManager
@synthesize view                           = _view;
@synthesize currentTime                    = _currentTime;
@synthesize totalTime                      = _totalTime;
@synthesize playerPlayTimeChanged          = _playerPlayTimeChanged;
@synthesize playerBufferTimeChanged        = _playerBufferTimeChanged;
@synthesize playerDidToEnd                 = _playerDidToEnd;
@synthesize bufferTime                     = _bufferTime;
@synthesize playState                      = _playState;
@synthesize loadState                      = _loadState;
@synthesize assetURL                       = _assetURL;
@synthesize playerPrepareToPlay            = _playerPrepareToPlay;
@synthesize playerPlayStateChanged         = _playerPlayStateChanged;
@synthesize playerLoadStateChanged         = _playerLoadStateChanged;
@synthesize seekTime                       = _seekTime;
@synthesize muted                          = _muted;
@synthesize volume                         = _volume;
@synthesize presentationSize               = _presentationSize;
@synthesize isPlaying                      = _isPlaying;
@synthesize rate                           = _rate;
@synthesize isPreparedToPlay               = _isPreparedToPlay;
@synthesize scalingMode                    = _scalingMode;
@synthesize playerPlayFailed               = _playerPlayFailed;
@synthesize playerReadyToPlay              = _playerReadyToPlay;
@synthesize presentationSizeChanged        = _presentationSizeChanged;
@synthesize shouldAutoPlay                 = _shouldAutoPlay;


- (void)dealloc {
    [self destory];
}

- (void)destory {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_playerItemKVO safelyRemoveAllObservers];
    _isPlaying = NO;
    _isPreparedToPlay = NO;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _scalingMode = ZFPlayerScalingModeAspectFit;
    }
    return self;
}

- (void)prepareToPlay {
    if (!_assetURL) return;
    _isPreparedToPlay = YES;
    self.loadState = ZFPlayerLoadStatePrepare;
    [self initializePlayer];
    if (self.playerPrepareToPlay) self.playerPrepareToPlay(self, self.assetURL);
    [self.player prepareToPlay];
}

void StereoToMono(const int16_t* src_audio,int samples_per_channel,int16_t* dst_audio)
{
    
}

- (void)play {
    if (!_isPreparedToPlay) {
        [self prepareToPlay];
    } else {
        [self.player play];
        self.player.playbackSpeed = self.rate;
        _isPlaying = YES;
        self.playState = ZFPlayerPlayStatePlaying;
    }
}

- (void)pause {
    [self.player pause];
    _isPlaying = NO;
    self.playState = ZFPlayerPlayStatePaused;
}

- (void)stop {
    self.playState = ZFPlayerPlayStatePlayStopped;
    [self.player stop];
    [self.player.view removeFromSuperview];
    [self destory];
    self.player = nil;
    self->_currentTime = 0;
    self->_totalTime = 0;
    self->_bufferTime = 0;
}

- (void)replay {
    @weakify(self)
    [self seekToTime:0 completionHandler:^(BOOL finished) {
        @strongify(self)
        [self play];
    }];
}

/// 更换当前的播放地址
- (void)replaceCurrentAssetURL:(NSURL *)assetURL {
    if (self.player) [self stop];
    _assetURL = assetURL;
    [self prepareToPlay];
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler {
    [self.player seekTo:time accurate:YES];
    if (completionHandler) completionHandler(YES);
}

- (UIImage *)thumbnailImageAtCurrentTime {
    return [self.player thumbnailImageAtCurrentTime];
}

- (void)reloadPlayer {
    self.seekTime = self.currentTime;
    [self prepareToPlay];
}

- (void)initializePlayer {
    self.player = [[KSYMoviePlayerController alloc] initWithContentURL:_assetURL];
    self.player.shouldAutoplay = YES;
    [self addPlayerNotification];
    [self.player setTimeout:30 readTimeout:50];
    
    [self.view insertSubview:self.player.view atIndex:1];
    self.player.view.frame = self.view.bounds;
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scalingMode = _scalingMode;
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.audioDataBlock = ^(CMSampleBufferRef sampleBuffer) {
        AudioBufferList audioBufferList;
        NSMutableData *data = [NSMutableData data];
        CMBlockBufferRef blockBuffer;
        CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sampleBuffer,
                                                                NULL,
                                                                &audioBufferList,
                                                                sizeof(audioBufferList),
                                                                NULL, NULL, 0, &blockBuffer);
        for( int y=0; y< audioBufferList.mNumberBuffers; y++ ){
            AudioBuffer audioBuffer = audioBufferList.mBuffers[y];
            Float32 *frame = (Float32*)audioBuffer.mData;
            [data appendBytes:frame length:audioBuffer.mDataByteSize];
        }
        char * p = (char *)[data bytes];
//        [ArtRTCAudioPlayer pushAudioSource:p byteLength:data.length];
        CFRelease(blockBuffer);
    };
}

- (void)addPlayerNotification {
    /// 准备开始播放了
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoPrepared:)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:self.player];
    /// 播放状态改变
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.player];
    /// 播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.player];
    /// 缓冲状态改变了
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bufferChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:self.player];
    
    /// 视频的尺寸变化了
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sizeAvailableChange:)
                                                 name:MPMovieNaturalSizeAvailableNotification
                                               object:self.player];
    /// 当视频第一次渲染
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoFirstFrame:)
                                                 name:MPMoviePlayerFirstVideoFrameRenderedNotification
                                               object:self.player];
    /// 播放解码状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStatusChange:)
                                                 name:MPMoviePlayerPlaybackStatusNotification
                                               object:self.player];
    /// 快接、快退完成
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(seekDone:)
                                                 name:MPMoviePlayerSeekCompleteNotification
                                               object:self.player];
    
    /// 应该刷新url是够调用
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(suggestReloadChange:)
                                                 name:MPMoviePlayerSuggestReloadNotification
                                               object:self.player];
    
    [_playerItemKVO safelyRemoveAllObservers];
    _playerItemKVO = [[ZFKVOController alloc] initWithTarget:_player];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kCurrentPlaybackTime
                              options:NSKeyValueObservingOptionNew
                              context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([keyPath isEqualToString:kCurrentPlaybackTime]) {
            if (_playState == ZFPlayerPlayStatePlayStopped) {
                self->_currentTime = self.player.duration;
            } else {
                self->_currentTime = self.player.currentPlaybackTime;
            }
            self->_totalTime = self.player.duration;
            self->_bufferTime = self.player.playableDuration;
            if (self.playerPlayTimeChanged) self.playerPlayTimeChanged(self, self->_currentTime, self->_totalTime);
            if (self.playerBufferTimeChanged) self.playerBufferTimeChanged(self, self->_bufferTime);
            if (self->_playState == ZFPlayerPlayStatePlaying) {
                NSLog(@"---------- ppppplayyyyyyy ----------- ");
                
            }
        }
    });
}

#pragma mark - Notification

/// 播放器初始化视频文件完成通知
- (void)videoPrepared:(NSNotification *)notify {
    self.player.shouldMute = self.muted;
    if (self.seekTime) {
        [self seekToTime:self.seekTime completionHandler:nil];
        self.seekTime = 0; // 滞空, 防止下次播放出错
    }
    [self play];
    self.player.shouldMute = self.muted;
    NSDictionary *audioInfo = [self.player getMetadata:MPMovieMetaType_Audio];
    //NSLog(@"*** %@",audioInfo);
    /*
     stream_index = "1";
     channels = "1";
     channel_layout = "4";
     sample_rate = "48000";
     codec_name = "aac";
     type = "audio";
     bitrate = "63000";
     */
    NSInteger sampleRait = ((NSString *)audioInfo[@"sample_rate"]).integerValue;
//    [ArtRTCAudioPlayer updateExternalAudioSampleRait:(int)sampleRait];
    // 声道实际解码出来和源数据不同是2个
    // NSInteger channelCount = ((NSString *)audioInfo[@"channels"]).integerValue;
    // [ArtAgoraAudioProcessing updateExternalAudioChannelCount:1];
    
    /// 需要延迟改为ok状态，不然显示会有一点问题。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.playerReadyToPlay) {
            self.playerReadyToPlay(self, self.assetURL);
        }
        self.loadState = ZFPlayerLoadStatePlaythroughOK;
    });
}

/// 播放完成通知。视频正常播放完成时触发。
- (void)videoFinish:(NSNotification *)notify {
    NSInteger reason = [[notify.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    if (reason == MPMovieFinishReasonPlaybackEnded) {
        [self pause];
        self.playState = ZFPlayerPlayStatePlayStopped;
        if (self.playerDidToEnd) self.playerDidToEnd(self);
    } else if (reason == MPMovieFinishReasonPlaybackError) {
        self.playState = ZFPlayerPlayStatePlayFailed;
        NSString *error = [notify.userInfo valueForKey:@"error"];
        ZFPlayerLog(@"player Error : %@", error);
        if (self.playerPlayFailed) self.playerPlayFailed(self, error);
        NSString *des = [NSString stringWithFormat:@"player Error : %@", error];
//        ArtLogError(@"%@", des);
    } else if (reason == MPMovieFinishReasonUserExited){
        /// player userExited
    }
}

/// 播放器Seek完成后发送该通知。
- (void)seekDone:(NSNotification *)notify {
    [self play];
}

/// 视频的尺寸变化了
- (void)sizeAvailableChange:(NSNotification *)notify {
    // 如果想要在宽大于高的时候横屏播放，你可以在这里旋转
}

- (void)bufferChange:(NSNotification *)notify {
    if (self.player.loadState == MPMovieLoadStateStalled) { /// 播放器开始缓冲视频时发送该通知
        ZFPlayerLog(@"player start caching");
        self.loadState = ZFPlayerLoadStateStalled;
    } else {
        self.loadState = ZFPlayerLoadStatePlayable;
    }
}

/// 播放器首帧出现
- (void)videoFirstFrame:(NSNotification *)notify {
    if (_playState == ZFPlayerPlayStatePlaying) {
        
    }
}

/// 播放状态改变
- (void)playbackStateDidChange:(NSNotification *)notify {
    ZFPlayerLog(@"player playback state: %ld", (long)self.player.playbackState);
}

/// 播放解码状态
- (void)playbackStatusChange:(NSNotification *)notify {
    int status = [[[notify userInfo] valueForKey:MPMoviePlayerPlaybackStatusUserInfoKey] intValue];
    NSString *des = @"";
    if (MPMovieStatusVideoDecodeWrong == status) {
        ZFPlayerLog(@"Video Decode Wrong!\n");
        des = @"Video Decode Wrong!";
    } else if(MPMovieStatusAudioDecodeWrong == status) {
        ZFPlayerLog(@"Audio Decode Wrong!\n");
        des = @"Audio Decode Wrong!";
    } else if (MPMovieStatusHWCodecUsed == status ) {
        ZFPlayerLog(@"Hardware Codec used\n");
        des = @"Hardware Codec used";
    } else if (MPMovieStatusSWCodecUsed == status ) {
        ZFPlayerLog(@"Software Codec used\n");
        des = @"Software Codec used";
    } else if(MPMovieStatusDLCodecUsed == status) {
        ZFPlayerLog(@"AVSampleBufferDisplayLayer  Codec used");
        des = @"AVSampleBufferDisplayLayer  Codec used";
    }
//    ArtLogInfo(@"%@", des);
}

- (void)suggestReloadChange:(NSNotification *)notify {
    [self.player reload:self.assetURL];
}

#pragma mark - getter

- (ZFPlayerView *)view {
    if (!_view) {
        _view = [[ZFPlayerView alloc] init];
        _view.backgroundColor = [UIColor blackColor];
    }
    return _view;
}

- (float)rate {
    return _rate == 0 ?1:_rate;
}

#pragma mark - setter

- (void)setPlayState:(ZFPlayerPlaybackState)playState {
    _playState = playState;
    
    if (playState == ZFPlayerPlayStatePlaying) {
        NSLog(@"---------- ppppplayyyyyyy ----------- ");
    }
    
    if (self.playerPlayStateChanged) self.playerPlayStateChanged(self, playState);
}

- (void)setLoadState:(ZFPlayerLoadState)loadState {
    _loadState = loadState;
    if (self.playerLoadStateChanged) self.playerLoadStateChanged(self, loadState);
}

- (void)setAssetURL:(NSURL *)assetURL {
    _assetURL = assetURL;
    [self replaceCurrentAssetURL:assetURL];
}

- (void)setRate:(float)rate {
    _rate = rate;
    self.player.playbackSpeed = rate;
}

- (void)setMuted:(BOOL)muted {
    _muted = muted;
    self.player.shouldMute = muted;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ArtWorldPlayerMuteChange" object:nil];
}

- (void)setVolume:(float)volume {
    _volume = MIN(MAX(0, volume), 2);
    [self.player setVolume:volume rigthVolume:volume];
}

- (void)setScalingMode:(ZFPlayerScalingMode)scalingMode {
    _scalingMode = scalingMode;
    switch (scalingMode) {
        case ZFPlayerScalingModeNone:
            self.player.scalingMode = MPMovieScalingModeNone;
            break;
        case ZFPlayerScalingModeAspectFit:
            self.player.scalingMode = MPMovieScalingModeAspectFit;
            break;
        case ZFPlayerScalingModeAspectFill:
            self.player.scalingMode = MPMovieScalingModeAspectFill;
            break;
        case ZFPlayerScalingModeFill:
            self.player.scalingMode = MPMovieScalingModeFill;
            break;
        default:
            break;
    }
}

@end
#endif
