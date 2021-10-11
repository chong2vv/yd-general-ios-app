//
//  YDClearCacheService.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/11.
//

#import "YDClearCacheService.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <sys/mount.h>
#import "YDClearCacheProtocol.h"
#import "YDClearCacheConfig.h"

#define kCacheClass   @"kCacheClass"
#define kCacheTitle   @"kCacheTitle"
@interface YDClearCacheService ()<YDClearCacheProtocol>

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *cacheArrayM;

@end

@implementation YDClearCacheService

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static id shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (instancetype)init{
    if (self = [super init]) {
        [self registClass:[self class] title:@"临时文件夹"];
        
        NSArray * classArr = [YDClearCacheConfig configCache];
        if (classArr && classArr.count > 0) {
            for (NSDictionary *claDic in classArr) {
                if ([claDic.allKeys containsObject:@"class"]) {
                    NSString * className = claDic[@"class"];
                    if ([claDic.allKeys containsObject:@"title"]) {
                        [self registClass:NSClassFromString(className) title:claDic[@"title"]];
                    }
                }
            }
        }
    }
    return self;
}

// 注册缓存清理类
- (void)registClass:(Class)aClass title:(NSString *)aTitle{
    NSDictionary *dic = @{kCacheClass : aClass, kCacheTitle : aTitle};
    [self.cacheArrayM addObject:dic];
}


#pragma mark - 缓存清理
- (BOOL)clearForClass:(Class)aClass{
    return YES;
}

/**
 *  清空所有磁盘缓存
 *
 *  @param clearBlock 清空缓存
 */
- (void)clearAllDiskOnCompletion:(void(^)(void))clearBlock{
    
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
         // 调度组
         dispatch_group_t group = dispatch_group_create();
         [self.cacheArrayM enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             Class aClass = obj[kCacheClass];
             id<YDClearCacheProtocol> cache;
             if ([aClass respondsToSelector:@selector(shared)]) {
                 cache = [aClass shared];
             } else {
                 cache = [[aClass alloc] init];
             }
             if ([cache respondsToSelector:@selector(clearDiskOnCompletion:)]){
                 if ([self clearForClass:aClass]) {
                     dispatch_group_enter(group);
                     [cache clearDiskOnCompletion:^{
                         dispatch_group_leave(group);
                     }];
                 }
             }
         }];
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
         if (clearBlock) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 clearBlock();
             });
         }
     });
}

/**
 * 启动修复的 清除
 *
 */
- (void)startRepairOnCompletion:(void(^)(void))clearBlock{
    
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 调度组
        dispatch_group_t group = dispatch_group_create();
        [self.cacheArrayM enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Class aClass = obj[kCacheClass];
            id<YDClearCacheProtocol> cache;
            if ([aClass respondsToSelector:@selector(shared)]) {
                cache = [aClass shared];
            } else {
                cache = [[aClass alloc] init];
            }
            
            if ([cache respondsToSelector:@selector(startRepairDiskOnCompletion:)]) {
                
                dispatch_group_enter(group);
                [cache startRepairDiskOnCompletion:^{
                    dispatch_group_leave(group);
                }];
                
            }else if ([cache respondsToSelector:@selector(clearDiskOnCompletion:)]){
                
                dispatch_group_enter(group);
                [cache clearDiskOnCompletion:^{
                    dispatch_group_leave(group);
                }];
            }
            
        }];
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
       
         if (clearBlock) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 clearBlock();
             });
         }
     });
}

/**
 *  启动App时清理数据
 */
- (void)startAppClearAllCacheCompletion:(void(^)(void))clearBlock {
    
    NSInteger limtSize = 100;
    if ([self freeDiskSpaceInMB] <= limtSize) {
        [self diskAllCacheTotalCompletion:^(CGFloat total, NSString *totalStr) {
            NSString *message = [NSString stringWithFormat:@"内置存储空间已 <= %tuMB,为保证流畅使用请清除缓存。",limtSize];

            UIViewController * rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;

            UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"存储已满" message:message preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction * clearAction = [UIAlertAction actionWithTitle:@"清除缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIAlertController * cleaningVC = [self p_showLoding:@"正在清理"];
                [[YDClearCacheService shared] clearAllDiskOnCompletion:^{
                    [cleaningVC dismissViewControllerAnimated:YES completion:^{
                        UIAlertController * cleanedVC = [self p_showLoding:@"清理完成"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [cleanedVC dismissViewControllerAnimated:YES completion:nil];
                        });
                    }];
                }];
            }];
            [ac addAction:cancelAction];
            [ac addAction:clearAction];
            [rootVC presentViewController: ac animated: YES completion: nil];
        }];
        return;
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 调度组
        dispatch_group_t group = dispatch_group_create();
        [self.cacheArrayM enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Class aClass = obj[kCacheClass];
            id<YDClearCacheProtocol> cache;
            if ([aClass respondsToSelector:@selector(shared)]) {
                cache = [aClass shared];
            } else {
                cache = [[aClass alloc] init];
            }
            if ([cache respondsToSelector:@selector(startAppClearCacheCompletion:)]){
                dispatch_group_enter(group);
                [cache startAppClearCacheCompletion:^{
                    dispatch_group_leave(group);
                }];
            }
        }];
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

        if (clearBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                clearBlock();
            });
        }
    });
}

