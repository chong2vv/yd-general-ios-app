//
//  YDEmptyView.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/23.
//

#import "YDEmptyView.h"
#import "YDEmptyViewConfig.h"

@interface YDEmptyView ()

@property (nonatomic, strong) UIImageView *cartoonImageView;

@property (nonatomic, strong) UIButton *tipBtn;
@property (nonatomic, strong) UIButton *subTipBtn;

@property (nonatomic,   copy) NSString *imageName;
@property (nonatomic, strong) NSString *tipTitle;
@property (nonatomic,   copy) NSString *tipBtnTitle;
@property (nonatomic,   copy) NSString *subTipBtnTitle;
@property (nonatomic, strong) NSAttributedString *tipAttributedTitle;
@property (nonatomic,   copy) NSAttributedString *tipBtnAttributedTitle;
@property (nonatomic,   copy) NSAttributedString *subTipBtnAttributedTitle;
@property (nonatomic, copy) void (^handleActionBlock)(EYDEmptyActionType);

@end

@implementation YDEmptyView

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}
- (void)setEmptyType:(EYDEmptyType)emptyType
{
    _emptyType = emptyType;
    self.hidden = emptyType == EYDEmptyTypeNone;
    if (self.hidden) {
        return;
    }
    self.cartoonImageView.hidden = YES;
    self.tipLabel.hidden = YES;
    self.tipBtn.hidden = YES;
    self.subTipBtn.hidden = YES;
    
    UIImage *img = nil;
    switch (self.emptyType) {
        case EYDEmptyTypeData:
            if (!self.imageName) {
                img = [YDEmptyViewConfig emptyImage][EmptyNoDataImage];
            }
            if (!self.tipTitle) {
                self.tipTitle = @"暂无数据";
            }
            break;
        case EYDEmptyTypeNetwork:
            if (!self.imageName) {
                img = [YDEmptyViewConfig emptyImage][EmptyNetworkExceptionImage];
            }
            if (!self.tipTitle) {
                self.tipTitle = @"哇哦，网络出错了，刷新试试";
            }
            if (!self.tipBtnTitle) {
                self.tipBtnTitle = @"刷新";
            }
            if (!self.subTipBtnTitle) {
                self.subTipBtnTitle = @"打开网络设置";
            }
            break;
        case EYDEmptyTypeRequest:
            if (!self.imageName) {
                img = [YDEmptyViewConfig emptyImage][EmptyRequestExceptionImage];
            }
            if (!self.tipTitle) {
                self.tipTitle = @"数据获取异常\n请稍后点击页面刷新";
            }
            break;
        case EYDEmptyTypeCustom:
            if (self.imageName) {
                img = [UIImage imageNamed:self.imageName inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
            }
            break;
        default:
            break;
    }
    UIView *lastTopView = self;
    __block MASConstraint *bottomConstraint;
    if (img) {
        self.cartoonImageView.image = img;
        self.cartoonImageView.hidden = NO;
        if (bottomConstraint) [bottomConstraint deactivate];
        [self.cartoonImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastTopView);
            make.centerX.equalTo(lastTopView);
            bottomConstraint = make.bottom.equalTo(self);
        }];
        lastTopView = self.cartoonImageView;
    }
    if (self.tipTitle.length > 0 || self.tipAttributedTitle.length > 0) {
        if (self.tipAttributedTitle.length > 0) {
            self.tipLabel.attributedText = self.tipAttributedTitle;
        } else if (self.tipTitle.length > 0) {
            self.tipLabel.text = self.tipTitle;
        }
        self.tipLabel.hidden = NO;
        if (bottomConstraint) [bottomConstraint deactivate];
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastTopView.mas_bottom).offset(12.5);
            make.centerX.equalTo(lastTopView);
            bottomConstraint = make.bottom.equalTo(self);
        }];
        lastTopView = self.tipLabel;
    }
    if (self.tipBtnTitle.length > 0 || self.tipBtnAttributedTitle.length > 0) {
        if (self.tipBtnAttributedTitle.length > 0) {
            [self.tipBtn setAttributedTitle:self.tipAttributedTitle forState:UIControlStateNormal];
        } else if (self.tipBtnTitle.length > 0) {
            [self.tipBtn setTitle:self.tipBtnTitle forState:UIControlStateNormal];
        }
        self.tipBtn.hidden = NO;
        if (bottomConstraint) [bottomConstraint deactivate];;
        [self.tipBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastTopView.mas_bottom).offset(23.5);
            make.centerX.equalTo(lastTopView);
            make.size.mas_equalTo(CGSizeMake(136., 40.));
            bottomConstraint = make.bottom.equalTo(self);
        }];
        lastTopView = self.tipBtn;
    }
    if (self.subTipBtnTitle.length > 0 || self.subTipBtnAttributedTitle.length > 0) {
        if (self.subTipBtnAttributedTitle.length > 0) {
            [self.subTipBtn setAttributedTitle:self.subTipBtnAttributedTitle forState:UIControlStateNormal];
        } else if (self.subTipBtnTitle.length > 0) {
            [self.subTipBtn setTitle:self.subTipBtnTitle forState:UIControlStateNormal];
        }
        self.subTipBtn.hidden = NO;
        if (bottomConstraint) [bottomConstraint deactivate];;
        [self.subTipBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastTopView.mas_bottom).offset(13.);
            make.centerX.equalTo(lastTopView);
            make.bottom.equalTo(self);
            bottomConstraint = make.bottom.equalTo(self);
        }];
        lastTopView = self.subTipBtn;
    }
}

