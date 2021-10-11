//
//  YDAlertView.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/11.
//

#import "YDAlertView.h"
#import "YDAlertViewConfig.h"
#import "YDAlertAction.h"
#import "YDAlertViewController.h"

/** 间隙 */
const static CGFloat padding = 15.0;

/** 弹窗总宽度 */
const static CGFloat alertWidth = 270;

/** 内容宽度 */
const static CGFloat containerWidth = alertWidth - 2*padding;

/** 按钮高度 */
const static CGFloat buttonHeight = 40.0;

@interface YDAlertView ()

//UI
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
// 上部视图包含titleLabel和messageLabel
@property (nonatomic, strong) UIView *labelView;
//data
@property (nonatomic, strong) NSMutableArray <YDAlertAction *> *actionArray;
@property (nonatomic, copy) NSAttributedString *title;
@property (nonatomic, copy) NSAttributedString *message;

@end

@implementation YDAlertView

#pragma mark - public method
+ (instancetype)alertViewWith:(id)title message:(id)message{
    YDAlertView *alertView = [[YDAlertView alloc] initWithTitle:title message:message];
    return alertView;
}

//修改数据源
- (void)addAction:(YDAlertAction *)action{
    if (action == nil || [self.actionArray containsObject:action]) {
        return;
    }
    [self.actionArray addObject:action];
    [self addSubview:action];
    [action addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    // 因为可能添加多个 button，所以只要标记为需要更新，这样即使添加了多次也只会更新一次
    [self setNeedsUpdateConstraints];
}

#pragma mark - load view
- (instancetype)initWithTitle:(id)title message:(id)message
{
    self = [super init];
    if (self) {
        self.title = title;
        self.message = message;
        NSAssert(self.title.length > 0 || self.message.length > 0, @"YDAlertView title or message must have a value");
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    self.backgroundColor = [YDAlertViewConfig alertViewBackColor];
    //设置圆角
    self.layer.cornerRadius = 8.;
    self.layer.masksToBounds = YES;
    //actionArray
    self.actionArray = [NSMutableArray array];
    self.labelView.backgroundColor = [UIColor whiteColor];
    
    [self.labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    UIView *lastTopView = self.labelView ;
    __block MASConstraint *bottomConstrant;
    if (self.title.length > 0) {
        self.titleLabel.attributedText = self.title;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastTopView).offset(padding);
            make.left.equalTo(self.labelView).offset(padding);
            make.right.equalTo(self.labelView).offset(-padding);
            make.width.mas_equalTo(containerWidth);
            make.centerX.equalTo(self.labelView);
            bottomConstrant = make.bottom.equalTo(self.labelView).offset(-padding);
        }];
        lastTopView = self.titleLabel;
    }
    if (self.message.length > 0) {
        [bottomConstrant deactivate];
        self.messageLabel.attributedText = self.message;
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([lastTopView isEqual:self.labelView] ? lastTopView : lastTopView.mas_bottom).offset(padding);
            make.left.equalTo(self.labelView).offset(padding);
            make.right.equalTo(self.labelView).offset(-padding);
            make.width.mas_equalTo(containerWidth);
            make.centerX.equalTo(self.labelView);
            bottomConstrant = make.bottom.equalTo(self.labelView).offset(-padding);
        }];
        lastTopView = self.messageLabel;
    }
}

- (void)updateConstraints {
    // 根据当前button的数量来布局
    switch (self.actionArray.count) {
        case 2:
            [self layoutButtonsHorizontal];
            break;
        default:
            [self layoutButtonsVertical];
            break;
    }
    [super updateConstraints];
}

#pragma mark - private method
- (void)buttonDidClick:(YDAlertAction *)action {
    action.handler ? action.handler(action) : nil;
    for (YDAlertAction *actionBtn in self.actionArray) {
        actionBtn.handler = nil;
    }
    YDAlertViewController *alertController = (YDAlertViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [alertController dismissWithAnimation:YES completion:nil];
}

/** 两个 button 时的水平布局 */
- (void)layoutButtonsHorizontal {
    [self.actionArray[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelView.mas_bottom).offset(0.5);
        make.left.equalTo(self);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.actionArray[1] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.height.width.equalTo(self.actionArray[0]);
        make.left.equalTo(self.actionArray[0].mas_right).offset(0.5);
        make.bottom.equalTo(self);
    }];
}

/** 垂直布局 */
- (void)layoutButtonsVertical {
    UIView *lastView = self.labelView;
    for (YDAlertAction *actionBtn in self.actionArray) {
        [actionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom).offset(0.5);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(buttonHeight);
        }];
        lastView = actionBtn;
    }
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
    }];
}

#pragma mark - setter
- (void)setTitle:(NSAttributedString *)title {
    NSAssert(!title || [title isKindOfClass:[NSString class]] || [title isKindOfClass:[NSAttributedString class]], @"YDAlertView title.class must be NSString Or NSAttributedString");
    
    if ([title isKindOfClass:[NSString class]]) {
        NSString *titleString = (NSString *)title;
        if (titleString.length > 0) title = [[NSAttributedString alloc] initWithString:titleString attributes:@{NSFontAttributeName:self.titleFont,NSForegroundColorAttributeName:self.titleColor}];
    }
    if (title.length > 0) {
        _title = title;
    }
}

- (void)setMessage:(NSAttributedString *)message {
    NSAssert(!message || [message isKindOfClass:[NSString class]] || [message isKindOfClass:[NSAttributedString class]], @"YDAlertView message.class must be NSString Or NSAttributedString");
    
    if ([message isKindOfClass:[NSString class]]) {
        NSString *messageString = (NSString *)message;
        if (messageString.length > 0) message = [[NSAttributedString alloc] initWithString:messageString attributes:@{NSFontAttributeName:self.messageFont,NSForegroundColorAttributeName:self.messageColor}];
    }
    if (message.length > 0) {
        _message = message;
    }
}

#pragma mark - getter
- (UIFont *)titleFont {
    return [UIFont boldSystemFontOfSize:16.];
}

- (UIColor *)titleColor {
    return [UIColor blackColor];
}

- (UIFont *)messageFont {
    return [UIFont systemFontOfSize:14.];
}

- (UIColor *)messageColor {
    return [YDAlertViewConfig messageTextColor];
}

- (UIView *)labelView {
    if (!_labelView) {
        _labelView = [[UIView alloc] initWithFrame:CGRectZero];
        _labelView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_labelView];
    }
    return _labelView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = self.messageFont;
        _messageLabel.textColor = self.messageColor;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        [self.labelView addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = self.titleFont;
        _titleLabel.textColor = self.titleColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self.labelView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
