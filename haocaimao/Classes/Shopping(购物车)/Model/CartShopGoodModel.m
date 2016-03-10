//
//  CartShopGoodModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/23.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "CartShopGoodModel.h"

@implementation CartShopGoodModel
+(id)parseCartShopGoodDict:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if(self){
        self.goods_list = dic[@"goods_list"];
    }
    return self;
}
@end
