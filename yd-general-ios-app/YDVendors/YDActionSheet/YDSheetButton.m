//
//  YDSheetButton.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/20.
//

#import "YDSheetButton.h"

@interface YDSheetButton ()
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, assign, readwrite) YDSheetButtonStyle style;
@property (nonatomic, nullable, strong, readwrite)void(^handler)(YDSheetButton *button);

@end

@implementation YDSheetButton

+ (instancetype)buttonWithTitle:(NSString *)title style:(YDSheetButtonStyle)style handler:(void (^)(UIButton * _Nonnull))handler {
    YDSheetButton * button = [YDSheetButton buttonWithType:UIButtonTypeSystem];
    button.handler = handler;
    button.style = style;
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [button setTitleColor:[UIColor sheet_colorWithRGBHex:0x333333] forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.clipsToBounds = YES;
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setupSubViews];
    }
    return self;
}


#pragma mark - add sbuviews
- (void)setupSubViews {
    [self addSubview:self.topLine];
    [self addSubview:self.bottomLine];
    self.topLine.hidden = _hidenTopLine;
    self.topLine.hidden = _hidenBottonLine;
}

-(void)setHidenTopLine:(BOOL)hidenTopLine {
    _hidenTopLine = hidenTopLine;
    self.topLine.hidden = hidenTopLine;
}
- (void)setHidenBottonLine:(BOOL)hidenBottonLine {
    _hidenBottonLine = hidenBottonLine;
    self.bottomLine.hidden = hidenBottonLine;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat topLineH = 0.5f;
    CGFloat bottomLineH = 0.5f;
    _topLine.frame = CGRectMake(0, 0, self.bounds.size.width, topLineH);
    _bottomLine.frame = CGRectMake(10, self.bounds.size.height - bottomLineH, self.bounds.size.width - 20, bottomLineH);
}

#pragma mark - lazy
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    }
    return _topLine;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    }
    return _bottomLine;
}
@end
@implementation UIColor (YDSheet)

+ (UIColor *)sheet_colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}
+ (UIColor *)sheet_colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                                                 green:g / 255.0f
                                                    blue:b / 255.0f
                                                 alpha:alpha];
}
@end
