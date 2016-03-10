
//
//  CartListModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/17.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "CartListModel.h"

@implementation CartListModel

+ (id)parseCartListDict:(NSDictionary *)dict{
    return [[CartListModel alloc]initWithDictionary:dict];
}

- (id)initWithDictionary:(NSDictionary *)dataDic{
    
    self = [super init];
    
    if (self) {
        
        self.goods_name = dataDic[@"goods_name"];
        self.goods_number = dataDic[@"goods_number"];
        self.goods_price = dataDic[@"goods_price"];
        
    }
    
    return self;
}

@end