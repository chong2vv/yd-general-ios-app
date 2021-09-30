//
//  YDCommandConfig.h
//  YDNetworkManager
//
//  Created by wangyuandong on 2021/9/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YDCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDCommandConfig : NSObject

// 服务器主地址
@property (nonatomic, copy, readonly) NSString *apiBaseURLString;
// 数据统计服务器地址
@property (nonatomic, copy, readonly) NSString *dataAcquisitionURLString;
// 与服务器的协议版本号
@property (nonatomic, copy) NSString *protocolVersion;

// 分页数
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, copy) NSString *pageSizeString;

// 超时时间
@property (nonatomic, assign)CGFloat timeoutInterval;

// 本地时间与 服务器时间差
@property (nonatomic, assign, readonly)NSTimeInterval timeDifference;

@property (nonatomic, strong, readonly) NSString* documentDirectory;
@property (nonatomic, strong, readonly) NSString* cacheDirectory;
@property (nonatomic, strong, readonly) NSString* fileCacheDirectory;
@property (nonatomic, strong, readonly) NSString* tmpDirectory;


+ (instancetype)shared;


/**
 配置根路径

 @param url 根路径
 */
+ (NSString *)configBaseUrl;

/**
 配置java版的统计地址

 @param url 地址
 */
+ (NSString *)configDataAcquisitionURL;

+ (NSDictionary <NSString *, NSString *> *)configHeader;

/**
 配置userAgent

 @param info userAgent
 */
+ (NSDictionary <NSString *, NSString *> *)configUserAgent;

+ (NSString *)configFilterCacheDirPath;

+ (void)configRequestCompleteFilter:(YDCommand *)command;
+ (void)configRequestFailedFilter:(YDCommand *)command;

- (void)updateTimeDifferenceByServiceTime:(NSTimeInterval)aServiceTime;



- (NSDictionary <NSString *, NSString *>*)getCommandHeader;

- (NSString *)getUserAgent;
- (NSDictionary *)getUserAgentDic;
@end

NS_ASSUME_NONNULL_END
