//
//  CartGoodsModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/23.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "CartGoodsModel.h"

@implementation CartGoodsModel
+(id)parseCartGoodsDict:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.sup_goods_list = dic[@"sup_goods_list"];
    }
    return self;
}
@end
