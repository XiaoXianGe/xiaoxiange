//
//  weiXinLoginModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/7.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "weiXinLoginModel.h"

@implementation weiXinLoginModel
+(id)weiXinModelWithDict:(NSDictionary *)dict{
    weiXinLoginModel *model = [[weiXinLoginModel alloc]init];
    model.nickname = dict[@"nickname"];
    model.access_token = dict[@"access_token"];
    model.openid = dict[@"openid"];
    model.headimgurl = dict[@"headimgurl"];
    model.unionid = dict[@"unionid"];
    model.expires_in = dict[@"expires_in"];
    model.refresh_token = dict[@"refresh_token"];
    return model;
}

@end
