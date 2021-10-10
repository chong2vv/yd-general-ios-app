//
//  YDDB.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/1.
//

#import <Foundation/Foundation.h>
#import <fmdb/FMDB.h>

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface YDDB : NSObject
@property (nonatomic, copy) NSString *userDBPath;

+ (YDDB *)shareInstance;

@end

