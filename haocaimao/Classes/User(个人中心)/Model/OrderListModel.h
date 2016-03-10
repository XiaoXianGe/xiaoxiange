//
//  OrderListModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/9/11.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListModel : NSObject
/**
 *  未付款 ID
 */
@property (strong, nonatomic)NSString *order_id;

/**
 *  订单编号
 */
@property (strong, nonatomic)NSString *order_sn;

/**
 *  成交时间
 */
@property (strong, nonatomic)NSString *order_time;

/**
 *  总额  包括运费
 */
@property (strong, nonatomic)NSString *total_fee;

/**
 *  红包
 */
@property (strong, nonatomic)NSString *formated_bonus;

/**
 *  运费
 */
@property (strong, nonatomic)NSString *formated_shipping_fee;

/**
 *  积分
 */
@property (strong, nonatomic)NSString *formated_integral_money;

/**
 *  支付方式
 */
@property (strong, nonatomic)NSString *pay_code;



+ (id)parseOrderListDict:(NSDictionary *)dict;

@end
