//
//  YDCommandConfig.m
//  YDNetworkManager
//
//  Created by wangyuandong on 2021/9/30.
//

#import "YDCommandConfig.h"
#import <YTKNetwork/YTKNetwork.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

#define kPageSize 20
#define kProtocolVersion @"1.0"

@interface YDCommandConfig ()<YTKCacheDirPathFilterProtocol>

@property (nonatomic, strong) NSString* tmpDirectory;
// 文件存储目录
@property (nonatomic, strong) NSString* fileCacheDirectory;

@property (nonatomic, copy) NSString *apiBaseURLString;
@property (nonatomic, copy) NSString *dataAcquisitionURLString;

@property(nonatomic, copy) NSDictionary * header;
@property(nonatomic, copy) NSDictionary * userAgent;

@property (nonatomic, copy) NSString *cachePath; // 网络缓存地址
@property (nonatomic, assign) NSUInteger maxCacheSize; // 最大缓存大小

// 本地时间与 服务器时间差
@property (nonatomic, assign)NSTimeInterval timeDifference;

@end

@implementation YDCommandConfig

+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    static YDCommandConfig* shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        [shared construct];
        
    });
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.apiBaseURLString = [YDCommandConfig configBaseUrl];
        self.dataAcquisitionURLString = [YDCommandConfig configDataAcquisitionURL];
        YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        config.baseUrl = self.apiBaseURLString;
        [config addCacheDirPathFilter:self];
#ifdef DEBUG
        config.debugLogEnabled = YES;
#endif
    }
    return self;
}

- (void)construct {
    self.protocolVersion = kProtocolVersion;
    //self.cachePath = [self.documentDirectory stringByAppendingPathComponent:@"StudioCommand"];
    self.maxCacheSize = 1 * 1024 * 1024;
}

- (void)updateTimeDifferenceByServiceTime:(NSTimeInterval)aServiceTime {
//    timeDifference
    if (aServiceTime <= 1487940000) {
        return;
    }
    NSTimeInterval localTime = [NSDate new].timeIntervalSince1970;
    self.timeDifference = aServiceTime - localTime;
}

#pragma mark - YTKCacheDirPathFilterProtocol
/* [config addCacheDirPathFilter:self];
 * 遵守该协议将缓存地址放到 documentDirectory下
 */
- (NSString *)filterCacheDirPath:(NSString *)originPath withRequest:(YTKBaseRequest *)request {
    return [YDCommandConfig configFilterCacheDirPath];
}

- (CGFloat)timeoutInterval {
    if (_timeoutInterval < 1.f) {
        _timeoutInterval = 5.f;
    }
    
    return _timeoutInterval;
}



- (NSDictionary <NSString *, NSString *>*)getCommandHeader {
    NSDictionary * dic = [YDCommandConfig configHeader];
    
    NSMutableDictionary *requestHeaders = [[NSMutableDictionary alloc] init];;
    if (dic) [requestHeaders setDictionary:dic];
    
    [requestHeaders setObject:[[UIDevice currentDevice] systemVersion] forKey:@"opertaion"];
    
    //设备名
    [requestHeaders setObject: [UIDevice currentDevice].name forKey:@"device"];
    [requestHeaders setObject: @"ios-skzs-mobile" forKey:@"devicetype"];
    
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [requestHeaders setObject:[NSString stringWithFormat:@"h%tu", (long)timestamp] forKey:@"imei"];
        [requestHeaders setObject:@"2" forKey:@"platform"];
    }
    else
    {
        [requestHeaders setObject:[NSString stringWithFormat:@"p%tu", (long)timestamp] forKey:@"imei"];
        [requestHeaders setObject:@"3" forKey:@"platform"];
    }
    
    
    [requestHeaders setObject:[NSString stringWithFormat:@"%tu", (long)(timestamp*1000.)] forKey:@"timestamp"];
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN)
    {
        [requestHeaders setObject:@"2" forKey:@"network"];
    }
    else if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi)
    {
        [requestHeaders setObject:@"1" forKey:@"network"];
    }
    else
    {
        [requestHeaders setObject:@"1" forKey:@"network"];
    }
    
    NSString *ua = [self getUserAgent];
    if (ua.length > 0) {
        [requestHeaders setObject:ua forKey:@"useragent"];
    }
    return requestHeaders;
}

- (NSString *)getUserAgent
{
    NSDictionary * blockDic = [YDCommandConfig configUserAgent];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (blockDic) [dic setDictionary:blockDic];

    NSMutableArray *arr = [NSMutableArray array];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,obj];
        [arr addObject:str];
    }];
    NSString *queryStr = [arr componentsJoinedByString:@"&"];
    return queryStr;
}

- (NSDictionary *)getUserAgentDic
{
    NSDictionary * blockDic = [YDCommandConfig configUserAgent];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (blockDic) [dic setDictionary:blockDic];

    
    return dic;
}

#pragma mark - ReadOnly property getter
- (NSString *)documentDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSString *)cacheDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSString *)tmpDirectory {
    return NSTemporaryDirectory();
}

- (NSString *)fileCacheDirectory {
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString * fileCachePath = [self.cacheDirectory stringByAppendingPathComponent:@"filecache"];
    if (![fm fileExistsAtPath:fileCachePath]) {
        [fm createDirectoryAtPath:fileCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return fileCachePath;
}



- (NSInteger)pageSize {
    if (!_pageSize) {
        return kPageSize;
    }
    return _pageSize;
}

- (NSString *)pageSizeString {
    if (!_pageSizeString || _pageSizeString.length == 0) {
        return [NSString stringWithFormat:@"%d", kPageSize];
    }
    return _pageSizeString;
}



#pragma mark - 此处为外部配置方法, 这里只是做占位, 具体内容需要外部分类中重写
+ (NSString *)configBaseUrl {
    return @"";
}
+ (NSString *)configDataAcquisitionURL {
    return @"";
}
+ (NSDictionary<NSString *,NSString *> *)configHeader {
    return nil;
}
+ (NSDictionary<NSString *,NSString *> *)configUserAgent {
    return nil;
}
+ (NSString *)configFilterCacheDirPath {
    return nil;
}

+ (void)configRequestCompleteFilter:(YDCommand *)command {}
+ (void)configRequestFailedFilter:(YDCommand *)command {}

@end
