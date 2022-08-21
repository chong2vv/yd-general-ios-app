//
//  YDActionSheetViewController.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/20.
//

#import "YDActionSheetViewController.h"
#import "YDSheetTitleView.h"

@interface YDActionSheetViewController ()
@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, strong) YDSheetTitleView *sheetTitleView;
@property (nonatomic, strong) UIView *safeBottomView;
@property (nonatomic, strong) NSArray<YDSheetButton *> *sheetButtons;
@property (nonatomic, strong) YDSheetButton *cancelButton;
@property (nonatomic, assign) CGFloat cancelMarginHeight;// 取消按钮顶部距离
@end

@implementation YDActionSheetViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext&UIModalPresentationOverFullScreen;
        _actionButtonHeight = 54;
        _actionTitleHeight = 54;
        _cancelButtonHeight = 54;
        _cancelMarginHeight = 10;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor sheet_colorWithRGBHex:0x000000 alpha:0.4];
    [self configAttributes];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sheetView.frame = CGRectMake(0, self.view.bounds.size.height, self.sheetView.bounds.size.width, self.sheetView.bounds.size.height);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        self.sheetView.frame = CGRectMake(0, self.view.bounds.size.height-self.sheetView.bounds.size.height, self.sheetView.bounds.size.width, self.sheetView.bounds.size.height);
    }];
}
#pragma mark - subviews
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.25 animations:^{
        self.sheetView.frame = CGRectMake(0, self.view.bounds.size.height, self.sheetView.bounds.size.width, self.sheetView.bounds.size.height);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
}

// iphoneX
- (BOOL)art_sheetScreenHasNotch
{
    if(@available(iOS 11.0, *)){
        return [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0;
    }
    return NO;
}

- (void)configAttributes {
    
    [self.view addSubview:self.sheetView];
    
    // 如果有title，那么添加titleView
    if (self.actionTitle && self.actionTitle.length > 0) {
        self.sheetTitleView.title = self.actionTitle;
        [self.sheetView addSubview:self.sheetTitleView];
    }
    
    // 如果有取消按钮
    if (self.cancelButton) {
        [self.sheetView addSubview:self.cancelButton];
    }
    
    CGFloat sheetTitleViewH = _sheetTitleView ? _actionTitleHeight : 0; // titleview 高度
    CGFloat cancelBtnH = self.cancelButton ? _cancelButtonHeight : 0;
    CGFloat cancelMarginH = self.cancelButton ? _cancelMarginHeight : 0;
    CGFloat safeBottomArea = 0; // 底部安全距离
    
    // iphoneX
    if ([self art_sheetScreenHasNotch]) {
        [self.sheetView addSubview:self.safeBottomView];
        safeBottomArea = 34;
    }
    
    // 计算sheetview高度
    CGFloat sheetViewH = _actionButtonHeight * self.sheetButtons.count + sheetTitleViewH + cancelBtnH + safeBottomArea + cancelMarginH;
    self.sheetView.frame = CGRectMake(0, self.view.bounds.size.height - sheetViewH, self.view.bounds.size.width, sheetViewH);
    _sheetTitleView.frame = CGRectMake(0, 0, self.sheetView.bounds.size.width, sheetTitleViewH);
    self.cancelButton.frame = CGRectMake(0, sheetViewH - safeBottomArea - cancelBtnH, self.sheetView.bounds.size.width, cancelBtnH);
    _safeBottomView.frame = CGRectMake(0, sheetViewH - safeBottomArea, self.sheetView.bounds.size.width, safeBottomArea);
    for (int i = 0; i < self.sheetButtons.count; i++) {
        YDSheetButton *sheetBtn = self.sheetButtons[i];
        if (i == self.sheetButtons.count - 1) {
            sheetBtn.hidenBottonLine = YES;
        }
        [self.sheetView addSubview:sheetBtn];
        sheetBtn.frame = CGRectMake(0, i*_actionButtonHeight + sheetTitleViewH, self.sheetView.bounds.size.width, _actionButtonHeight);
    }
    
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: self.sheetView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12,12)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.sheetView.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.sheetView.layer.mask = maskLayer;
    
    
}

#pragma mark - instence method
- (NSInteger)addButtonWithTitle:(NSString *)title style:(YDSheetButtonStyle)stype handler:(void (^)(UIButton * _Nonnull))handler {
    YDSheetButton *sheetBtn = [YDSheetButton buttonWithTitle:title style:stype handler:handler];
    sheetBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [sheetBtn setTitleColor:[UIColor colorWithHexString:@"0x000000"] forState:UIControlStateNormal];
    sheetBtn.hidenTopLine = YES;
    [sheetBtn addTarget:self action:@selector(sheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableArray * tempArr = [NSMutableArray arrayWithArray:self.sheetButtons];
    [tempArr addObject:sheetBtn];
    self.sheetButtons = tempArr.copy;
    return 0;
}
- (NSInteger)addCancelButtonWithTitle:(nullable NSString *)title handler:(nullable void (^)(UIButton * button))handler {
    YDSheetButton *sheetBtn = [YDSheetButton buttonWithTitle:title style:YDSheetButtonStyleCancel handler:handler];
    sheetBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [sheetBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [sheetBtn addTarget:self action:@selector(sheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sheetBtn.hidenTopLine = YES;
    sheetBtn.hidenBottonLine = YES;
    sheetBtn.backgroundColor = [UIColor colorWithHexString:@"0xF7F7F7"];
    self.cancelButton = sheetBtn;
    return 0;
}


- (void)sheetBtnClick:(YDSheetButton *)button {
    [UIView animateWithDuration:0.25 animations:^{
        self.sheetView.frame = CGRectMake(0, self.view.bounds.size.height, self.sheetView.bounds.size.width, self.sheetView.bounds.size.height);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            button.handler(button);
        }];
    }];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}


#pragma mark - lazy
- (UIView *)sheetView {
    if (!_sheetView) {
        _sheetView = [UIView new];
//        _sheetView.backgroundColor = [UIColor sheet_colorWithRGBHex:0xEDEDED];
        _sheetView.backgroundColor = [UIColor sheet_colorWithRGBHex:0xF7F7F7];

    }
    return _sheetView;
}

- (YDSheetTitleView *)sheetTitleView {
    if (!_sheetTitleView) {
        _sheetTitleView = [YDSheetTitleView new];
        _sheetTitleView.backgroundColor = [UIColor whiteColor];
    }
    return _sheetTitleView;
}
- (UIView *)safeBottomView {
    if (!_safeBottomView) {
        _safeBottomView = [[UIView alloc] init];
        _safeBottomView.backgroundColor = [UIColor colorWithHexString:@"0xF7F7F7"];
    }
    return _safeBottomView;
}

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