/**
 *  所有磁盘缓存大小
 */
- (CGFloat)diskAllCacheTotalCost{
    
    __block NSUInteger total = 0.;
    [self.cacheArrayM enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class aClass = obj[kCacheClass];
        id<YDClearCacheProtocol> cache;
        if ([aClass respondsToSelector:@selector(shared)]) {
            cache = [aClass shared];
        } else {
            cache = [[aClass alloc] init];
        }
        
        if ([cache respondsToSelector:@selector(diskCacheTotalCost)]) {
            if ([self clearForClass:aClass]) {
                CGFloat cachTotalCoste = [cache diskCacheTotalCost];
                NSLog(@"%@---%.02f",obj[kCacheTitle],cachTotalCoste / 1024. / 1024.);
                total += cachTotalCoste;
            }
        }
    }];
    return total;
}

- (void)diskAllCacheTotalCompletion:(void(^)(CGFloat total, NSString *totalStr))totalBlock{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CGFloat total = [self diskAllCacheTotalCost] / 1024. / 1024.;
        NSString *totalStr = [NSString stringWithFormat:@"%.02f MB",total];
        
        if (totalBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                totalBlock(total,totalStr);
            });
        }
    });
}

#pragma mark - 自己负责 清理临时文件夹
/**
 *  清空缓存
 *
 *  @param clearBlock 清空缓存
 */
- (void)clearDiskOnCompletion:(void(^)(void))clearBlock{
    
    NSString *filePath = NSTemporaryDirectory();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if ([fileMgr fileExistsAtPath:filePath]) {
            NSArray *subFileArray = [fileMgr contentsOfDirectoryAtPath:filePath error:nil];
            for (NSString *subFileName in subFileArray) {
                NSString *subFilePath = [filePath stringByAppendingPathComponent:subFileName];
                if ([fileMgr removeItemAtPath:subFilePath error:nil]) {
                    NSLog(@"removed file path:%@", subFilePath);
                } else {
                    NSLog(@"failed to remove file path:%@", subFilePath);
                }
            }
        } else {
            NSLog(@"failed to remove non-existing file path:%@", filePath);
        }
    
        if (clearBlock) {
            clearBlock();
        }
    });
}

/**
 *  清空Documents文件夹
 *
 *  @param clearBlock 清空缓存
 */
- (void)clearDocumentsOnCompletion:(void(^)(void))clearBlock{
  
 // NSString *filePath = NSTemporaryDirectory();
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *filePath = [paths objectAtIndex:0];
  
  dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
  dispatch_async(queue, ^{
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:filePath]) {
      NSArray *subFileArray = [fileMgr contentsOfDirectoryAtPath:filePath error:nil];
      for (NSString *subFileName in subFileArray) {
        NSString *subFilePath = [filePath stringByAppendingPathComponent:subFileName];
        if ([fileMgr removeItemAtPath:subFilePath error:nil]) {
          NSLog(@"removed file path:%@", subFilePath);
        } else {
          NSLog(@"failed to remove file path:%@", subFilePath);
        }
      }
    } else {
      NSLog(@"failed to remove non-existing file path:%@", filePath);
    }
    
    if (clearBlock) {
      clearBlock();
    }
  });
}

/**
 *  磁盘缓存大小 以 b 为单位
 */
- (CGFloat)diskCacheTotalCost{
    NSString *tmpDir = NSTemporaryDirectory();
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:tmpDir]) return 0;
    NSEnumerator *childFilesEnumerator = [[[NSFileManager defaultManager] subpathsAtPath:tmpDir] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [tmpDir stringByAppendingPathComponent:fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileAbsolutePath]){
            folderSize += [[[NSFileManager defaultManager] attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
        }
    }
    return folderSize;
    
}

#pragma mark - 懒加载
- (NSMutableArray *)cacheArrayM{
    if (!_cacheArrayM) {
        _cacheArrayM = [[NSMutableArray alloc] init];
    }
    return _cacheArrayM;
}


#pragma mark - private method
- (long long)freeDiskSpaceInMB {
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return freespace/1024/1024;
}

- (UIAlertController *)p_showLoding:(NSString *)text {
    UIViewController * rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:nil message:text preferredStyle:UIAlertControllerStyleAlert];
    
    UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(200.0f, 10.0f, 37.0f, 37.0f)];
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityView.hidesWhenStopped = YES;
    
    [alertVc.view addSubview:activityView];
    
    [activityView startAnimating];
    
    [rootVC presentViewController:alertVc animated:YES completion:nil];
    
    
    return alertVc;
}

@end
