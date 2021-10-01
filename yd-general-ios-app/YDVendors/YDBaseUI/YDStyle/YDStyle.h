//
//  YDStyle.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDStyle : NSObject

//UIFont
+ (UIFont *)fontHuge;
+ (UIFont *)fontBig;
+ (UIFont *)fontNormal;
+ (UIFont *)fontSmall;

//UIColor
+ (UIColor *)colorBlackLightAlpha;
+ (UIColor *)colorBlack;
+ (UIColor *)colorGrayLight;
+ (UIColor *)colorGrayDark;
+ (UIColor *)colorOrangeLight;
+ (UIColor *)colorPaperDark;
+ (UIColor *)colorPaperLight;
+ (UIColor *)colorPaperBlack;
+ (UIColor *)colorPaperGray;

//CGFloat
+ (CGFloat)floatScreenWidth;                  //屏幕宽
+ (CGFloat)floatScreenHeight;                 //屏幕高
+ (CGFloat)floatMarginMassive;                //视图间距大
+ (CGFloat)floatMarginNormal;                 //视图间距正常
+ (CGFloat)floatMarginMinor;                  //视图间距小
+ (CGFloat)floatTextIntervalHorizontal;       //横向字之间的间隔
+ (CGFloat)floatTextIntervalVertical;         //纵向字之间的间隔
+ (CGFloat)floatIconNormal;                   //Icon边距

@end

NS_ASSUME_NONNULL_END
