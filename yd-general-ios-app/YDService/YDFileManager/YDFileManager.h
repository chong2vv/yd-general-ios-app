//
//  YDFileManager.h
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 YDFileManage都是针对Document下文件操作
 */

@interface YDFileManager : NSObject
// 获取文件夹目录：Document/dirName
+ (NSString *)createDirectory:(NSString *)dirName;

// 删除指定文件
+ (BOOL)deleteDirectory:(NSString *)dirName;

// 获取指定路径下全部文件路径
+ (NSArray *)subpathsOfDirectoryAtPath:(NSString *)path;

// 获取指定文件夹下全部文件路径
+ (NSArray *)getAllFilePaths:(NSString *)dirName;

@end

NS_ASSUME_NONNULL_END
