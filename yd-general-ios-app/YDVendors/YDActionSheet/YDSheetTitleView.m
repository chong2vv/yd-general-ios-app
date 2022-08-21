//
//  YDSheetTitleView.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/20.
//

#import "YDSheetTitleView.h"
#import "YDSheetButton.h"
@interface YDSheetTitleView()
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIView *bottomLine;
@end
@implementation YDSheetTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLbl];
        [self addSubview:self.bottomLine];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLbl.text = title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLbl.frame = self.bounds;
    _bottomLine.frame = CGRectMake(10, self.bounds.size.height - 0.5f, self.bounds.size.width - 20, 0.5f);
}

#pragma mark - lazy
- (UILabel *)titleLbl  {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.textColor = [UIColor sheet_colorWithRGBHex:0x666666];
    }
    return _titleLbl;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    }
    return _bottomLine;
}
@end

