//
//  YDLoggerUploadService.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/12.
//

#import "YDLoggerUploadService.h"
#import <SSZipArchive/SSZipArchive.h>

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation YDLoggerUploadService

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static id shared = nil;
    dispatch_once(&onceToken, ^{
         shared = [[self alloc] init];
    });
    return shared;
}

- (void)uploadLoggerZIP {
    [[YDLogService shared] getAllLogFileData];
    
    // 获取zipDir下的所有zip文件
    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableSet *zipSet = [NSMutableSet new];
    NSArray *files = [[YDLogService shared] getAllLogFileData];
    // 将zip文件添加到上传队列中
    if (files) {
        for (int i = 0; i < (NSInteger)files.count; ++i) {
            @autoreleasepool {
                NSString *name = files[i];
                if ([name hasSuffix:@".zip"]) {
                    [zipSet addObject:name];
                }
            }
        }
    }
    
    if (files) {
        for (NSString *name in files) {
            if ([name isEqualToString:[YDMmapLogService shared].filePath.lastPathComponent]) {
                continue;
            }
            
            @autoreleasepool {
                NSString *path = [NSString stringWithFormat:@"%@.zip",name];
                
//                // 查看是否已经压缩过，不要重复压缩
//                if ([zipSet containsObject:path]) {
//                    [fm removeItemAtPath:name error:nil];
//                    [zipSet removeObject:path];
//                    YDLogInfo(@"删除已压缩过的日志文件:%@", name);
//                    continue;
//                }
//                
//                if ([SSZipArchive createZipFileAtPath:path withFilesAtPaths:[[YDLogService shared] getAllLogFileData]]) {
//                    YDLogError(@"====== 压缩成功 =======");
//                }else {
//                    YDLogError(@"====== 压缩失败 =======");
//                }
                
            }
        }
    }
    
}

// 创建文件夹
- (NSString *)_createDirectory:(NSString *)dirName {
    
    // 获取文件夹目录：Document/dirName
    NSURL *documentDir = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSString *fileDir = [[documentDir path] stringByAppendingFormat:@"%@", dirName];
    
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

@end
