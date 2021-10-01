//
//  YDHiddenFunctionPasswordView.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import "YDHiddenFunctionPasswordInputView.h"

#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)

@interface YDHiddenFunctionPasswordInputView ()
@property (nonatomic, strong) UIView *keyboardView;

@end

#define KPhoneScale  SCREEN_W/375.
#define KArtVerityRoomInputKeyCount 6

static NSString *const KYDVerityRoomInputKeycClear       = @"清空";
static NSString *const KYDVerityRoomInputKeyDel          = @"删除";

@implementation YDHiddenFunctionPasswordInputView

- (instancetype)init {
    if (self = [super init]) {
        [self makeUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    [self makeKeyboard];
}

- (void)makeKeyboard {
    [self.keyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    if (UI_IS_IPAD) {
        CGSize btnSize = CGSizeMake(75.*kScaleFactor, 75.*kScaleFactor);
        NSArray <NSArray <NSString *>*>* titleArray = @[@[@"1",@"2",@"3"],@[@"4",@"5",@"6"],@[@"7",@"8",@"9"],@[KYDVerityRoomInputKeycClear,@"0",KYDVerityRoomInputKeyDel]];
        [titleArray enumerateObjectsUsingBlock:^(NSArray<NSString *> *rowArr, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *mArr = @[].mutableCopy;
            CGFloat topOffset = (25.*kScaleFactor  + btnSize.height )*idx;
            [rowArr enumerateObjectsUsingBlock:^(NSString *titleStr, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = [[UIButton alloc] init];
                [btn setTitle:titleStr forState:UIControlStateNormal];
                if ([titleStr isEqualToString:KYDVerityRoomInputKeycClear] || [titleStr isEqualToString:KYDVerityRoomInputKeyDel]) {
                    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:22.];
                }
                else {
                    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:44.];
                }
                [btn setTitleColor:[UIColor colorWithRGBHex:0x000000 alpha:0.3] forState:UIControlStateHighlighted];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(clickKeybtn:) forControlEvents:UIControlEventTouchUpInside];
                [self.keyboardView addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(btnSize);
                    make.top.mas_equalTo(self.keyboardView).offset(topOffset);
                }];
                [mArr addObject:btn];
            }];
            [mArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:btnSize.width leadSpacing:0 tailSpacing:0];
        }];
    }
    else {
        CGSize btnSize = CGSizeMake(44.*KPhoneScale, 44.*KPhoneScale);
        CGFloat btnVerticalMargin = 17. * KPhoneScale;
        //    CGFloat fixSpacing = ([ArtPhoneEnterRoomKeyView Width] - 3 * inputHeight) / (KArtInputKeyCount - 1);
        NSArray <NSArray <NSString *>*>* titleArray = @[@[@"1",@"2",@"3"],@[@"4",@"5",@"6"],@[@"7",@"8",@"9"],@[KYDVerityRoomInputKeycClear,@"0",KYDVerityRoomInputKeyDel]];
        [titleArray enumerateObjectsUsingBlock:^(NSArray<NSString *> *rowArr, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *mArr = @[].mutableCopy;
            CGFloat topOffset = (btnVerticalMargin + btnSize.height )*idx;
            [rowArr enumerateObjectsUsingBlock:^(NSString *titleStr, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = [[UIButton alloc] init];
                [btn setTitle:titleStr forState:UIControlStateNormal];
                if ([titleStr isEqualToString:KYDVerityRoomInputKeycClear] || [titleStr isEqualToString:KYDVerityRoomInputKeyDel]) {
                    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.*KPhoneScale];
                }
                else {
                    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:29.*KPhoneScale];
                }
                [btn setTitleColor:[UIColor colorWithRGBHex:0x000000 alpha:0.3] forState:UIControlStateHighlighted];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(clickKeybtn:) forControlEvents:UIControlEventTouchUpInside];
                [self.keyboardView addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(btnSize);
                    make.top.mas_equalTo(self.keyboardView).offset(topOffset);
                }];
                [mArr addObject:btn];
            }];
            [mArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:btnSize.width leadSpacing:0 tailSpacing:0];
        }];
    }
    
}

#pragma mark Action
- (void)clickKeybtn:(UIButton *)btn {
    [self.delegate keyViewDidEndEditing:[btn titleForState:UIControlStateNormal]];
}

- (UIView *)keyboardView {
    if (!_keyboardView) {
        _keyboardView = [[UIView alloc] init];
        [self addSubview:_keyboardView];
    }
    return _keyboardView;
}

@end