- (void)configureEmptyView:(NSString *)aImageString title:(id)aTitle tipBtnTitle:(id)tipBtnTitle subTipBtnTitle:(id)subTipBtnTitle handleAction:(void (^)(EYDEmptyActionType actionType))handleActionBlock
{
    if (self.emptyType == EYDEmptyTypeCustom) {
        self.imageName = aImageString;
        if ([aTitle isKindOfClass:[NSString class]]) {
            self.tipTitle = aTitle;
        } else if ([aTitle isKindOfClass:[NSAttributedString class]]) {
            self.tipAttributedTitle = aTitle;
        } else {
            self.tipTitle = nil;
            self.tipAttributedTitle = nil;
        }
        if ([tipBtnTitle isKindOfClass:[NSString class]]) {
            self.tipBtnTitle = tipBtnTitle;
        } else if ([aTitle isKindOfClass:[NSAttributedString class]]) {
            self.tipBtnAttributedTitle = tipBtnTitle;
        } else {
            self.tipBtnTitle = nil;
            self.tipBtnAttributedTitle = nil;
        }
        if ([subTipBtnTitle isKindOfClass:[NSString class]]) {
            self.subTipBtnTitle = subTipBtnTitle;
        } else if ([aTitle isKindOfClass:[NSAttributedString class]]) {
            self.subTipBtnAttributedTitle = subTipBtnTitle;
        }else {
            self.subTipBtnTitle = nil;
            self.subTipBtnAttributedTitle = nil;
        }
        self.emptyType = EYDEmptyTypeCustom;
    }
    if (handleActionBlock) {
        self.handleActionBlock = handleActionBlock;
    }
}
- (void)makeUI
{
    self.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tipBtn];
    [self addSubview:self.subTipBtn];
    [self addSubview:self.cartoonImageView];
    [self addSubview:self.tipLabel];
    [self.tipBtn addTarget:self action:@selector(handleTipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.subTipBtn addTarget:self action:@selector(handleSubTipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleTipBtnClick:(id)sender {
    if (self.handleActionBlock) {
        if (self.emptyType == EYDEmptyTypeCustom) {
            self.handleActionBlock(EYDEmptyActionTypeCustomTip);
        }
        else if (self.emptyType == EYDEmptyTypeNetwork) {
            self.handleActionBlock(EYDEmptyActionTypeNetworkRefresh);
        }
    }
}

- (void)handleSubTipBtnClick:(id)sender {
    if (self.handleActionBlock) {
        if (self.emptyType == EYDEmptyTypeCustom) {
            self.handleActionBlock(EYDEmptyActionTypeCustomSubTip);
        }
        else if (self.emptyType == EYDEmptyTypeNetwork) {
            self.handleActionBlock(EYDEmptyActionTypeNetworkSet);
        }
    }
}
//MARK: lazy
- (UIButton *)tipBtn {
    if (!_tipBtn) {
        _tipBtn = [[UIButton alloc] init];
        [_tipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tipBtn.titleLabel setFont:[UIFont systemFontOfSize:14.]];
        _tipBtn.layer.masksToBounds = YES;
        _tipBtn.layer.cornerRadius = 20.f;
        [_tipBtn setBackgroundImage:[YDEmptyViewConfig buttonBackgroundImage][EmptyButtonNormalImage] forState:UIControlStateNormal];
        [_tipBtn setBackgroundImage:[YDEmptyViewConfig buttonBackgroundImage][EmptyButtonHighlightedImage] forState:UIControlStateHighlighted];
        [_tipBtn setBackgroundImage:[YDEmptyViewConfig buttonBackgroundImage][EmptyButtonDisabledImage] forState:UIControlStateDisabled];
    }
    return _tipBtn;
}

- (UIButton *)subTipBtn {
    if (!_subTipBtn) {
        _subTipBtn = [[UIButton alloc] init];
        [_subTipBtn setTitleColor:[YDEmptyViewConfig subButtonTitleColor] forState:UIControlStateNormal];
        [_subTipBtn.titleLabel setFont:[UIFont systemFontOfSize:12.]];
    }
    return _subTipBtn;
}

- (UIImageView *)cartoonImageView
{
    if(!_cartoonImageView){
        _cartoonImageView = [[UIImageView alloc] init];
        _cartoonImageView.image = [YDEmptyViewConfig defaultEmptyImage];
        _cartoonImageView.backgroundColor = [UIColor clearColor];
    }
    return _cartoonImageView;
}

- (UILabel *)tipLabel
{
    if(!_tipLabel){
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.font = [UIFont systemFontOfSize:15.];
        _tipLabel.textColor = [YDEmptyViewConfig tipTextColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

@end
