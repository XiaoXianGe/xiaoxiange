//
//  HCMVIPUserModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/9/10.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCMVIPUserModel : NSObject
/**
 *  收藏商品数量
 */
@property (strong, nonatomic)NSString *collection_num;
/**
 *  邮箱
 */
@property (strong, nonatomic)NSString *email;
/**
 *  用户名
 */
@property (strong, nonatomic)NSString *name;
/**
 *  未支付
 */
@property (strong, nonatomic)NSString *await_pay;
/**
 *  未发货
 */
@property (strong, nonatomic)NSString *await_ship;
/**
 *  为收货
 */
@property (strong, nonatomic)NSString *finished;
/**
 *  历史订单
 */
@property (strong, nonatomic)NSString *shipped;
/**
 *  会员登记
 */
@property (strong, nonatomic)NSString *rank_level;
/**
 *  会员类型
 */
@property (strong, nonatomic)NSString *rank_name;

+ (id)parseVIPUserDict:(NSDictionary *)dict;

@end
