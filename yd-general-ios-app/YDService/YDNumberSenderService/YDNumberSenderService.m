//
//  YDNumberSenderService.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/14.
//

#import "YDNumberSenderService.h"

@interface YDNumberSenderService ()

@property (class, nonatomic, assign) NSInteger upNumber;

@end

static NSInteger _upNumber = 0;


@implementation YDNumberSenderService

+ (NSString *)getSenderNumber {
    
    NSString *numberStr = @"";
    numberStr = [numberStr stringByAppendingFormat:@"%@", [NSDate getNowTimeTimestamp]];
    numberStr = [numberStr stringByAppendingFormat:@"%ld", (long)YDNumberSenderService.upNumber];
    int randomNumber = (arc4random() % 10);
    numberStr = [numberStr stringByAppendingFormat:@"%ld", (long)randomNumber];
    YDNumberSenderService.upNumber ++;
    if (YDNumberSenderService.upNumber == 9) {
        YDNumberSenderService.upNumber = 0;
    }
    
    return numberStr;
}

+ (NSInteger)upNumber {
    return _upNumber;
}

+ (void)setUpNumber:(NSInteger)upNumber {
    if (upNumber != _upNumber) {
        _upNumber = upNumber;
    }
}
@end
