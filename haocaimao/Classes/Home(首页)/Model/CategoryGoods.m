//
//  CategoryGoods.m
//  UICollectionView Section
//
//  Created by 好采猫 on 15/10/15.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "CategoryGoods.h"

@implementation CategoryGoods
+(id)parsingDataOfDict:(NSDictionary *)dic{
    return [[self alloc]initWithDictionary:dic];
}
-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.goods_id = dic[@"goods_id"];
        self.shop_price = dic[@"shop_price"];
        self.img = dic[@"img"];
        self.market_price = dic[@"market_price"];
        self.goods_name = dic[@"goods_name"];
        self.market_price = dic[@"market_price"];

    }
    return self;

}
@end
