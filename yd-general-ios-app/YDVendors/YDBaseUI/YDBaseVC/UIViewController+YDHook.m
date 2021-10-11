//
//  UIViewController+YDHook.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import "UIViewController+YDHook.h"
#import "UIViewController+YDNav.h"

static char *CloseInteractivePopGestureRecognizerKey = "CloseInteractivePopGestureRecognizer";

@interface UIViewController ()<UINavigationControllerDelegate>

@end

@implementation UIViewController (YDHook)

+ (void)load {
    uiswizzling_exchangeMethod([self class], @selector(viewDidAppear:), @selector(swizzling_viewDidAppear:));
    uiswizzling_exchangeMethod([self class], @selector(viewWillAppear:), @selector(swizzling_viewWillAppear:));
    uiswizzling_exchangeMethod([self class], @selector(viewDidLoad), @selector(swizzling_viewDidLoad));
    uiswizzling_exchangeMethod([self class], @selector(viewDidDisappear:), @selector(swizzling_viewDidDisappear:));
}
-(BOOL)closeInteractivePopGestureRecognizer
{
    return [objc_getAssociatedObject(self, CloseInteractivePopGestureRecognizerKey) boolValue];

}

-(void)setCloseInteractivePopGestureRecognizer:(BOOL)closeInteractivePopGestureRecognizer
{
    objc_setAssociatedObject(self, CloseInteractivePopGestureRecognizerKey, [NSNumber numberWithBool:closeInteractivePopGestureRecognizer], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)swizzling_viewDidLoad {
    [self swizzling_viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)swizzling_viewDidDisappear:(BOOL)animated
{
    [self swizzling_viewDidDisappear:animated];
//    if ([self.nameForStatistics isKindOfClass:NSString.class] &&
//        self.nameForStatistics.length > 0) {
//        [ArtStatisticAnalysisService endLogPageView:self.nameForStatistics];
//    }
}
- (void)swizzling_viewDidAppear:(BOOL)animated {
    [self swizzling_viewDidAppear:animated];
    // 每次回来刷下状态栏
    [self setNeedsStatusBarAppearanceUpdate];
    // 如果是 navigationController 的最后一个vc 不允许侧滑，否则会卡死
    if (self.closeInteractivePopGestureRecognizer) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    else{
        self.navigationController.interactivePopGestureRecognizer.enabled = self.navigationController.viewControllers.count != 1;
    }
    
//    if ([self.nameForStatistics isKindOfClass:NSString.class] &&
//        self.nameForStatistics.length > 0) {
//        [ArtStatisticAnalysisService beginLogPageView:self.nameForStatistics];
//    }
}

- (void)swizzling_viewWillAppear:(BOOL)animated {
    [self swizzling_viewWillAppear:animated];
    //全部设置delegate会导致三方SDK里使用系统ImagePickerController事件失效
    if ([NSStringFromClass(self.class).lowercaseString hasPrefix:@"YD"]) {
        self.navigationController.delegate = self;
    }
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 不能影响系统的
    NSString *classString = NSStringFromClass([viewController class]);
    if (!viewController.isHiddenNavigationBar) {
        if ([classString rangeOfString:@"YD"].length <= 0 &&
            ![classString isEqualToString:@"BCFeedbackViewController"]) {
            //BCFeedbackViewController 和 YD**** 的 都需要自动的导航栏处理逻辑
            return;
        }
    }
    [self uploadTitleType];
    BOOL hiddenNav = [viewController hiddenNavigation];
    
    [navigationController setNavigationBarHidden:hiddenNav animated:animated];
}

@end
