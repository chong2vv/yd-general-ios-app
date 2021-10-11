//
//  YDAlertViewController.m
//  yd-general-ios-app
//
//  Created by wangyuandong on 2021/10/11.
//

#import "YDAlertViewController.h"
#import "YDAlertAction.h"
#import "YDAlertViewConfig.h"
#import "YDAlertView.h"

static UIWindow *alertWindow;

@interface YDAlertViewController ()

@property (nonatomic, weak) UIViewController *fromController;
@property (nonatomic, strong) UIView *blackCoverView; //黑色遮罩
@property (nonatomic, strong) YDAlertView *alertView; //alertView

@end

@implementation YDAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.blackCoverView];
    [self.view addSubview:self.alertView];
    [self.blackCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

#pragma mark - public method
+(void)showAlertWithTitle:(id )title
                  message:(id )message
        cancelButtonTitle:(id )cancelButtonTitle
{
    [YDAlertViewController showAlertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil didSelectBlock:nil didCancelBlock:nil];
}
+(void)showAlertWithTitle:(nullable id)title
                  message:(nullable id)message
        cancelButtonTitle:(nullable id)cancelButtonTitle
        otherButtonTitles:(nullable NSArray<id> *)otherButtonTitles
           didSelectBlock:(nullable void (^)(YDAlertAction *action,NSUInteger index))didSelectBlock
           didCancelBlock:(nullable void (^)(void))didCancelBlock
{
    YDAlertViewController *alertController = [YDAlertViewController alertControllerWithTitle:title message:message];
    for (NSUInteger i = 0; i < otherButtonTitles.count; i++) {
        [alertController addAction:[YDAlertAction actionWithTitle:otherButtonTitles[i] style:YDAlertActionStyleDefault handler:^(YDAlertAction * _Nonnull action) {
            !didSelectBlock ?: didSelectBlock(action,i);
        }]];
    }
    if (cancelButtonTitle) {
        [alertController addAction:[YDAlertAction actionWithTitle:cancelButtonTitle style:YDAlertActionStyleCancel handler:^(YDAlertAction * _Nonnull action) {
            !didCancelBlock ?: didCancelBlock();
        }]];
    }
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (controller.presentedViewController) {
        controller = controller.presentedViewController;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [alertController presentFromViewController:controller animated:YES completion:nil];

    });
}

#pragma mark -
+ (instancetype)alertControllerWithTitle:(nullable id)title message:(nullable id)message {
    YDAlertViewController *alertController = [[YDAlertViewController alloc] init];
    alertController.alertView = [YDAlertView alertViewWith:title message:message];
    return alertController;
}


- (void)addAction:(YDAlertAction *)action {
    [self.alertView addAction:action];
}

- (void)presentFromViewController:(UIViewController *)fromViewController animated:(BOOL)animated completion:(void (^)(void))completion{
    if (fromViewController == nil) {
        NSLog(@"error: fromViewController is nil! ");
        return;
    }
    self.fromController = fromViewController;
    
    if (alertWindow == nil) {
        alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.backgroundColor = [UIColor clearColor];
        alertWindow.windowLevel = UIWindowLevelAlert - 1;
    }
    
    alertWindow.rootViewController = self;
    
    //简单动画
    self.alertView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.blackCoverView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.blackCoverView.alpha = 1;
    }];
    
    [alertWindow makeKeyAndVisible];
    
}

- (void)dismissWithAnimation:(BOOL)animated completion:(void (^)(void))completion{
    
    self.blackCoverView.alpha = 0;
    [self.alertView removeFromSuperview];
    [self.fromController.view.window makeKeyAndVisible];
    alertWindow.hidden = YES;
    self.fromController = nil;
}

#pragma mark - getter
- (UIView *)blackCoverView{
    if (!_blackCoverView) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.blackCoverView = ({
            UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
            coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            coverView.alpha = 0;
            coverView;
        });
    }
    return _blackCoverView;
}

@end

@implementation Alert

+ (void)showBasicAlertOnVC:(UIViewController *)vc withTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:alertController animated:true completion:nil];
    });
}

@end
