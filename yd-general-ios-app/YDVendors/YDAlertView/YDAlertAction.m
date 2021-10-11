//
//  YDAlertAction.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/11.
//

#import "YDAlertAction.h"
#import "YDAlertViewConfig.h"

@implementation YDAlertAction

+ (instancetype _Nonnull )actionWithTitle:(nullable NSString *)title style:(YDAlertActionStyle)style handler:(YDAlertActionHandler)hanlder {
    YDAlertAction *button = [YDAlertAction buttonWithType:UIButtonTypeCustom];
    button.handler = hanlder;
    button.style = style;
    button.title = title;
    [button configure];
    return button;
}

- (void)configure
{
    switch (self.style) {
        case YDAlertActionStyleCancel:
        {
            [self setTitleColor:[YDAlertViewConfig cancelTextColor] forState:UIControlStateNormal];
            self.backgroundColor = [UIColor whiteColor];
            self.titleLabel.font = [UIFont systemFontOfSize:16.];
        }
            break;
        case YDAlertActionStyleDone:
        default:
        {
            [self setTitleColor:[YDAlertViewConfig doneTextColor] forState:UIControlStateNormal];
            self.backgroundColor = [UIColor whiteColor];
            self.titleLabel.font = [UIFont systemFontOfSize:16.];
            
        }
            break;
    }
    [self setTitle:self.title forState:UIControlStateNormal];
}

@end
