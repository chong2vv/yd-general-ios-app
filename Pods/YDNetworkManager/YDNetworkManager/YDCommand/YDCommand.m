//
//  YDCommand.m
//  YDNetworkManager
//
//  Created by wangyuandong on 2021/9/30.
//

#import "YDCommand.h"
#import "YDCommandConfig.h"
#import "YDCommand+YDError.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@interface YDCommand ()

// 单写多读
@property (atomic, assign) BOOL isSaveCache;
@property (nonatomic, strong, readwrite) NSDictionary *requestParamsDic;

@end

@implementation YDCommand

- (instancetype)init {
    if (self = [super init]) {
        [YDCommandConfig shared]; //保证被配置
    }
    return self;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 15.f;
}

// 我们的请求基本都是post
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

// 参数绑定
- (id)requestArgument {
    return [self requestParams];
}

//获取请求的所有参数信息
- (id)allParmas
{
    return [self requestArgument];
}

- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    NSAssert([argument isKindOfClass:[NSDictionary class]], @"绑定参数是字典");
    if ([self ignoreCacheParmasKeys] == nil && [self additionalCacheParmas] == nil) {
        return [super cacheFileNameFilterForRequestArgument:argument];
    }
    NSMutableDictionary *dicM = [argument mutableCopy];
    [[self ignoreCacheParmasKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dicM removeObjectForKey:obj];
    }];
    
    NSDictionary *additional = [self additionalCacheParmas];
    if (additional.count > 0) {
        [dicM addEntriesFromDictionary:additional];
    }
    
    return [dicM copy];
}

// header头添加
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    if (_allHeader == nil) {
        _allHeader = [[YDCommandConfig shared] getCommandHeader];
    }
    return _allHeader;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}

// 缓存时间问题
- (NSInteger)cacheTimeInSeconds {
    return self.localCachefailureTime;
}

///// 做一些额外的解析处理
- (void)requestCompleteFilter {
    // super 实际什么都没干
    [super requestCompleteFilter];
    NSError *error = nil;
    id object = self.responseJSONObject;
    if (object && ![object isKindOfClass:[NSDictionary class]]) {
        error = [NSError errorWithDomain:@"服务端返回的数据怎么不是字典" code:1 userInfo:@{NSLocalizedDescriptionKey : @"服务端返回的数据怎么不是字典"}];
    }else {
        NSDictionary *dic = (NSDictionary *)object;
        NSInteger status = [dic[@"status"] integerValue];
        
        NSNumber *curtime = dic[@"curtime"];
        if (curtime == nil) {
            NSHTTPURLResponse *re = (NSHTTPURLResponse *)self.requestTask.response;
            if ([re isKindOfClass:[NSHTTPURLResponse class]]) {
                NSDictionary *header = [re allHeaderFields];
                curtime = header[@"curtime"];
                if (!curtime) {
                    static NSDateFormatter *formatter = nil;
                    static dispatch_once_t onceToken;
                    dispatch_once(&onceToken, ^{
                        formatter = [[NSDateFormatter alloc] init];
                        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                        formatter.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
                        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                        formatter.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                    });
                    NSString *dateString = header[@"Date"];
                    if (dateString) {
                        NSDate *date = [formatter dateFromString:dateString];
                        if (date) {
                            curtime = @(date.timeIntervalSince1970);
#ifdef DEBUG
                            NSTimeInterval interval = curtime.doubleValue - NSDate.date.timeIntervalSince1970;
                            if (fabs(interval) >= 5) {
                                NSMutableString *log = @"\n❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌".mutableCopy;
                                [log appendString:@"\n❌服务器时间和本地时间差异过大"];
                                [log appendFormat:@"\n❌服务器时间:%@",dateString];
                                [log appendFormat:@"\n❌转换后时间:%@",date];
                                [log appendFormat:@"\n❌时间戳:%@",curtime];
                                [log appendFormat:@"\n❌时间差:%lf",interval];
                                [log appendString:@"\n❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"];
                                NSLog(@"%@",log);
                            }
#endif
                        }
                    }
                }
            }
        }
        
        if (!self.isDataFromCache) {
            if (curtime) {
                [[YDCommandConfig shared] updateTimeDifferenceByServiceTime:[curtime doubleValue]];
            }
        }
    
        
        if ( status != 0) {
            error = [NSError errorWithDomain:dic[@"msg"] code:[dic[@"status"] integerValue] userInfo:@{NSLocalizedDescriptionKey : dic[@"msg"]}];
            // 处理服务端数据错误
            if (status < 0 && !self.isDataFromCache) { // status < 0 并且数据不是从缓存拿的
                [self dealWithServiceErrorStatus:status userInfo:dic];
            }
            self.isServiceError = YES;
        }
    }
    
    if (error == nil) {
        // 日志
        [YDCommandConfig configRequestCompleteFilter:self];
        [self requestSuccess:object];
        return;
    }
    
    // 设置错误 取消成功的block回调 调用失败的block
    [self setValue:error forKey:@"error"];
    NSLog(@"%@",error);
    [self requestFailedFilter];
    
    // YTK成功自己会掉不用多调用一次
//    if (self.failureCompletionBlock) {
//        self.failureCompletionBlock(self);
//    }
//    YTK 内部有处理，这里提前nil 可能会导致异步缓存出错
//    self.failureCompletionBlock = nil;
//    self.successCompletionBlock = nil;
}


