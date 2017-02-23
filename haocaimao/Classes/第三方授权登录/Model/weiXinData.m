//
//  weiXinData.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/10.
//  Copyright © 2015年 haocaimao. All rights reserved.
//
#import "MBProgressHUD+MJ.h"
#import "AddressNerworking.h"
#import "weiXinData.h"
#import "WXApiObject.h"
#import "WXApiManager.h"
#import "WXApi.h"

#define path  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
#define APP_SECRET @"c3076ba236c8d120b3eb829bad13b154"

@interface weiXinData ()

@end

@implementation weiXinData
- (FMDatabase *)sqlBase{
    if (!_sqlBase) {
        NSString *paths = [[path firstObject]stringByAppendingPathComponent:@"weixin.db"];
        _sqlBase = [FMDatabase databaseWithPath:paths];
    }
    return _sqlBase;
}

- (void)onReq:(BaseReq *)req{
    
    HCMLog(@"BaseReq===%@",req);
}

//发送微信授权请求（微信支付请求）+（微信登录请求）
//先判断用户的操作是什么！ 支付 or 登录 //

- (void)onResp:(BaseResp *)resp{
    
    if ([resp isKindOfClass:[PayResp class]]) {
        //微信支付请求
        //微信支付请求
        //微信支付请求
        //微信支付请求
        PayResp*response=(PayResp*)resp;
        // 微信终端返回给第三方的关于支付结果的结构体
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        
            switch (response.errCode) {
                case WXSuccess:
                    strMsg = @"支付结果：成功！\n可在-我的订单-<待发货>中查看";
                    [HCMNSNotificationCenter postNotificationName:@"WX_PaySuccess" object:nil];
                    HCMLog(@"支付成功－PaySuccess，retcode = %d", response.errCode);
                    break;
                    
                default:
                    strMsg = [NSString stringWithFormat:@"支付结果：失败！\n订单保存到-我的订单-<待付款>中"];
                    [HCMNSNotificationCenter postNotificationName:@"WX_PayFailure" object:nil];
                    
                    HCMLog(@"错误，retcode = %d, retstr = %@", response.errCode,response.errStr);
                    break;
            }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
        [SVProgressHUD dismiss];
        
        } else {
            //(微信登录)授权
            //(微信登录)授权
            //(微信登录)授权
            //(微信登录)授权
            //(微信登录)授权
        SendAuthResp *aresp = (SendAuthResp *)resp;
        
        if (aresp.errCode == 0) {
            
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD show];
            
            NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", APP_ID, APP_SECRET, aresp.code];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSURL *zoneUrl = [NSURL URLWithString:url];
                
                NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
               
                NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data) {
                        
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        
                        weiXinLoginModel *model = [weiXinLoginModel weiXinModelWithDict:dic];
                        
                        self.model = model;
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        
                        [defaults setObject:[NSDate date] forKey:@"createTime"];
                        
                        [defaults synchronize];
                        
                        [self getUserInfo];
                        
                    }
                });
            });
        }

    }

   }

//微信用户信息
-(void)getUserInfo{
    
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", self.model.access_token, self.model.openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                self.model.headimgurl = dic[@"headimgurl"];
                self.model.nickname = dic[@"nickname"];
                [self saveUser:self.model];
               
            }
        });
    });
}

- (void)saveUser:(weiXinLoginModel *)model{
    if (![self.sqlBase open]) {
        HCMLog(@"打开失败");
        return;
    }
    NSString *deleteSql = @"delete from wei";
    BOOL delete = [self.sqlBase executeUpdate:deleteSql];
    if (delete) {
        HCMLog(@"删除表");
    }

    NSInteger table = [self.sqlBase executeUpdate:@"create table if not exists wei(weixinName text,weixinIcon text,access_token text,expires_in text,refresh_token text,openid text,unionid text)"];
    if (!table) {
        HCMLog(@"建表失败");
        [self.sqlBase close];
        return;
    }
       NSString *save_stmt = [NSString stringWithFormat:@"insert into wei(weixinName,weixinIcon,access_token,expires_in,refresh_token,openid,unionid) values('%@','%@','%@','%@','%@','%@','%@')",model.headimgurl,model.nickname,model.access_token,model.expires_in,model.refresh_token,model.openid,model.unionid];
    BOOL save = [self.sqlBase executeUpdate:save_stmt];
    self.model = model;
    if(!save){
        HCMLog(@"写入失败");
        return;
        
    }
    [self loadData];
    
    [self.sqlBase close];

}

