//
//  YDDB.m
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import "YDDB.h"

@interface YDDB ()


@end

@implementation YDDB

+ (YDDB *)shareInstance {
    static YDDB *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YDDB alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {

        _userDBPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"YDDB.sqlite"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:_userDBPath] == NO) {
            FMDatabase *db = [FMDatabase databaseWithPath:_userDBPath];
            if ([db open]) {
                /*
                 
                 */
                NSString *createUserSql = @"create table user (uid text NOT NULL, userName text, userPic text, userDesc text, userAccount text, userPhone text, userEmail text, userGender integer, userBirthday integer, ext text)";
                [db executeUpdate:createUserSql];
            }
        }
        
    }
    return self;
}

@end
