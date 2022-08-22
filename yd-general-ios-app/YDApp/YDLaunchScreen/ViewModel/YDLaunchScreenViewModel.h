//
//  YDLaunchScreenViewModel.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDLaunchScreenViewModel : NSObject
// 显示跳过
@property (nonatomic, assign, readonly) BOOL showSkip;
// 倒计时
@property (nonatomic, assign, readonly) NSTimeInterval countdownTime;
// 倒计时字符串
@property (nonatomic, strong, readonly) NSString *countdownString;
// 广告点击上报信号
@property (nonatomic, strong, readonly) RACSubject *adClickUploadSubject;
// 广告统计信号
@property (nonatomic, strong, readonly) RACSubject *adStatisticsSubject;
// 关闭广告信号
@property (nonatomic, strong, readonly) RACSubject *closeAdSubject;
// 广告显示信号
@property (nonatomic, strong, readonly) RACSubject *showAdImageSubject;
// 广告按钮显示信号
@property (nonatomic, strong, readonly) RACSubject *showAdTipBtnImageSubject;

- (void)tapImage;
@end

NS_ASSUME_NONNULL_END