///  Called on the main thread when request failed.
- (void)requestFailedFilter {
    // 日志
    [YDCommandConfig configRequestFailedFilter:self];
    NSLog(@"%@_%@",self.requestUrl,self.requestArgument);
    NSLog(@"%@",self.error);
    if (self.error.code == 3840) {
        if ([self.responseData isKindOfClass:[NSData class]]) {
//            NSString *jsonstr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
//            [[YDLogCollectService shared] logCollectDescribe:jsonstr];
            NSString *errorstr = [NSString stringWithFormat:@"Request %@ failed, status code = %ld, error = %@",
                                  self.requestUrl, (long)self.responseStatusCode, self.error.localizedDescription];
//             [[YDLogCollectService shared] logCollectDescribe:errorstr];
            if (errorstr.length > 80) {
                errorstr = [errorstr substringToIndex:78];
            }
            NSError *error = [NSError errorWithDomain:@"解析错误" code:3840 userInfo:@{NSLocalizedDescriptionKey:errorstr}];
            [self setValue:error forKey:@"error"];
        }
    }
    [self requestFailureEnd];
}

//- (void)requestCompletePreprocessor {
//    [super requestCompletePreprocessor];
//}

////这里暂不考虑JSONModel解析错误的问题
//- (void)requestFailedPreprocessor
//{
//    //note：子类如需继承，必须必须调用 [super requestFailedPreprocessor];
//    [super requestFailedPreprocessor];
//
//    NSError * error = self.error;
//
//    if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain])
//    {
//        //AFNetworking处理过的错误
//
//    }else if ([error.domain isEqualToString:YTKRequestValidationErrorDomain])
//    {
//        //猿题库处理过的错误
//
//    }else{
//        //系统级别的domain错误，无网络等[NSURLErrorDomain]
//        //根据error的code去定义显示的信息，保证显示的内容可以便捷的控制
//    }
//}

// 异步缓存 requestParams 使用了运行时可能导致 释放问题以此处理
- (void)saveResponseDataToCacheFile:(NSData *)data {
    self.isSaveCache = YES;
    [super saveResponseDataToCacheFile:data];
    self.isSaveCache = NO;
}

#pragma mark - 需重写的方法
// 配置默认参数，仅对以下提供的方法有用
- (void)defaultParame {

}

- (void)requestSuccess:(NSDictionary *)aDic {

}

- (void)requestFailureEnd {

}

+ (void)doTest
{
    
}

// 缓存时 忽略参数 以及 添加额外参数
- (NSArray <NSString *> *)ignoreCacheParmasKeys {
    return nil;
}

- (NSDictionary <NSString *, NSString *> *)additionalCacheParmas {
    return nil;
}

