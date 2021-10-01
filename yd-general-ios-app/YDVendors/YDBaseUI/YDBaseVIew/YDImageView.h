//
//  YDImageView.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDImageView : UIView

@property (nonatomic, strong) UIImageView *imageView;

//初始化
- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImageView:(UIImageView *)imageView;
- (instancetype)initWithImageWebUrl:(NSString *)webUrl;
- (instancetype)initWithImageWebUrl:(NSString *)webUrl placeholderImage:(UIImage *)placeholderImage;

//更新
- (void)updateWithImage:(UIImage *)image;
- (void)updateWithImageView:(UIImageView *)imageView;
- (void)updateWithImageWebUrl:(NSString *)webUrl;
- (void)updateWithImageWebUrl:(NSString *)webUrl placeholderImage:(UIImage *)placeholderImage;

@end

NS_ASSUME_NONNULL_END
