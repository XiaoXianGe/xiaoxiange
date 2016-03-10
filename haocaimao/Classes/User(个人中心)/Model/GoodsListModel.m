//
//  GoodsListModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/11.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "GoodsListModel.h"

@implementation GoodsListModel

+ (id)parseGoodsListDict:(NSDictionary *)dict{
    return [[GoodsListModel alloc]initWithDictionary:dict];
}


- (id)initWithDictionary:(NSDictionary *)dataDic{
    
    self = [super init];
    
    if (self) {
        
        self.goods_id = dataDic[@"goods_id"];
        self.name = dataDic[@"name"];
        self.goods_number = dataDic[@"goods_number"];
        self.formated_shop_price = dataDic[@"formated_shop_price"];
        self.imgSmall = dataDic[@"img"][@"small"];
        
    }
    return self;
}

@end
