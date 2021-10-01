//
//  YDHiddenFunctionViewController.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import "YDHiddenFunctionViewController.h"
#import "YDHiddenFunctionPasswordInputView.h"

static NSString *hiddenFunctionlistViewControllerCellIdentifier = @"hiddenFunctionlistViewControllerCell";

@interface YDHiddenFunctionViewController ()<YDHiddenFunctionPasswordViewDelegate, UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UIView                *inputLabelView;
@property (nonatomic, strong) NSMutableArray <UILabel *>*inputLabels;
@property (nonatomic, strong)YDHiddenFunctionPasswordInputView *passwordView;
@property (nonatomic, strong)YDTableView *tableView;
@property (nonatomic, copy)NSArray *titleListData;
@property (nonatomic, copy)NSArray *valueListData;

@end

@implementation YDHiddenFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleListData = @[@"Logger", @"UserId", @"BundleName", @"Version", @"BundleVersion"];
    self.valueListData = @[@"查看日志", @"", [self getString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]], [self getString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]], [self getString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]]];
    
    [self configUI];
    [self configPasswordView];
}
- (NSString *)getString:(id)obj {
    return [NSString stringWithFormat:@"%@",obj];
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

- (void)keyViewDidEndEditing:(NSString *)key {
    if ([key isEqualToString:@"121212"]) {
        self.passwordView.hidden = YES;
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
    cell.detailTextLabel.text = self.titleListData[indexPath.row];
    
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

- (YDHiddenFunctionPasswordInputView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[YDHiddenFunctionPasswordInputView alloc] init];
        _passwordView.delegate = self;
    }
    return _passwordView;
}

@end
