//
//  YDCommand.h
//  YDNetworkManager
//
//  Created by wangyuandong on 2021/9/30.
//

#import <YTKNetwork/YTKNetwork.h>

/* 1.书写网络请求参数属性以 input_ 开头内部会自行拼接requestArgument 无需自己拼写参数
 * 2.返回200 OK 但带有服务端错误的处理 失败成功请覆盖 - (void)requestSuccess:(NSDictionary *)aDic; - (void)requestFailureEnd; 均在主线程处理。不要使用delegate方法 暂未处理
 * 3.YTK 的缓存处理不适用于部分应用场景，ignoreCache是一级判断 再通过 - (NSInteger)cacheTimeInSeconds方法来判断从网络走还是缓存走，无法实现先走缓存再走网络的实现。加入localCachefailureTime属性通过动态改变 localCachefailureTime 来实现，而cacheTimeInSeconds方法返回该值。拿缓存时设置无限大，走网络则看情况。
 */
@interface YDCommand : YTKRequest

// 本地缓存失效时间 为负数 无效  如果本地时间 － 缓存时间 超过 失效时间 也走网络
@property (nonatomic, assign) NSInteger localCachefailureTime;

//获取本次请求的所有参数
@property (nonatomic, strong) id allParmas;

//获取本次请求的header头
@property (nonatomic, strong) NSDictionary<NSString *,NSString *> *allHeader;

// 错误是服务端返回错误
@property (nonatomic, assign) BOOL isServiceError;

@property (nonatomic, strong, readonly) NSDictionary *requestParamsDic;


#pragma mark - 需重写的方法
// 配置默认参数，仅对以下提供的方法有用
- (void)defaultParame;

// 成功失败调用 请勿使用YTK的有额外处理
- (void)requestSuccess:(NSDictionary *)aDic;
- (void)requestFailureEnd;

// 缓存时 忽略参数 以及 添加额外参数
- (NSArray <NSString *> *)ignoreCacheParmasKeys;
- (NSDictionary <NSString *, NSString *> *)additionalCacheParmas;

+ (void)doTest;

#pragma mark - 提供简单的调用方法

#pragma mark - 为网络请求添加自己的缓存处理 为后面缓存的相关操作提供便利，代码中无需一级级向下传递，也可动态修改缓存数据
+ (instancetype)ydSaveDic:(NSDictionary *)dic toCommandSetParame:(YTKRequestCompletionBlock)aParame;

#pragma mark  普通调用方法
/**
 *  提供类方法直接调用
 *  @param aParame      该block用于参数设置
 *  @param aNext        成功失败都会走 如收回下拉刷新
 *  @param aSuccess     成功回调
 *  @param aFailure     失败回调
 */
+ (instancetype)ydCommandSetParame:(YTKRequestCompletionBlock)aParame completionWithNext:(YTKRequestCompletionBlock)aNext Success:(YTKRequestCompletionBlock)aSuccess failure:(YTKRequestCompletionBlock)aFailure;

/**
 *  提供类方法直接调用
 *  @param aParame      该block用于参数设置
 *  @param aSuccess     成功回调
 *  @param aFailure     失败回调
 */
+ (instancetype)ydCommandSetParame:(YTKRequestCompletionBlock)aParame completionWithSuccess:(YTKRequestCompletionBlock)aSuccess failure:(YTKRequestCompletionBlock)aFailure;

/**
 *  提供类方法直接调用
 *  @param aParame      该block用于参数设置
 *  @param aCompletion  完成后都会走该block，以属性 NSError *error 来区分成功失败
 */
+ (instancetype)ydCommandSetParame:(YTKRequestCompletionBlock)aParame completion:(YTKRequestCompletionBlock)aCompletion;

#pragma mark  先拿缓存再走数据调用方法 待添加准备用于先展示数据 然后下拉刷新使用
/**
 *  提供类方法直接调用
 *  @param aParame       该block用于参数设置  该方法中设置 localCachefailureTime 无效 aEnable为YES时请求localCachefailureTime=1
 *  @param aEnable       YES 使用先缓存后网络功能  NO则直接走网络  主要是基本只有第一次才需要使用YES
 *  @param aCache        YES 走网络网络时缓存数据， NO不缓存数据， 主要用于下拉刷新纪录缓存，加载更多不需要
 *  @param aRefresh      调用显示刷新动画
 *  @param aCompletion   完成后都会走该block，以属性 NSError *error 来区分成功失败  isDataFromCache 来区分是否从缓存走的
 */
+ (instancetype)ydCommandlocalSetParame:(YTKRequestCompletionBlock)aParame enable:(BOOL)aEnable saveCache:(BOOL)aCache refresh:(void (^)(void))aRefresh completion:(YTKRequestCompletionBlock)aCompletion;

#pragma mark  先展示缓存，保存网络数据 可设置 localCachefailureTime 来减缓请求的频率
/**
 *  提供类方法直接调用
 *  @param aParame       该block用于参数设置 可设置 localCachefailureTime 来减缓请求的频率
 *  @param ashowLoading  无缓存数据开始加载网络数据时调用
 *  @param aDismiss      无缓存数据结束加载网络数据时调用
 *  @param aCompletion   完成后都会走该block，以属性 NSError *error 来区分成功失败  isDataFromCache 来区分是否从缓存走的
 */
+ (instancetype)ydCommandlocalSetParame:(YTKRequestCompletionBlock)aParame showLoading:(void (^)(void))ashowLoading dismiss:(void (^)(void))aDismiss completion:(YTKRequestCompletionBlock)aCompletion;

+ (instancetype)ydCommandlocalSetParame:(YTKRequestCompletionBlock)aParame completion:(YTKRequestCompletionBlock)aCompletion;

/**
 *  提供类方法直接调用
 *  @param aParame       该block用于参数设置 可设置 localCachefailureTime 来减缓请求的频率
 *  @param ashowLoading  无缓存数据开始加载网络数据时调用
 *  @param aDismiss      无缓存数据结束加载网络数据时调用
 *  @param aCompletion   完成后只走一次 以属性 NSError *error 来区分成功失败  isDataFromCache 来区分是否从缓存走的
 */
+ (instancetype)ydCommandlocalCompletionSetParame:(YTKRequestCompletionBlock)aParame showLoading:(void (^)(void))ashowLoading dismiss:(void (^)(void))aDismiss completion:(YTKRequestCompletionBlock)aCompletion;

+ (instancetype)ydCommandlocalCompletionSetParame:(YTKRequestCompletionBlock)aParame completion:(YTKRequestCompletionBlock)aCompletion;

@end

