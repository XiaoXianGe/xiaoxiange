//
//  CartTotalListModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/9/14.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartTotalListModel : NSObject
/**
 *  商品价格
 */
@property (nonatomic, strong)NSString *goods_price;
/**
 *  商品数量
 */
@property (nonatomic, strong)NSNumber *real_goods_count;

+ (id)parseCartTotalListDict:(NSDictionary *)dict;

@end

/*
 
    服务器返回的一大堆 有的没的 接口
"goods_price": "3822.00元", 商品价格
"market_price": "4586.40元", 市场价格
"saving": "764.40元", 储蓄
"save_rate": "17", 节省
"goods_amount": 3822, 库存
"real_goods_count": 3,  购买的商品数量
"virtual_goods_count": 0 虚拟商品数量
 
*/