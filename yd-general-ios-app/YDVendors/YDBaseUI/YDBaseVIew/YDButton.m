//
//  YDButton.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import "YDButton.h"

@implementation YDButton

- (RACSignal *)click {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[self rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [subscriber sendNext:@"click"];
        }];
        return nil;
    }];
}

@end
