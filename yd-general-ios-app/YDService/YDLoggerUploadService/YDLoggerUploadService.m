//
//  YDLoggerUploadService.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/12.
//

#import "YDLoggerUploadService.h"
#import <SSZipArchive/SSZipArchive.h>
#import "YDUploadManager.h"

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
    NSMutableSet *zipSet = [NSMutableSet new];
    
    NSString *zipPath = [YDFileManager createDirectory:@"YDLoggerZip"];
    
    NSArray *zipfiles = [YDFileManager subpathsOfDirectoryAtPath:zipPath];
    // 将zip文件添加到上传队列中
    if (zipfiles) {
        for (int i = 0; i < (NSInteger)zipfiles.count; ++i) {
            @autoreleasepool {
                NSString *name = zipfiles[i];
                if ([name hasSuffix:@".zip"]) {
                    [zipSet addObject:name];
                }
            }
        }
    }
    
    NSArray *files = [[YDLogService shared] getAllLogFileData];
    //删除
    if (files) {
        for (int i=0; i<files.count; i++){
            NSLog(@"==== 循环第%d次 ====", i);
            NSString *name = [files objectAtIndex:i];
            if ([name isEqualToString:[YDMmapLogService shared].filePath.lastPathComponent]) {
                continue;
            }

            @autoreleasepool {
                NSString *zipName = [NSString stringWithFormat:@"%@.zip",[name componentsSeparatedByString:@"/"].lastObject];
                NSString *path = [NSString stringWithFormat:@"%@/%@",zipPath,zipName];
                // 查看是否已经压缩过，不要重复压缩
                if ([zipSet containsObject:zipName]) {
                    YDLogInfo(@"删除已压缩过的日志文件:%@", name);
                    continue;
                }

                if ([SSZipArchive createZipFileAtPath:path withFilesAtPaths:@[name]]) {
                    [zipSet addObject:zipName];
                    YDLogInfo(@"====== 压缩成功 =======");
                }else {
                    YDLogError(@"====== 压缩失败 =======");
                }
            }
        }
    }
    
//    [self _uploadZip:zipSet];
}

- (void)_uploadZip:(NSMutableSet *)zipSet {
    NSString *zipPath = [YDFileManager createDirectory:@"YDLoggerZip"];
    [zipSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *path = (NSString *)obj;
        [[YDUploadManager shared] addUploadFile:[NSString stringWithFormat:@"%@/%@",zipPath,path] forKey:@"YDLogger"];
    }];
    
    [[YDUploadManager shared] upload:@"" param:@{} process:^(WHC_BaseOperation * _Nullable operation, uint64_t recvLength, uint64_t totalLength, NSString * _Nullable speed) {
            
        } didFinished:^(WHC_BaseOperation * _Nullable operation, NSData * _Nullable data, NSError * _Nullable error, BOOL isSuccess) {
            if (isSuccess) {
                
            }
        }];
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
