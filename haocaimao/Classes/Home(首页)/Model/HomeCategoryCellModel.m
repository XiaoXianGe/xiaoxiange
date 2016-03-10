//
//  HomeCategoryCellModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/13.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HomeCategoryCellModel.h"





@implementation HomeCategoryCellModel




+(id)collectionGoodsWithCategoryJSON:(NSDictionary *)dic{
    return [[self alloc]initWithCategoryJson:dic];
}

-(id)initWithCategoryJson:(NSDictionary *)CategoryJson{
    
    self = [super init];
    
    if (self) {
        
        self.goods_id = CategoryJson[@"id"];
        self.goods_name = CategoryJson[@"name"];
        self.goods_price = CategoryJson[@"shop_price"];
        self.goods_market_price = CategoryJson[@"market_price"];
        self.goods_image = CategoryJson[@"img"][@"small"];
        self.promote_price = CategoryJson[@"promote_price"];

        
    }
    return self;
}










@end
