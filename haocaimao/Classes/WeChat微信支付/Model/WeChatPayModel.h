//
//  WeChatPayModel.h
//  haocaimao
//
//  Created by 好采猫 on 16/3/5.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeChatPayModel : NSObject

/** 商家向财付通申请的商家id */
@property (nonatomic, retain) NSString *partnerid;
/** 预支付订单 */
@property (nonatomic, retain) NSString *prepayid;
/** 随机串，防重发 */
@property (nonatomic, retain) NSString *noncestr;
/** 时间戳，防重发 */
@property (nonatomic, copy) NSString * timestamp;
/** 商家根据财付通文档填写的数据和签名 */
@property (nonatomic, retain) NSString *package;
/** 商家根据微信开放平台文档对数据做的签名 */
@property (nonatomic, retain) NSString *sign;
/** 好采猫订单号 */
@property (nonatomic, copy) NSString *attach;


/*
<xml><prepayid><![CDATA[wx20160305175633bffca5d9830057814441]]></prepayid>
        <appid><![CDATA[wx2a1388283f78955d]]></appid>
    <partnerid> 1317895201</partnerid>
      <package><![CDATA[Sign=WXPay]]></package>
    <nonce_str><![CDATA[16yw2ifqdkceklad4ouuktn87copiymj]]></nonce_str>
    <timestamp> 1457171793</timestamp>
         <sign><![CDATA[787F0D6899A070AFD9932DC3E698A916]]></sign>
 </xml>
 */
@end
