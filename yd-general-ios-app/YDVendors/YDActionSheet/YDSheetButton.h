//
//  YDSheetButton.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YDSheetButtonStyle) {
    YDSheetButtonStyleDefault = 0,
    YDSheetButtonStyleCancel,
};

@interface YDSheetButton : UIButton

@property (nonatomic, assign, readonly) YDSheetButtonStyle style;
@property (nonatomic, assign) BOOL hidenTopLine;
@property (nonatomic, assign) BOOL hidenBottonLine;
@property (nonatomic, nullable, strong, readonly) void (^handler)(YDSheetButton * button);
+ (instancetype)buttonWithTitle:(NSString *)title style:(YDSheetButtonStyle)style handler:(void (^)(UIButton * _Nonnull))handler;
@end

@interface UIColor (YDSheet)
+ (UIColor *)sheet_colorWithRGBHex:(UInt32)hex;
+ (UIColor *)sheet_colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