#pragma mark - 提供简单的调用方法
#pragma mark - 为网络请求添加自己的缓存处理 为后面缓存的相关操作提供便利，代码中无需一级级向下传递，也可动态修改缓存数据
+ (instancetype)ydSaveDic:(NSDictionary *)dic toCommandSetParame:(YTKRequestCompletionBlock)aParame {
    if (dic == nil) {
        return nil;
    }
    YDCommand *aCmd = [[self alloc] init];
    [aCmd defaultParame];
    if (aParame) {
        aParame(aCmd);
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    [aCmd saveResponseDataToCacheFile:data];
    return aCmd;
}

+ (instancetype)ydCommandSetParame:(YTKRequestCompletionBlock)aParame completion:(YTKRequestCompletionBlock)aCompletion {

    return [self ydCommandSetParame:aParame completionWithSuccess:aCompletion failure:aCompletion];
}

+ (instancetype)ydCommandSetParame:(YTKRequestCompletionBlock)aParame completionWithSuccess:(YTKRequestCompletionBlock)aSuccess failure:(YTKRequestCompletionBlock)aFailure {
    
    return [self ydCommandSetParame:aParame completionWithNext:nil Success:aSuccess failure:aFailure];
}

+ (instancetype)ydCommandSetParame:(YTKRequestCompletionBlock)aParame completionWithNext:(YTKRequestCompletionBlock)aNext Success:(YTKRequestCompletionBlock)aSuccess failure:(YTKRequestCompletionBlock)aFailure {
    
    YDCommand *aCmd = [[self alloc] init];
    [aCmd defaultParame];
    if (aParame) {
        aParame(aCmd);
    }
    
    YTKRequestCompletionBlock success = ^(YTKBaseRequest *request) {
       
        if (aCmd.localCachefailureTime <= 2 &&  aCmd.isDataFromCache) {
            [aCmd setValue:[NSNumber numberWithBool:NO] forKey:@"dataFromCache"];
        }
        if (aNext) {
            aNext(aCmd);
        }
        
        if (request.error) {
            
            if (aFailure) {
                aFailure(aCmd);
            }
            
        }else {
            
            if (aSuccess) {
                aSuccess(aCmd);
            }
            
        }
        
    };
    
    YTKRequestCompletionBlock failure = aNext == nil ? aFailure : ^(YTKBaseRequest *request) {
        aNext(aCmd);
        if (aFailure) {
            aFailure(aCmd);
        }
    };
    
    [aCmd startWithCompletionBlockWithSuccess:success failure:failure];
    return aCmd;
}

#pragma mark  先拿缓存再走数据调用方法 待添加准备用于先展示数据 然后下拉刷新使用待后面考虑如何处理
+ (instancetype)ydCommandlocalSetParame:(YTKRequestCompletionBlock)aParame enable:(BOOL)aEnable saveCache:(BOOL)aCache refresh:(void (^)(void))aRefresh completion:(YTKRequestCompletionBlock)aCompletion {
    
    if (!aEnable) {
        return [self ydCommandSetParame:^(__kindof YDCommand * _Nonnull request) {
            if (aParame) {
                aParame(request);
            }
            request.localCachefailureTime = aCache ? 1 : -1;
        }completion:aCompletion];
    }
    
    YDCommand *aCmd = [[self alloc] init];
    aCmd.ignoreCache = NO;
    [aCmd defaultParame];
    if (aParame) {
        aParame(aCmd);
    }
    //记录原来值 因为取缓存要无限大
    aCmd.localCachefailureTime = 60 * 60 * 24 * 365;
    
    NSError *error = nil;
    if ([aCmd loadCacheWithError:&error]) {
        if (error == nil) {
            [aCmd setValue:[NSNumber numberWithBool:YES] forKey:@"dataFromCache"];
            [aCmd requestCompleteFilter];
            if (aCompletion) {
                aCompletion(aCmd);
            }
        }
    }
    
    // 要使用缓存 必须大于0
    aCmd.localCachefailureTime = 1;
    [UIView setAnimationsEnabled:NO];
    if (aRefresh) {
        aRefresh();
    }
    [UIView setAnimationsEnabled:YES];
    NSDate *startDate = [NSDate date];
    YTKRequestCompletionBlock block = aCompletion == nil ? aCompletion : ^(YDCommand *request) {
        // 强制认为不是从缓存走的
        [aCmd setValue:[NSNumber numberWithBool:NO] forKey:@"dataFromCache"];
        NSTimeInterval time = - [startDate timeIntervalSinceNow];
        // 时间判断是为了更好的UI体验
        if (time < 0.2) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                aCompletion(aCmd);
            });
        }else {
            aCompletion(aCmd);
        }
    };
    [aCmd startWithCompletionBlockWithSuccess:block failure:block];
    return aCmd;
}

#pragma mark  先展示缓存，保存网络数据 可设置 localCachefailureTime 来减缓请求的频率
+ (instancetype)ydCommandlocalSetParame:(YTKRequestCompletionBlock)aParame completion:(YTKRequestCompletionBlock)aCompletion {
    return [self ydCommandlocalSetParame:aParame showLoading:nil dismiss:nil completion:aCompletion];
}

