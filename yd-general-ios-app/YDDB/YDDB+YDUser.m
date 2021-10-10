//
//  YDDB+YDUser.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/9.
//

#import "YDDB+YDUser.h"

@implementation YDDB (YDUser)

- (RACSignal *)insertWithUserModel:(YDUser *)user {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        FMDatabase *db = [FMDatabase databaseWithPath:self.userDBPath];
        if ([db open]) {
            //检查是否存在这个feed
            FMResultSet *rsl = [db executeQuery:@"select uid from user where uid = ?",user.uid];
            NSString *uid = @"";
            if ([rsl next]) {
                //存在返回uid
                uid = [rsl stringForColumn:@"uid"];
                
            } else {
                //不存在创建一个，同时返回uid
                [db executeUpdate:@"insert into user (uid, userName, userPic, userDesc, userAccount, userPhone, userEmail, userGender, userBirthday, ext) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", user.uid, user.userName, user.userPic, user.userDesc, user.userAccount, user.userPhone, user.userEmail, user.userGender, user.userBirthday, user.ext];
                
                FMResultSet *uidRsl = [db executeQuery:@"select uid from feeds where uid = ?",user.uid];
                if ([uidRsl next]) {
                    uid = [uidRsl stringForColumn:@"uid"];
                }
                
            }
            
            //存在的话同时更新下user信息
            [db executeUpdate:@"update user set userName = ?, userPic = ?, userDesc = ?, userAccount = ?, userPhone = ?, userEmail = ?, userGender = ?, userBirthday = ?, ext = ? where uid = ?",user.userName, user.userPic, user.userDesc, user.userAccount, user.userPhone, user.userEmail, user.userGender, user.userBirthday, user.ext, user.uid];
            //告知完成可以接下来的操作
            [subscriber sendNext:uid];
            [subscriber sendCompleted];
            [db close];
        }else {
            YDLogDebug(@"wyd - 存储用户信息失败");
        }
        return nil;
    }];
}

- (RACSignal *)selectUserWithUid:(NSString *)uid {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        FMDatabase *db = [FMDatabase databaseWithPath:self.userDBPath];
        if ([db open]) {
            FMResultSet *rs = [db executeQuery:@"select * from user where uid = ?",uid];
            YDUser *user = [[YDUser alloc] init];
            user.uid = [rs stringForColumn:@"uid"];
            user.userName = [rs stringForColumn:@"userName"];
            user.userPic = [rs stringForColumn:@"userPic"];
            user.userDesc = [rs stringForColumn:@"userDesc"];
            user.userAccount = [rs stringForColumn:@"userAccount"];
            user.userPhone = [rs stringForColumn:@"userPhone"];
            user.userEmail = [rs stringForColumn:@"userEmail"];
            user.userGender = [rs intForColumn:@"userGender"];
            user.userBirthday = [rs longLongIntForColumn:@"userBirthday"];
            user.ext = [rs stringForColumn:@"ext"];
            
            [subscriber sendNext:user];
            [subscriber sendCompleted];
            [db close];
        }else {
            YDLogDebug(@"wyd - 查找用户信息失败");
        }
        return nil;
    }];
}

- (RACSignal *)deleteUserWithUid:(NSString *)uid {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        FMDatabase *db = [FMDatabase databaseWithPath:self.userDBPath];
        if ([db open]) {
            [db executeUpdate:@"delete from feeditem where uid = ?", uid];
            [subscriber sendNext:uid];
            [subscriber sendCompleted];
            [db close];
        }else {
            YDLogDebug(@"wyd - 删除用户信息失败");
        }
        
        return nil;
    }];
}

@end
