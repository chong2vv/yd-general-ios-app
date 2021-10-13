//
//  YDImageUploadService.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/10.
//

#import "YDImageUploadService.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@implementation YDImageUploadService

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static id shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (void)uploadImage:(UIImage *)image progress:(void (^)(NSProgress *))progress success:(YDSuccessHandler)success failure:(YDFailureHandler)failure {
    NSDictionary *dict = @{@"sc":@"ios",
                           @"async":@"0"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[YDNetWorkConfig configOSSBaseUrl] parameters:dict headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件参数
        NSData *data = UIImagePNGRepresentation(image);
        //这个就是参数
        [formData appendPartWithFileData:data name:@"image" fileName:@"xxxx123.png" mimeType:@"image/png"];
        
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                YDLogError(@"上传图片失败： %@", error);
                failure();
            }
        }];
}

@end