+ (instancetype)ydCommandlocalSetParame:(YTKRequestCompletionBlock)aParame showLoading:(void (^)(void))ashowLoading dismiss:(void (^)(void))aDismiss completion:(YTKRequestCompletionBlock)aCompletion {
    return [self ydCommandlocalSetParame:aParame completionFirst:NO showLoading:ashowLoading dismiss:aDismiss completion:aCompletion];
}

+ (instancetype)ydCommandlocalCompletionSetParame:(YTKRequestCompletionBlock)aParame completion:(YTKRequestCompletionBlock)aCompletion {
    return [self ydCommandlocalCompletionSetParame:aParame showLoading:nil dismiss:nil completion:aCompletion];
}

+ (instancetype)ydCommandlocalCompletionSetParame:(YTKRequestCompletionBlock)aParame showLoading:(void (^)(void))ashowLoading dismiss:(void (^)(void))aDismiss completion:(YTKRequestCompletionBlock)aCompletion {
    return [self ydCommandlocalSetParame:aParame completionFirst:YES showLoading:ashowLoading dismiss:aDismiss completion:aCompletion];
}

+ (instancetype)ydCommandlocalSetParame:(YTKRequestCompletionBlock)aParame completionFirst:(BOOL)aFirst showLoading:(void (^)(void))ashowLoading dismiss:(void (^)(void))aDismiss completion:(YTKRequestCompletionBlock)aCompletion {

    YDCommand *aCmd = [[self alloc] init];
    aCmd.ignoreCache = NO;
    [aCmd defaultParame];
    if (aParame) {
        aParame(aCmd);
    }
    //记录原来值 因为取缓存要无限大
    NSInteger localCachefailureTime = aCmd.localCachefailureTime;
    aCmd.localCachefailureTime = 60 * 60 * 24 * 365;
    
    BOOL needShow = YES;
    NSError *error = nil;
    if ([aCmd loadCacheWithError:&error]) {
        if (error == nil) {
            [aCmd setValue:[NSNumber numberWithBool:YES] forKey:@"dataFromCache"];
            [aCmd requestCompleteFilter];
            if (aCompletion) {
                aCompletion(aCmd);
            }
            needShow = NO;
        }
    }
    
    // 要使用缓存 必须大于0
    aCmd.localCachefailureTime = localCachefailureTime <= 0 ? 1 : localCachefailureTime;
    
    if (needShow && ashowLoading) {
        ashowLoading();
    }
    
    YTKRequestCompletionBlock block = aCompletion == nil ? aCompletion : ^(YTKBaseRequest *request) {
        if (aDismiss) {
            aDismiss();
        }
        // 走缓存就不再回调
        if (aCmd.isDataFromCache) {
            return;
        }
        // aFirst 只走一次回调
        if (aFirst && !needShow) {
            return;
        }
        
        // 有缓存 请求错误则不予处理
        if (!needShow && request.error) {
            return;
        }

        aCompletion(aCmd);
    };
    [aCmd startWithCompletionBlockWithSuccess:block failure:block];
    return aCmd;
}

#pragma mark - 获取类属性，用于参数自动拼接
- (NSDictionary *)requestParams {
    
    if (self.isSaveCache && self.requestParamsDic) {
        return self.requestParamsDic;
    }
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (NSInteger index = 0; index < outCount; index++) {
        NSString *tmpName = [NSString stringWithFormat:@"%s",property_getName(properties[index])];
        NSObject *tmpValue = [self valueForKey:tmpName];
        
        NSString* prefix = @"input_";
        if (tmpValue && [tmpName hasPrefix:prefix]) {
            NSString* key = [tmpName substringFromIndex:prefix.length];
//            if ([tmpValue isKindOfClass:[NSNumber class]]) {
//                if ([((NSNumber *)tmpValue) integerValue] <= 0.001) {
//                    continue;
//                }
//            }
            [dicM setObject:tmpValue forKey:key];
        }
    }
    
    if (properties) {
        free(properties);
    }
    NSDictionary *dic = [dicM copy];
    self.requestParamsDic = dic;
    return dic;
}

- (void)dealloc {
#ifdef DEBUG
//    NSLog(@"%s",__func__);
#endif
}


@end
