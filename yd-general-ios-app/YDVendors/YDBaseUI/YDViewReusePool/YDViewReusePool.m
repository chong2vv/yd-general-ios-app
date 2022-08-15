//
//  YDViewReusePool.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/15.
//

#import "YDViewReusePool.h"

@interface YDViewReusePool ()

@property (nonatomic, strong)NSMutableSet *usingQueue;
@property (nonatomic, strong)NSMutableSet *waitUsedQueue;

@end

@implementation YDViewReusePool

- (instancetype)init {
    if (self = [super init]) {
        _usingQueue = [NSMutableSet new];
        _waitUsedQueue = [NSMutableSet new];
    }
    return self;
}

//获取重用的view
- (UIView *)dequeueResableView {
    UIView *view = [_waitUsedQueue anyObject];
    if (view == nil) {
        return nil;
    }else{
        [_usingQueue addObject:view];
        [_waitUsedQueue removeObject:view];
        return view;
    }
}

- (void)addUsingView:(UIView *)view {
    if (view == nil) {
        return;
    }
    
    [_usingQueue addObject:view];
}

- (void)reset {
    UIView *view = nil;
    while ((view = [_usingQueue anyObject])) {
        [_usingQueue removeObject:view];
        [_waitUsedQueue addObject:view];
    }
}

@end
