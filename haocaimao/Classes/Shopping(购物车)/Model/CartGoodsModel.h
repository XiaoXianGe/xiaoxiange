//
//  CartGoodsModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/11/23.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartGoodsModel : NSObject
@property (strong, nonatomic) NSArray *sup_goods_list;
+ (id)parseCartGoodsDict:(NSDictionary *)dict;

@end
