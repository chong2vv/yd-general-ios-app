//
//  YDContainer.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2022/8/19.
//

#import "YDContainer.h"

@interface YDContainer ()

@property (nonatomic, strong)NSMutableDictionary *dic;

@end

@implementation YDContainer

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static id shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)resolveInstance:(NSString *)key {
    if (![[self.dic objectForKey:key] isEmpty]) {
        return [self.dic objectForKey:key];
    }else {
        Class clz = NSClassFromString(key);
        [self.dic setObject:clz forKey:key];
    }
    return nil;
}

- (NSMutableDictionary *)dic {
    if (!_dic) {
        _dic = [NSMutableDictionary new];
    }
    return _dic;
}
@end

