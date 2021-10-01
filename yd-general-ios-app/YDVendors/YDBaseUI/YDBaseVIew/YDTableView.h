//
//  YDTableView.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^YDTableViewReloadDataBlock)(void);
typedef void (^YDTableViewLoadMoreDataBlock)(void);
@interface YDTableView : UITableView

- (void)setMJRefreshing:(YDTableViewReloadDataBlock) reloadDataBlock loadMoreData:(YDTableViewLoadMoreDataBlock) loadMoreData;

- (void)endRefreshing:(BOOL)endData;
@end

NS_ASSUME_NONNULL_END
