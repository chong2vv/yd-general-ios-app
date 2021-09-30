//
//  UIViewController+YDNav.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import "UIViewController+YDNav.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface UIViewController ()

@property (nonatomic, copy) void(^clickAction)(UIButton *button);

@end

@implementation UIViewController (YDNav)

static char *const kAction = "kAction";


- (void)uploadTitleType {
    
    UIColor *titleColor = [self titleColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:titleColor, NSForegroundColorAttributeName, [self titleFont], NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor = titleColor;
}

- (UIColor *)titleColor
{
    UIColor *titleColor = [UIColor blackColor];
    
    return titleColor;
}

- (UIFont *)titleFont
{
    return [UIFont boldSystemFontOfSize:18.];
}

- (void)back {
    [self backAnimated:YES];
}

- (void)backAnimated:(BOOL)animated
{
    if (self.navigationController == nil) {
        [self dismissViewControllerAnimated:animated completion:nil];
        return;
    }
    
    UINavigationController *nav = self.navigationController;
    if (nav.viewControllers.count > 1) {
        
        UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
        UIInterfaceOrientation upsataus = nav.viewControllers[nav.viewControllers.count - 2].preferredInterfaceOrientationForPresentation;
        
        if (upsataus == sataus) {
            [self.navigationController popViewControllerAnimated:animated];
            return;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.navigationController popViewControllerAnimated:NO];
        }];
        
    } else {
        [self.navigationController dismissViewControllerAnimated:animated completion:nil];
    }
    
}

- (UINavigationController *)getRecentlyNavigationController {
    
    if (self.navigationController != nil) {
        return self.navigationController;
    }
    
    UIResponder * next = [self nextResponder];
    while (next!=nil) {
        if([next isKindOfClass:[UINavigationController class]]){
            return (UINavigationController * )next;
        }
    }
    return nil;
}

#pragma mark - 导航栏样式

- (NSString *)nextBackTitle {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNextBackTitle:(NSString *)nextBackTitle {
    objc_setAssociatedObject(self, @selector(nextBackTitle), nextBackTitle, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - NavigationBar 显示隐藏控制
- (BOOL)hiddenNavigation {
    return self.isHiddenNavigationBar;
}

- (void)setIsHiddenNavigationBar:(BOOL)isHiddenNavigationBar {
    objc_setAssociatedObject(self, @selector(isHiddenNavigationBar), [NSNumber numberWithBool:isHiddenNavigationBar], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isHiddenNavigationBar {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma mark - 分类自己调用


+(UIViewController *)findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [UIViewController findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    }else{
        return vc;
    }
    
}
+ (UIViewController *)currentViewController {
    
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
    
}


#pragma mark - button click
- (void)backButtonClick:(UIButton *)button {
    if (self.clickAction) self.clickAction(button);
}

#pragma mark - property getter and setter

- (void)setClickAction:(void (^)(UIButton *))clickAction
{
    objc_setAssociatedObject(self, kAction, clickAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIButton *))clickAction
{
    return objc_getAssociatedObject(self, kAction);
}


#pragma mark - privite method
// 获取字符串byte长度
- (NSInteger)p_nav_byteLengthByString:(NSString *)string{
    
    NSInteger chinese=0;
    for(int i=0; i< [string length];i++){
        
        int a = [string characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fff)
            chinese++;
    }
    NSInteger length = [string length] + chinese;
    
    return length;
}
// 返回裁剪的文字
- (NSString *)p_nav_substring:(NSString *)string tobyteLength:(NSInteger)index{
    
    NSString *str = string;
    while ([self p_nav_byteLengthByString:str] > index) {
        str = [str substringToIndex:str.length - 1];
    }
    
    return str;
}
- (NSString *)p_nav_pointStringWithTitle:(NSString *)title {
    
    if ([self p_nav_byteLengthByString:title] > 12) {
        title = [self p_nav_substring:title tobyteLength:9];
        title = [NSString stringWithFormat:@"%@...",title];
    }
    return title;
}

@end
