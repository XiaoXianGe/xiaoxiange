//
//  UserEnshrine.h
//  haocaimao
//
//  Created by 好采猫 on 15/9/1.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEnshrine : NSObject
/**
 *  商品ID
 */
@property(nonatomic, strong)NSString *goods_id;
/**
 *  商品名称
 */
@property(nonatomic, strong)NSString *name;
/**
 *  市场价格
 */
@property(nonatomic, strong)NSString *market_price;
/**
 *  商品价格
 */
@property(nonatomic, strong)NSString *shop_price;
/**
 *  促销价格
 */
@property(nonatomic, strong)NSString *promote_price;
/**
 *  商品图片名称
 */
@property(nonatomic, strong)NSString *img_small;
/**
 *  删除ID
 */
@property(nonatomic, strong)NSString *rec_id;


+ (id)parseEnshrineData:(NSDictionary *)dict;

@end
