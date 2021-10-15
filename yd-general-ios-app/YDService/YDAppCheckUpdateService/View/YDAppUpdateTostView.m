//
//  YDAppUpdateTostView.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/15.
//

#import "YDAppUpdateTostView.h"


@interface YDAppUpdateTostView ()

@property (nonatomic, strong)UIView *backgroundView;
@property (nonatomic, strong)UIImageView *tostBackgroundView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIButton *leftButton;
@property (nonatomic, strong)UIButton *rightButton;

@property (nonatomic, copy)YDConfirmActionBlock confirmAction;
@property (nonatomic, copy)YDCancelActionBlock cancelAction;

@end

@implementation YDAppUpdateTostView

- (instancetype)init {
    if ([super init]) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.backgroundView];
    [self addSubview:self.tostBackgroundView];
    [self.tostBackgroundView addSubview:self.titleLabel];
    [self.tostBackgroundView addSubview:self.contentLabel];
    [self.tostBackgroundView addSubview:self.leftButton];
    [self.tostBackgroundView addSubview:self.rightButton];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    CGFloat rat = 1;
    if (UI_IS_IPAD) {
        rat = 1.3;
    }else{
        rat = 1;
    }
    
    [self.tostBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(360 * rat);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tostBackgroundView).offset(16 * rat);
        make.left.equalTo(self.tostBackgroundView).offset(16 * rat);
        make.right.equalTo(self.tostBackgroundView).offset(-16 * rat);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
    }];
}

- (void)showTitle:(NSString *)title content:(NSString *)content style:(YDAppUpdateStyle)style cancelAction:(YDCancelActionBlock)cancelAction confirmAction:(YDConfirmActionBlock)confirmAction {
    self.cancelAction = cancelAction;
    self.confirmAction = confirmAction;
    
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    CGFloat rat = 1;
    if (UI_IS_IPAD) {
        rat = 1.3;
    }else{
        rat = 1;
    }
    
    CGFloat x = (360 * rat)/4.0;
    
    if (style == YDAppUpdateStyleNormal) {
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(40 * rat);
            make.bottom.equalTo(self.tostBackgroundView).offset(-16 *rat);
            make.centerX.equalTo(self.tostBackgroundView).offset(-x);
        }];
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(40 * rat);
            make.bottom.equalTo(self.tostBackgroundView).offset(-16 *rat);
            make.centerX.equalTo(self.tostBackgroundView).offset(x);
        }];
        
    }else if (style == YDAppUpdateStyleForce){
        self.leftButton.hidden = YES;
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(40 * rat);
            make.bottom.equalTo(self.tostBackgroundView).offset(-16 *rat);
            make.centerX.equalTo(self.tostBackgroundView);
        }];
    }
}

- (void)leftAction {
    if (self.cancelAction) {
        self.cancelAction();
    }
}

- (void)rightAction {
    if (self.confirmAction) {
        self.confirmAction();
    }
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.6;
    }
    return _backgroundView;
}

- (UIImageView *)tostBackgroundView {
    if (!_tostBackgroundView) {
        _tostBackgroundView = [[UIImageView alloc] init];
        _tostBackgroundView.userInteractionEnabled = YES;
        _tostBackgroundView.backgroundColor = [UIColor whiteColor];
        _tostBackgroundView.layer.cornerRadius = 8;
    }
    return _tostBackgroundView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [YDStyle fontBig];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [YDStyle fontNormal];
    }
    return _contentLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitle:@"确认" forState:UIControlStateNormal];
    }
    return _rightButton;
}

@end