//刷新数据
- (void)loadRefresh_token{
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionary];
    mutabDict[@"unionid"] = self.model.unionid;
    HCMLog(@"%@",mutabDict);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.model.unionid forKey:@"unionid"];
    [defaults setObject:self.model.nickname forKey:@"userName"];
    [defaults setObject:self.model.headimgurl forKey:@"headimgurl"];
    [defaults synchronize];
    [[AddressNerworking sharedManager]postweiXinUserLogoin:mutabDict successBlock:^(id responseBody) {
        
        if (responseBody[@"status"][@"error_code"]) {
            
            [MBProgressHUD showError:responseBody[@"status"][@"error_desc"]];
            
            return ;
            
        }else{
            //微信老用户
            if ([(responseBody[@"data"][@"userStatus"]) isEqualToString:@"oldUser"]) {
                
                 //HCMLog(@"self.model%@",self.model);
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                
                [defaults setObject:self.model.unionid forKey:@"unionid"];
                [defaults setObject:responseBody[@"data"][@"userid"] forKey:@"uid"];
                [defaults setObject:responseBody[@"data"][@"sessionId"] forKey:@"sid"];
                [defaults setBool:[responseBody[@"status"][@"succeed"] boolValue]forKey:@"status"];
                NSString *realName = (NSString *)responseBody[@"data"][@"userInfo"][@"realName"];
                realName = [self clearNull:realName];
                
                HCMLog(@"=======realName %@",realName);
                [defaults setObject:realName forKey:@"realName"];
                
                [defaults synchronize];
                
                [HCMNSNotificationCenter postNotificationName:@"weChatLogin" object:nil];
                
            }else{
            //微信授权新用户
                [SVProgressHUD showSuccessWithStatus:@"授权成功，跳转注册"];
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                
                [HCMNSNotificationCenter postNotificationName:@"weChatLoginNew" object:nil];
                
            }
            
        }
        
    } failureBlock:^(NSString *error) {
        [SVProgressHUD showSuccessWithStatus:error];

    }];
    //}
 
}//判断刷新
//随便赋值
//里边的数据结构有"<null>"，而NSUserDefaults是不能被成功解析并存入的，所有在存入之前需要将里边的"<null>"改成""即可。
-(NSString *)clearNull:(NSString *)realNameStr
{
    HCMLog(@"--------=%@",realNameStr);
    if (realNameStr.length == 0) {
        realNameStr = @"";
    }
    return realNameStr;
}


- (void)loadData{
    BOOL load = [self.sqlBase open];
    if (load) {
        
        NSString *inquire = @"select weixinName, weixinIcon, access_token, expires_in, refresh_token, openid, unionid from wei ";
        if (![self.sqlBase open]) {
            HCMLog(@"打开失败");
            return;
        }
        FMResultSet *set = [self.sqlBase executeQuery:inquire];
        while ([set next]) {
            weiXinLoginModel *model = [[weiXinLoginModel alloc]init];
            model.headimgurl = [set stringForColumn:@"weixinName"];
            model.nickname = [set stringForColumn:@"weixinIcon"];
            model.access_token =[set stringForColumn:@"access_token"];
            model.expires_in = [set stringForColumn:@"expires_in"];
            model.refresh_token = [set stringForColumn:@"refresh_token"];
            model.openid = [set stringForColumn:@"openid"];
            model.unionid =[set stringForColumn:@"unionid"] ;
            self.model = model;
            
        }
    }
    [self loadRefresh_token];
    [self.sqlBase close];
    
}//加载model数据

@end
