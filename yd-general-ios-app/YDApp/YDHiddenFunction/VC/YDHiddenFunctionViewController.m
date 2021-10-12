//
//  YDHiddenFunctionViewController.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import "YDHiddenFunctionViewController.h"
#import "YDHiddenFunctionPasswordView.h"

static NSString *hiddenFunctionlistViewControllerCellIdentifier = @"hiddenFunctionlistViewControllerCell";

typedef NS_ENUM(NSInteger,YDHiddenCellStyle) {
    YDHiddenCellStyleDefault = 0,
    YDHiddenCellStyleNext
};

@interface YDHiddenFunctionViewController ()<YDHiddenFunctionPasswordInputDelegate, UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UIView                *inputLabelView;
@property (nonatomic, strong) NSMutableArray <UILabel *>*inputLabels;
@property (nonatomic, strong)YDHiddenFunctionPasswordView *passwordView;
@property (nonatomic, strong)YDTableView *tableView;
@property (nonatomic, copy)NSArray *titleListData;
@property (nonatomic, copy)NSArray *valueListData;

@end

@implementation YDHiddenFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐藏功能";
    
    self.titleListData = @[@"Logger", @"BundleName", @"Version", @"BundleVersion"];
    self.valueListData = @[@"点击查看日志", [self getString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]], [self getString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]], [self getString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]]];
    [self configUI];
    [self configPasswordView];
}
- (NSString *)getString:(id)obj {
    return [NSString stringWithFormat:@"%@",obj];
}

- (YDHiddenCellStyle)getCellStyle:(NSString *)title {
    if ([title isEqualToString:@"Logger"]) {
        return YDHiddenCellStyleNext;
    }
    return YDHiddenCellStyleDefault;
}

- (void)configUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView reloadData];
}

- (void)configPasswordView {
    [self.view addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)checkPasswordInput:(NSString *)password {
    if ([password isEqualToString:@"888888"]) {
        self.passwordView.hidden = YES;
    }else {
        [SVProgressHUD showErrorWithStatus:@"秘钥输入错误"];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleListData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hiddenFunctionlistViewControllerCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hiddenFunctionlistViewControllerCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
    }
    
    cell.textLabel.text = self.titleListData[indexPath.row];
    
    switch ([self getCellStyle:self.titleListData[indexPath.row]]) {
        case YDHiddenCellStyleNext:
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            break;
        case YDHiddenCellStyleDefault:
            cell.accessoryType=UITableViewCellAccessoryNone;
            break;
        default:
            cell.accessoryType=UITableViewCellAccessoryNone;
            break;
    }
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.textColor = [YDStyle colorGrayLight];
    valueLabel.font = [YDStyle fontSmall];
    valueLabel.textAlignment = NSTextAlignmentRight;
    [cell addSubview:valueLabel];
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-35);
        make.centerY.equalTo(cell);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
    }];
    
    valueLabel.text = self.valueListData[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tStr = [self.titleListData objectAtIndex:indexPath.row];
    if ([tStr isEqualToString:@"Logger"]) {
        YDLogListViewController *vc = [[YDLogListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (YDTableView *)tableView {
    if (!_tableView) {
        _tableView = [[YDTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (YDHiddenFunctionPasswordView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[YDHiddenFunctionPasswordView alloc] init];
        _passwordView.delegate = self;
    }
    return _passwordView;
}

@end
