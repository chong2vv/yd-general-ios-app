//
//  YDBatchCommand.m
//  YDNetworkManager
//
//  Created by wangyuandong on 2021/9/30.
//

#import "YDBatchCommand.h"
#import "YDCommand.h"

@implementation YDBatchCommand

#pragma mark - 简便调用方法提供
- (NSError *)lastError {
    __block NSError *error = nil;
    [self.requestArray enumerateObjectsUsingBlock:^(YTKRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.error) {
            error = obj.error;
        }
    }];
    return error;
}

#pragma mark  普通调用方法
/**
 *  提供类方法直接调用
 *  @param aCommands      设置需要的网络请求数组
 *  @param aCompletion  完成后都会走该block，以属性 NSError *error 来区分成功失败
 */
+ (instancetype)ydBatchRequestArray:(NSArray<YDCommand *>*)aCommands completion:(YDBatchRequestCompletionBlock)aCompletion {
    return [self ydBatchRequestArray:aCommands success:aCompletion failure:aCompletion];
}

/**
 *  提供类方法直接调用
 *  @param aCommands      设置需要的网络请求数组
 *  @param aSuccess     成功回调
 *  @param aFailure     失败回调
 */
+ (instancetype)ydBatchRequestArray:(NSArray<YDCommand *>*)aCommands success:(YDBatchRequestCompletionBlock)aSuccess failure:(YDBatchRequestCompletionBlock)aFailure {
    return [self ydBatchRequestArray:aCommands withNext:nil success:aSuccess failure:aFailure];
}


/**
 *  提供类方法直接调用
 *  @param aCommands      设置需要的网络请求数组
 *  @param aNext        成功失败都会走 如收回下拉刷新
 *  @param aSuccess     成功回调
 *  @param aFailure     失败回调
 */
+ (instancetype)ydBatchRequestArray:(NSArray<YDCommand *>*)aCommands withNext:(YDBatchRequestCompletionBlock)aNext success:(YDBatchRequestCompletionBlock)aSuccess failure:(YDBatchRequestCompletionBlock)aFailure {

    YDBatchCommand *batchRequest = [[YDBatchCommand alloc] initWithRequestArray:aCommands];
    [batchRequest traverseRequest:^(YDCommand *aCmd) {
        [aCmd defaultParame];
    }];
    
    void (^success)(YTKBatchRequest *batchRequest) = ^(YTKBatchRequest *request){
        
        [request.requestArray enumerateObjectsUsingBlock:^(YTKRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YDCommand *aCmd = (YDCommand *)obj;
            if (aCmd.localCachefailureTime <= 2 && aCmd.isDataFromCache) {
                 [aCmd setValue:[NSNumber numberWithBool:NO] forKey:@"dataFromCache"];
                *stop = YES;
            }
        }];
        
        if (aNext) {
            aNext(batchRequest);
        }
        if (aSuccess) {
            aSuccess(batchRequest);
        }
    };
    
    void (^failure)(YTKBatchRequest *batchRequest) = ^(YTKBatchRequest *request){
        if (aNext) {
            aNext(batchRequest);
        }
        if (aSuccess) {
            aSuccess(batchRequest);
        }
    };
    
    [batchRequest startWithCompletionBlockWithSuccess:success failure:failure];
    return batchRequest;
}

/**
 *  提供类方法直接调用
 *  @param aCommands     设置需要的网络请求数组
 *  @param aEnable       YES 使用先缓存后网络功能  NO则直接走网络  主要是基本只有第一次才需要使用YES
 *  @param aCache        YES 走网络网络时缓存数据， NO不缓存数据， 主要用于下拉刷新纪录缓存，加载更多不需要
 *  @param aRefresh      调用显示刷新动画
 *  @param aCompletion   完成后都会走该block，以属性 NSError *error 来区分成功失败  isDataFromCache 来区分是否从缓存走的
 */
+ (instancetype)ydBatchLocalRequestArray:(NSArray<YDCommand *>*)aCommands enable:(BOOL)aEnable saveCache:(BOOL)aCache refresh:(void (^)(void))aRefresh completion:(YDBatchRequestCompletionBlock)aCompletion {
    
    if (!aEnable) {
        [aCommands enumerateObjectsUsingBlock:^(YDCommand * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           obj.localCachefailureTime = aCache ? 1 : -1;
        }];
        return [self ydBatchRequestArray:aCommands completion:aCompletion];
    }
    
    YDBatchCommand *batchRequest = [[YDBatchCommand alloc] initWithRequestArray:aCommands];
    __block BOOL isOK = YES;
    [batchRequest traverseRequest:^(YDCommand *aCmd) {
        [aCmd defaultParame];
        aCmd.ignoreCache = NO;
        //取缓存要无限大
        aCmd.localCachefailureTime = 60 * 60 * 24 * 365;
        NSError *error = nil;
        if ([aCmd loadCacheWithError:&error]) {
            if (error == nil) {
                [aCmd setValue:[NSNumber numberWithBool:YES] forKey:@"dataFromCache"];
                [aCmd requestCompleteFilter];
               
            }else {
                isOK = NO;
            }
        }else {
            isOK = NO;
        }
    }];
    if (isOK && aCompletion) {
        aCompletion(batchRequest);
    }
  
    [batchRequest traverseRequest:^(YDCommand *aCmd) {
        aCmd.ignoreCache = YES;
        aCmd.localCachefailureTime = 1;
    }];
    
    [UIView setAnimationsEnabled:NO];
    if (aRefresh) {
        aRefresh();
    }
    [UIView setAnimationsEnabled:YES];
    NSDate *startDate = [NSDate date];
    
    void (^block)(YTKBatchRequest *batchRequest) = ^(YTKBatchRequest *request){
     
        [batchRequest traverseRequest:^(YDCommand *aCmd) {
            [aCmd setValue:[NSNumber numberWithBool:NO] forKey:@"dataFromCache"];
        }];
        // 强制认为不是从缓存走的
        NSTimeInterval time = - [startDate timeIntervalSinceNow];
        // 时间判断是为了更好的UI体验
        if (time < 0.2) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                aCompletion(batchRequest);
            });
        }else {
            aCompletion(batchRequest);
        }
    };
    [batchRequest startWithCompletionBlockWithSuccess:block failure:block];
    return batchRequest;
}

- (void)traverseRequest:(void (^)(YDCommand *aCmd))aParame {
    [self.requestArray enumerateObjectsUsingBlock:^(YTKRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert([obj isKindOfClass:[YDCommand class]], @"必须是 YDCommand");
        if (aParame) {
            aParame((YDCommand *)obj);
        }
    }];
}
@end
