//
//  AFJSONResponseSerializer+YDAgent.m
//  YDNetworkManager
//
//  Created by wangyuandong on 2021/9/30.
//

#import "AFJSONResponseSerializer+YDAgent.h"
#import <objc/runtime.h>

@implementation AFJSONResponseSerializer (YDAgent)

+ (void)load{
    // 实现init 与 dt_init方法的交换
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL org_Selector = @selector(init);
        SEL dt_Selector  = @selector(swizzling_init);
        
        Method org_method = class_getInstanceMethod([self class], org_Selector);
        Method dt_method  = class_getInstanceMethod([self class], dt_Selector);
        
        BOOL isAdd = class_addMethod(self, org_Selector, method_getImplementation(dt_method), method_getTypeEncoding(dt_method));
        if (isAdd) {
            class_replaceMethod(self, dt_Selector, method_getImplementation(org_method), method_getTypeEncoding(org_method));
        }else{
            method_exchangeImplementations(org_method, dt_method);
        }
        
    });
}

- (instancetype)swizzling_init {
    
    AFJSONResponseSerializer * serializer = [self swizzling_init];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",nil];
#pragma mark - 每次清理下缓存保证不会因AFN缓存出现致命问题
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    return serializer;
}

@end
