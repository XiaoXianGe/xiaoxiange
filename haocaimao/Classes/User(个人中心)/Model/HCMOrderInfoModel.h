//
//  HCMOrderInfoModel.h
//  haocaimao
//
//  Created by 好采猫 on 16/3/21.
//  Copyright © 2016年 haocaimao. All rights reserved.
//  订单详情模型

#import <Foundation/Foundation.h>

@interface HCMOrderInfoModel : NSObject

/** 订单号 */
@property(nonatomic,copy)NSString * orderSN;
/** 收件人 */
@property(nonatomic,copy)NSString * consignee;
/** 电话 */
@property(nonatomic,copy)NSString * mobile;
/** 地址 */
@property(nonatomic,copy)NSString * address;
/** 支付方式 */
@property(nonatomic,copy)NSString * paymentName;
/** 订单状态 */
@property(nonatomic,copy)NSString * orderStatus;
/** 付款状态 */
@property(nonatomic,copy)NSString * payStatus;
/** 配送状态 */
@property(nonatomic,copy)NSString * shippingStatus;
/** 普通发票 */
@property(nonatomic,copy)NSString * invPayee;
/** 普通发票 - 明细 */
@property(nonatomic,copy)NSString * invContent;
/** 增值税发票 */
@property(nonatomic,copy)NSDictionary * postscript;
/** 增值税发票 -  单位名称 */
@property(nonatomic,copy)NSString * unitName;
/** 增值税发票 -  注册号码 */
@property(nonatomic,copy)NSString * registeredMobile;
/** 增值税发票 -  银行名称 */
@property(nonatomic,copy)NSString * bankName;
/** 增值税发票 -  注册地址 */
@property(nonatomic,copy)NSString * registeredAddress;
/** 增值税发票 -  银行账号 */
@property(nonatomic,copy)NSString * bankAccount;
/** 增值税发票 -  纳税人识别码 */
@property(nonatomic,copy)NSString * taxpayerIDCode;
/** 商品总价 */
@property(nonatomic,copy)NSString * goodsAmount;
/** 运费 */
@property(nonatomic,copy)NSString * shippingFee;
/** 实付款 */
@property(nonatomic,copy)NSString * orderAmount;
/** 下单时间 */
@property(nonatomic,copy)NSString * addTime;


//unitName = 木木的是我自己了！,
//registeredMobile = 12556686868,
//bankName = 爬特痛的,
//registeredAddress = 哦喏特太,
//bankAccount = 5868576568686868686,
//taxpayerIDCode = 58345568225385855

//consignee = 测试,
//shippingFee = 14.00,
//orderAmount = 33.50,
//postscript = <null>,
//shippingStatus = --,
//mobile = ,
//invPayee = ,
//payStatus = 未付款,
//payDesc = <null>,
//address = 广东广州番禺区测试,
//orderSN = 2016032126229,
//orderStatus = 未确定,
//paymentName = 微信支付（ios）,
//invContent = ,
//goodsAmount = 19.50,
//addTime = 2016-03-21 08:14:25,
//payOnline = ,
//orderGoods = [
//{
//    goodsNumber = 5,
//    goodsPrice = 3.90,
//    goodsId = 143,
//    goodsName = 3M9001V/9002V 呼吸阀骑行防粉尘防PM2.5雾霾男女冬颗粒物口罩独立装


@end
