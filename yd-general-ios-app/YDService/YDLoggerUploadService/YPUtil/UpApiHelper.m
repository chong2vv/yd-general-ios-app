//
//  UpApiHelper.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/14.
//

#import "UpApiHelper.h"
#import "UpApiUtils.h"

#define UpYunStorageServer  @"https://v0.api.upyun.com"

@implementation UpApiHelper

+ (UpUploadModel *)getUpUploadModel:(NSData *)fileData fileName:(NSString *)fileName{
    UpUploadModel *model = [[UpUploadModel alloc] init];
    
    NSDate *now = [NSDate date];
    NSString *expiration = [NSString stringWithFormat:@"%.0f",[now timeIntervalSince1970] + 1800];//本地自签名30分钟后过期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"EEE, dd MMM y HH:mm:ss zzz"];
    
    NSString *date = [dateFormatter stringFromDate:now];
    NSString *content_md5 = [UpApiUtils getMD5HashFromData:fileData];

    
    NSMutableDictionary *policyDict = [NSMutableDictionary new];
    NSDictionary *policyDict_part1 = @{@"bucket": @"yd-logger-upload",
                                       @"save-key": [NSString stringWithFormat:@"%@",fileName],
                                       @"expiration": expiration,
                                       @"date": date,
                                       @"content-md5": content_md5,
                                       @"content-length":[NSString stringWithFormat:@"%ld", fileData.length]};
    
    NSDictionary *policyDict_part2 = [NSDictionary new];
    
    //所有上传参数都是放到上传策略 policy 中
    [policyDict addEntriesFromDictionary:policyDict_part1];
    [policyDict addEntriesFromDictionary:policyDict_part2];
    

    NSString *policy = [UpApiUtils getPolicyWithParameters:policyDict];
    
    
    NSString *uri = [NSString stringWithFormat:@"/%@", @"yd-logger-upload"];
    NSString *signature = [UpApiUtils getSignatureWithPassword:@"sC3CBwDOwauLkmEoaXLNlGxDplPg9aWe"
                                                    parameters:@[@"POST", uri, date, policy, content_md5]];
    
    NSString *authorization = [NSString stringWithFormat:@"UPYUN %@:%@", @"chong2vv", signature];
    NSDictionary *parameters = @{@"policy": policy, @"authorization": authorization};
    
    if (fileName.length <= 0) {
        fileName = @"fileName";
    }
    NSDictionary *polcyDictDecoded = [UpApiUtils getDictFromPolicyString:policy];
    
    NSString *bucketName_new = [polcyDictDecoded objectForKey:@"bucket"];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", UpYunStorageServer, bucketName_new];
    
    model.parameters = [parameters copy];
    model.urlString = urlString;
    
    return model;
}

@end
