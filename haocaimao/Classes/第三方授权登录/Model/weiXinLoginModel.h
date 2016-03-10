//
//  weiXinLoginModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/12/7.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface weiXinLoginModel : NSObject
@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *openid;//当前应用标识符
@property (strong, nonatomic) NSString *nickname; // 用户昵称
@property (strong, nonatomic) NSString *headimgurl; // 用户头像地址
@property (strong, nonatomic) NSString *unionid;//多应用通用标识符
@property (strong, nonatomic) NSString *expires_in;//有效时间
@property (strong, nonatomic) NSString *refresh_token;//刷新用的

+(id)weiXinModelWithDict:(NSDictionary *)dict;
@end
