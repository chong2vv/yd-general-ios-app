//
//  YDTableView.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import "YDTableView.h"

@interface YDTableView ()

@end

@implementation YDTableView

- (instancetype)init {
    if (self = [super init]) {
        [self buildUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return  self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)setMJRefreshing:(YDTableViewReloadDataBlock)reloadDataBlock loadMoreData:(YDTableViewLoadMoreDataBlock)loadMoreData {
    
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (reloadDataBlock) {
            reloadDataBlock();
        }
    }];
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.mj_header;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header.arrowView setImage:[UIImage imageNamed:@""]];
    header.stateLabel.font = [YDStyle fontSmall];
    header.stateLabel.textColor = [YDStyle colorPaperGray];
    [header setTitle:@"下拉更新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立刻更新" forState:MJRefreshStatePulling];
    [header setTitle:@"更新数据..." forState:MJRefreshStateRefreshing];
    
    //mj footer
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (loadMoreData) {
            loadMoreData();
        }
    }];
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.mj_footer;
    footer.stateLabel.font = [YDStyle fontSmall];
    footer.stateLabel.textColor = [YDStyle colorPaperGray];
    [footer setTitle:@"上拉读取更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在读取..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已读取完毕" forState:MJRefreshStateNoMoreData];
    
}

- (void)endRefreshing:(BOOL)endData {
    if (self.mj_header) {
        [self.mj_header endRefreshing];
    }
    
    if (self.mj_footer) {
        if (endData) {
            [self.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.mj_footer endRefreshing];
        }
    }
}
@end
