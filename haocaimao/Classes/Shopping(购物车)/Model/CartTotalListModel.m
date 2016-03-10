//
//  CartTotalListModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/14.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "CartTotalListModel.h"

@implementation CartTotalListModel

+ (id)parseCartTotalListDict:(NSDictionary *)dict{
    return [[CartTotalListModel alloc]initWithDictionary:dict];
}

- (id)initWithDictionary:(NSDictionary *)dataDic{

    self = [super init];
    
    if (self) {
        
        self.real_goods_count = dataDic[@"real_goods_count"];
        self.goods_price = dataDic[@"goods_price"];
        
    }
    
    return self;
}
@end
