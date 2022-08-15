//
//  YDMediaPlayerManager.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/15.
//

#import <Foundation/Foundation.h>

#import <ZFPlayer/ZFPlayerMediaPlayback.h>

NS_ASSUME_NONNULL_BEGIN

#if __has_include(<KSYMediaPlayer/KSYMediaPlayer.h>)

@interface YDMediaPlayerManager : NSObject<ZFPlayerMediaPlayback>

@end
#endif
NS_ASSUME_NONNULL_END
