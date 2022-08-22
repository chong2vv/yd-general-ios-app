//
//  YDSpeedLoadingView.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/22.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFLoadingView.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDSpeedLoadingView : UIView

@property (nonatomic, strong) ZFLoadingView *loadingView;

@property (nonatomic, strong) UILabel *speedTextLabel;

/**
 *  Starts animation of the spinner.
 */
- (void)startAnimating;

/**
 *  Stops animation of the spinnner.
 */
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
