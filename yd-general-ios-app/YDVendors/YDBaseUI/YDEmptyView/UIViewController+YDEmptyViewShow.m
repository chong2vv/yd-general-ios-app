//
//  UIViewController+YDEmptyViewShow.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/23.
//

#import "UIViewController+YDEmptyViewShow.h"
#import <objc/runtime.h>

@interface UIViewController ()

@property (nonatomic, strong) YDEmptyView *emptyView;
@property (nonatomic, strong) UITapGestureRecognizer *retryTap;

@end

@implementation UIViewController (YDEmptyViewShow)

- (void)showEmptyView:(NSString *)aImageString title:(NSString *)aTitle tipBtnTitle:(NSString *)tipBtnTitle subTipBtnTitle:(NSString *)subTipBtnTitle type:(EYDEmptyType)aEmptyType action:(void (^)(EYDEmptyActionType actionType))aEmptyAction{
    if (self.emptyView) {
        [self.emptyView removeFromSuperview];
        self.emptyView = nil;
    }
    self.emptyView = [[YDEmptyView alloc] init];
    [self.view addSubview:self.emptyView];
    [self.view sendSubviewToBack:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.width.equalTo(self.view);
    }];
    self.emptyView.emptyType = aEmptyType;
    
    [self.emptyView configureEmptyView:aImageString title:aTitle tipBtnTitle:tipBtnTitle subTipBtnTitle:subTipBtnTitle handleAction:aEmptyAction];
}

#pragma mark - 属性绑定
- (void)setEmptyView:(YDEmptyView *)emptyView
{
    objc_setAssociatedObject(self, @selector(emptyView), emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YDEmptyView *)emptyView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRetryTap:(UITapGestureRecognizer *)retryTap
{
    objc_setAssociatedObject(self, @selector(retryTap), retryTap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITapGestureRecognizer *)retryTap
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRetryBlock:(void (^)(void))retryBlock {
    objc_setAssociatedObject(self, @selector(retryBlock), retryBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))retryBlock {
    return objc_getAssociatedObject(self, _cmd);
}

@end
