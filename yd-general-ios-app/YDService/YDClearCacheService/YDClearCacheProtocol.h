//
//  YDClearCacheProtocol.h
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/11.
//

#import <UIKit/UIKit.h>

@protocol YDClearCacheProtocol <NSObject>

// 单例对象
+ (instancetype)shared;

/*
 * 以下clearBlock 在清理完成后要调用
 */

@optional
/**
 *  清空缓存
 *
 *  清除所有缓存 回调在异步线程 需要自行处理
 *  @param clearBlock 清空缓存后处理
 */
- (void)clearDiskOnCompletion:(void(^)(void))clearBlock;

/**
 *  磁盘缓存大小 以 b 为单位
 */
- (CGFloat)diskCacheTotalCost;


// 启动修复的处理， 如不实现 就调用 clearDiskOnCompletion
- (void)startRepairDiskOnCompletion:(void(^)(void))clearBlock;


/**
 *  启动App时清理数据
 */
- (void)startAppClearCacheCompletion:(void(^)(void))clearBlock;

@end
