//
//  YDHiddenFunctionPasswordView.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import "YDHiddenFunctionPasswordView.h"
#import "YDHiddenFunctionPasswordInputView.h"

@interface YDHiddenFunctionPasswordView ()<YDHiddenFunctionPasswordViewDelegate>
@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UIView                *inputLabelView;
@property (nonatomic, strong) NSMutableArray <UILabel *>*inputLabels;
@property (nonatomic, strong) YDHiddenFunctionPasswordInputView   *inputKeyView;
@property (nonatomic, copy) NSString *inputkey;
@end

#define KPhoneScale  SCREEN_W/375.
#define KYDVerityRoomInputKeyCount 6

static NSString *const KYDVerityRoomInputKeycClear       = @"清空";
static NSString *const KYDVerityRoomInputKeyDel          = @"删除";

@implementation YDHiddenFunctionPasswordView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.inputkey = @"";
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    
    self.backgroundColor = [UIColor whiteColor];
    [self makeInputLabels];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inputLabelView.mas_bottom).offset(20 * kydIphoneScaleFactor);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(22 * KPhoneScale);
    }];
    
    [self.inputKeyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(24);
        make.width.mas_equalTo(UI_IS_IPAD ? 390. : [self Width]);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-10.* (UI_IS_IPAD ? 1 : KPhoneScale));
    }];
    self.inputKeyView.delegate = self;
}

- (void)makeInputLabels {
    if (UI_IS_IPAD) {
        CGFloat inputHeight = 55. ;
        [self.inputLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(84.);
            make.width.mas_equalTo(400.);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(inputHeight);
        }];
        self.inputLabels = @[].mutableCopy;
        for (int i = 0; i < KYDVerityRoomInputKeyCount; i++) {
            UILabel *inputLabel = [[UILabel alloc] init];
            inputLabel.textAlignment = NSTextAlignmentCenter;
            inputLabel.layer.cornerRadius = 10. ;
            inputLabel.backgroundColor = [UIColor colorWithRGBHex:0xF5F5F5];
            inputLabel.layer.masksToBounds = YES;
            inputLabel.textColor = [UIColor colorWithRGBHex:0x333333];
            inputLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:28.];
            [self.inputLabelView addSubview:inputLabel];
            [inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(inputHeight);
                make.top.mas_equalTo(self.inputLabelView);
            }];
            [self.inputLabels addObject:inputLabel];
        }
        [self.inputLabels mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12. leadSpacing:0 tailSpacing:0];
    }
    else {
        CGFloat inputHeight = 35. *KPhoneScale;
        [self.inputLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(22.5 *KPhoneScale);
            make.width.mas_equalTo([self Width]);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(inputHeight);
        }];
        self.inputLabels = @[].mutableCopy;
        for (int i = 0; i < KYDVerityRoomInputKeyCount; i++) {
            UILabel *inputLabel = [[UILabel alloc] init];
            inputLabel.textAlignment = NSTextAlignmentCenter;
            inputLabel.layer.cornerRadius = 7.*KPhoneScale ;
            inputLabel.backgroundColor = [UIColor colorWithRGBHex:0xF5F5F5];
            inputLabel.layer.masksToBounds = YES;
            inputLabel.textColor = [UIColor colorWithRGBHex:0x333333];
            inputLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20.*KPhoneScale];
            [self.inputLabelView addSubview:inputLabel];
            [inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(inputHeight, inputHeight));
                make.top.mas_equalTo(self.inputLabelView);
            }];
            [self.inputLabels addObject:inputLabel];
        }
        [self.inputLabels mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:inputHeight leadSpacing:0 tailSpacing:0];
    }
    
}

- (void)keyViewDidEndEditing:(NSString *)key {
    [self handelInputKey:key];
}

- (void)handelInputKey:(NSString *)key {
    
    NSString *curTitle = key;
    if ([curTitle isEqualToString:KYDVerityRoomInputKeycClear]) {
        [self clearInputKey];
    }
    else if ([curTitle isEqualToString:KYDVerityRoomInputKeyDel]) {
        if ((self.inputkey.length > 0)) {
            self.inputkey = [self.inputkey substringToIndex:[self.inputkey length] - 1];
        }
    }else {
        self.inputkey = [self.inputkey stringByAppendingString:curTitle];
    }
    if (self.inputkey.length >= KYDVerityRoomInputKeyCount ) {
        if ([self.delegate respondsToSelector:@selector(checkPasswordInput:)]) {
            [self.delegate checkPasswordInput:self.inputkey];
        }
    }
}

- (void)clearInputKey {
    self.inputkey = @"";
}

#pragma mark - setter
- (void)setInputkey:(NSString *)inputkey {
    if (inputkey.length > KYDVerityRoomInputKeyCount) {
        inputkey = [inputkey substringWithRange:NSMakeRange(inputkey.length - KYDVerityRoomInputKeyCount, KYDVerityRoomInputKeyCount)];
    }
    _inputkey = inputkey;
    [self.inputLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (_inputkey.length > 0 && idx < _inputkey.length) {
            NSString *numStr = [_inputkey substringWithRange:NSMakeRange(idx, 1)];
            self.inputLabels[idx].text = numStr;
        }
        else {
            obj.text = @"";
        }
    }];
}

- (UIView *)inputLabelView {
    if (!_inputLabelView) {
        _inputLabelView = [[UIView alloc] init];
        [self addSubview:_inputLabelView];
    }
    return _inputLabelView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"888888"];
        _titleLabel.text = @"输入隐藏功能密钥";
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (YDHiddenFunctionPasswordInputView *)inputKeyView {
    if (!_inputKeyView) {
        _inputKeyView = [[YDHiddenFunctionPasswordInputView alloc] init];
        _inputKeyView.delegate = self;
        [self addSubview:_inputKeyView];
    }
    return _inputKeyView;
}

- (CGFloat)Width {
    return 260. * KPhoneScale;
}


@end
