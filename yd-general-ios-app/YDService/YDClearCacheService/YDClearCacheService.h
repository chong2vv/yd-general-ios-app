//
//  YDClearCacheService.h
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDClearCacheService : NSObject

+ (instancetype)shared;

/**
 *  应用内清空所有磁盘缓存
 *
 *  @param clearBlock 清空缓存
 */
- (void)clearAllDiskOnCompletion:(void(^)(void))clearBlock;

/**
 *  清空Documents文件夹
 *
 *  @param clearBlock 清空缓存
 */
- (void)clearDocumentsOnCompletion:(void(^)(void))clearBlock;

/**
 *  磁盘缓存大小 与 clearAllDiskOnCompletion 对应
 */
- (CGFloat)diskAllCacheTotalCost;


/**
 *  磁盘缓存大小
 */
- (void)diskAllCacheTotalCompletion:(void(^)(CGFloat total, NSString *totalStr))totalBlock;


/**
 * 启动修复的 清除 触发启动修复时 应该删除的
 *
 */
- (void)startRepairOnCompletion:(void(^)(void))clearBlock;


/**
 *  启动App时清理数据
 */
- (void)startAppClearAllCacheCompletion:(void(^)(void))clearBlock;


@end

NS_ASSUME_NONNULL_END
