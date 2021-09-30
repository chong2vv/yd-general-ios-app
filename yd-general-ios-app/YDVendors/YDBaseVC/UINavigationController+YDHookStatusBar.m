//
//  UINavigationController+YDHookStatusBar.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/9/30.
//

#import "UINavigationController+YDHookStatusBar.h"

@interface UINavigationController ()

@property(readwrite, getter= isViewTransitionInProgress) BOOL viewTransitionInProgress;

@end

@implementation UINavigationController (YDHookStatusBar)

+ (void)load {
    uiswizzling_exchangeMethod([self class], @selector(childViewControllerForStatusBarStyle), @selector(swizzling_childViewControllerForStatusBarStyle));
    uiswizzling_exchangeMethod([self class], @selector(childViewControllerForStatusBarHidden), @selector(swizzling_childViewControllerForStatusBarHidden));



    //-- Exchange the original implementation with our custom one.

    method_exchangeImplementations(class_getInstanceMethod(self,@selector(pushViewController:animated:)),class_getInstanceMethod(self,@selector(safePushViewController:animated:)));

    method_exchangeImplementations(class_getInstanceMethod(self,@selector(popViewControllerAnimated:)),class_getInstanceMethod(self,@selector(safePopViewControllerAnimated:)));

    method_exchangeImplementations(class_getInstanceMethod(self,@selector(popToRootViewControllerAnimated:)),class_getInstanceMethod(self,@selector(safePopToRootViewControllerAnimated:)));

    method_exchangeImplementations(class_getInstanceMethod(self,@selector(popToViewController:animated:)),class_getInstanceMethod(self,@selector(safePopToViewController:animated:)));
}


#pragma mark - 重写方法，让自控制器可以隐藏显示导航栏等
- (UIViewController *)swizzling_childViewControllerForStatusBarStyle {
    return self.viewControllers.lastObject;
}

- (UIViewController *)swizzling_childViewControllerForStatusBarHidden {
    return self.viewControllers.lastObject;
}

#pragma mark - Can't add self as subview 的crashIntercept Pop, Push, PopToRootVC

/// @name Intercept Pop, Push, PopToRootVC

- (NSArray *)safePopToRootViewControllerAnimated:(BOOL)animated {
    
    if(self.forbidHookHandler){
         return  [self  safePopToRootViewControllerAnimated:animated];
    }
    if(self.viewTransitionInProgress)   return    nil;
    
    if(animated) {
        
        self.viewTransitionInProgress =YES;
        
    }
    
    //-- This is not a recursion, due to method swizzling the call below calls the originalmethod.
    
    return  [self  safePopToRootViewControllerAnimated:animated];
    
}

- (NSArray *)safePopToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if(self.forbidHookHandler){
          return [self   safePopToViewController:viewController animated:animated];
    }
    
    if(self.viewTransitionInProgress)  return  nil;
    
    if(animated) {
        
        self.viewTransitionInProgress = YES;
        
    }
    
    //-- This is not a recursion, due to method swizzling the call below calls the originalmethod.
    
    return [self   safePopToViewController:viewController animated:animated];
    
}

- (UIViewController *)safePopViewControllerAnimated:(BOOL)animated {
    if (self.forbidHookHandler) {
        return  [self safePopViewControllerAnimated:animated];
    }
    
    if(self.viewTransitionInProgress){
        NSLog(@"------viewTransitionInProgress = nil-");
        return    nil;
    }

    if(animated) {
        NSLog(@"------viewTransitionInProgress = YES-");
        self.viewTransitionInProgress =YES;
    }

    //-- This is not a recursion, due to method swizzling the call below calls the originalmethod.
    
    return  [self safePopViewControllerAnimated:animated];
    
}

- (void)safePushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if(self.forbidHookHandler){
         [self safePushViewController:viewController animated:animated];
        return;
    }
    
    if (viewController == self.navigationController.topViewController) {
        return;
    }
    
    //-- If we are already pushing a view controller, we dont push another one.
    
    if(self.isViewTransitionInProgress ==NO) {
        
        //-- This is not a recursion, due to method swizzling the call below calls the originalmethod.
        
        [self safePushViewController:viewController animated:animated];
        
        if(animated) {
            self.viewTransitionInProgress =YES;
        }
        
    }
    
}

#pragma mark - 属性绑定
- (void)setViewTransitionInProgress:(BOOL)property {
    
    NSNumber *number = [NSNumber numberWithBool:property];
    objc_setAssociatedObject(self, @selector(isViewTransitionInProgress), number , OBJC_ASSOCIATION_RETAIN);
    if (property == YES) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setViewTransitionInProgress:NO];
        });
    }
}

- (BOOL)isViewTransitionInProgress {
    
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    
    return   [number boolValue];
    
}

- (void)setForbidHookHandler:(BOOL)forbidHookHandler
{
    objc_setAssociatedObject(self, @selector(forbidHookHandler), @(forbidHookHandler), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)forbidHookHandler
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
