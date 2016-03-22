//
//  HCMPayWay.m
//  haocaimao
//
//  Created by 好采猫 on 16/3/22.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import "HCMPayWay.h"
#import "AddressNerworking.h"
#import "HCMPayOrderWebViewVC.h"


@implementation HCMPayWay

+(void)WeChatPayWithorder_id:(NSString *)order_id{
    
    //<微信支付>
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sid = [defaults objectForKey:@"sid"];
    NSString *uid = [defaults objectForKey:@"uid"];
    
    NSDictionary *dict = @{@"session":@{@"uid":uid,@"sid":sid},
                           @"order_id":order_id};
    
    [[AddressNerworking sharedManager]postAwaitPayWechatPayURL:dict successBlock:^(id responseBody) {
        
        if (responseBody[@"status"][@"error_code"]) {
            
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
        
        PayReq* req = [[PayReq alloc] init];
        req.partnerId = responseBody[@"data"][@"partnerid"];  //[dict objectForKey:@"partnerid"];
        req.prepayId  = responseBody[@"data"][@"prepayid"];   //[dict objectForKey:@"prepayid"];
        req.nonceStr  = responseBody[@"data"][@"noncestr"];   //[dict objectForKey:@"noncestr"];
        req.timeStamp = [responseBody[@"data"][@"timestamp"] intValue]; //@"1457331624";
        req.package   = responseBody[@"data"][@"package"];     //[dict objectForKey:@"package"];
        req.sign      = responseBody[@"data"][@"sign"];        //[dict objectForKey:@"sign"];
        [WXApi sendReq:req];
        
        NSLog(@"%@",responseBody[@"data"]);
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:@"加载失败！"];
        
        
    }];
    return;
        
    

}


@end
