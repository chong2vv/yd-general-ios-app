//
//  YDFileManager.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/13.
//

#import "YDFileManager.h"

@implementation YDFileManager

// 创建文件夹
+ (NSString *)createDirectory:(NSString *)dirName {
    
    // 获取文件夹目录：Document/dirName
    NSURL *documentDir = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSString *fileDir = [[documentDir path] stringByAppendingFormat:@"/%@", dirName];
    
    // 创建文件夹
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileDir] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:&error];
        NSURL *url = [NSURL fileURLWithPath:fileDir];
        [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    }
    
    if (error)
        YDLogError(@"创建目录失败:%@ error:%@", dirName, error);
    
    return fileDir;
}

+ (BOOL)deleteDirectory:(NSString *)dirName {
    NSURL *documentDir = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSString *fileDir = [[documentDir path] stringByAppendingFormat:@"/%@", dirName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm removeItemAtPath:fileDir error:nil];
}

+ (NSArray *)subpathsOfDirectoryAtPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *fileNames = [fm subpathsOfDirectoryAtPath:path error:nil];
    return fileNames;
}

+ (NSArray *)getAllFilePaths:(NSString *)dirName {
    NSURL *documentDir = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *fileDir = [[documentDir path] stringByAppendingFormat:@"/%@", dirName];
    NSArray *fileNames = [fm subpathsOfDirectoryAtPath:fileDir error:nil];
    return fileNames;
}

@end
