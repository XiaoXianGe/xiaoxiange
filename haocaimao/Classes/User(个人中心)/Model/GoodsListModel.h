//
//  GoodsListModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/9/11.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsListModel : NSObject
/**
 *  商品ID
 */
@property (strong, nonatomic)NSString *goods_id;
/**
 *  商品名
 */
@property (strong, nonatomic)NSString *name;
/**
 *  商品数量
 */
@property (strong, nonatomic)NSString *goods_number;
/**
 *  商品单价
 */
@property (strong, nonatomic)NSString *formated_shop_price;
/**
 *  商品图片url
 */
@property (strong, nonatomic)NSString *imgSmall;


+ (id)parseGoodsListDict:(NSDictionary *)dict;

@end
