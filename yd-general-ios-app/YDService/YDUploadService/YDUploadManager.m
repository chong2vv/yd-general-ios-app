//
//  YDUploadManager.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/13.
//

#import "YDUploadManager.h"

@implementation YDUploadManager


- (WHC_HttpOperation *)upload:(NSString *)strUrl param:(NSDictionary *)paramDict process:(WHCProgress)processBlock didFinished:(WHCDidFinished)finishedBlock {
    return [super upload:strUrl param:paramDict didFinished:^(WHC_BaseOperation * _Nullable operation, NSData * _Nullable data, NSError * _Nullable error, BOOL isSuccess) {
        
        if (!isSuccess) {
            YDLogError(@"文件上传失败:=== url:%@ === error:%@",strUrl, error);
        }
        
        if (finishedBlock) {
            finishedBlock(operation, data, error, isSuccess);
        }
    }];
}

@end
