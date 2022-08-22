//
//  YDUser.h
//  yd-general-ios-app
//
//  Created by 王远东 on 2021/10/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//性别
typedef NS_ENUM(NSUInteger, YDGender) {
    YDGenderMan = 0, //男
    YDGenderWoman, //女
};

@interface YDUser : NSObject

@property (nonatomic, copy)NSString *uid; //用户uid
@property (nonatomic, copy)NSString *userName; //用户昵称
@property (nonatomic, copy)NSString *userPic; //用户头像
@property (nonatomic, copy)NSString *userDesc; //用户简介
@property (nonatomic, copy)NSString *userAccount; //用户账户
@property (nonatomic, copy)NSString *userPhone; //用户手机号
@property (nonatomic, copy)NSString *userEmail; //用户邮箱
@property (nonatomic, assign)YDGender userGender; //用户性别
@property (nonatomic, assign)NSInteger userBirthday; //用户生日 秒级时间戳
@property (nonatomic, copy)NSString *ext; //扩展字段，json字符串，例如签名等
@property (nonatomic, copy)NSString *authorization;
@end

NS_ASSUME_NONNULL_END
