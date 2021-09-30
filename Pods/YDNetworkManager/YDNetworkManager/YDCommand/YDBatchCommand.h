//
//  YDBatchCommand.h
//  YDNetworkManager
//
//  Created by wangyuandong on 2021/9/30.
//

#import <YTKNetwork/YTKNetwork.h>
#import "YDCommand.h"
#import <UIKit/UIKit.h>

@class YDBatchCommand;
typedef void(^YDBatchRequestCompletionBlock)(__kindof YDBatchCommand *request);

@interface YDBatchCommand : YTKBatchRequest

@property (nonatomic, strong, readonly) NSError *lastError;

#pragma mark  普通调用方法
/**
 *  提供类方法直接调用
 *  @param aCommands      设置需要的网络请求数组
 *  @param aCompletion  完成后都会走该block，以属性 NSError *error 来区分成功失败
 */
+ (instancetype)ydBatchRequestArray:(NSArray<YDCommand *>*)aCommands completion:(YDBatchRequestCompletionBlock)aCompletion;
/**
 *  提供类方法直接调用
 *  @param aCommands      设置需要的网络请求数组
 *  @param aSuccess     成功回调
 *  @param aFailure     失败回调
 */
+ (instancetype)ydBatchRequestArray:(NSArray<YDCommand *>*)aCommands success:(YDBatchRequestCompletionBlock)aSuccess failure:(YDBatchRequestCompletionBlock)aFailure;

/**
 *  提供类方法直接调用
 *  @param aCommands      设置需要的网络请求数组
 *  @param aNext        成功失败都会走 如收回下拉刷新
 *  @param aSuccess     成功回调
 *  @param aFailure     失败回调
 */
+ (instancetype)ydBatchRequestArray:(NSArray<YDCommand *>*)aCommands withNext:(YDBatchRequestCompletionBlock)aNext success:(YDBatchRequestCompletionBlock)aSuccess failure:(YDBatchRequestCompletionBlock)aFailure;

/**
 *  提供类方法直接调用
 *  @param aCommands     设置需要的网络请求数组
 *  @param aEnable       YES 使用先缓存后网络功能  NO则直接走网络  主要是基本只有第一次才需要使用YES
 *  @param aCache        YES 走网络网络时缓存数据， NO不缓存数据， 主要用于下拉刷新纪录缓存，加载更多不需要
 *  @param aRefresh      调用显示刷新动画
 *  @param aCompletion   完成后都会走该block，以属性 NSError *error 来区分成功失败  isDataFromCache 来区分是否从缓存走的
 */
+ (instancetype)ydBatchLocalRequestArray:(NSArray<YDCommand *>*)aCommands enable:(BOOL)aEnable saveCache:(BOOL)aCache refresh:(void (^)(void))aRefresh completion:(YDBatchRequestCompletionBlock)aCompletion;

@end


