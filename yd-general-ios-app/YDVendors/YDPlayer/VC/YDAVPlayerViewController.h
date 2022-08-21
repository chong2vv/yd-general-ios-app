//
//  YDAVPlayerViewController.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/21.
//

#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDAVPlayerViewController : AVPlayerViewController

- (instancetype) initWithContentURLString:(NSString *)contentUrl;

- (void)show;

@end

NS_ASSUME_NONNULL_END
