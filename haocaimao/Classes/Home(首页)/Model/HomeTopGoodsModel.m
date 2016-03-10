//
//  HomeTopGoodsModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/18.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HomeTopGoodsModel.h"

@implementation HomeTopGoodsModel


//解析广告栏数据
+(NSMutableDictionary *)NewsWithJSON:(NSDictionary *)dic{
    
    return [[self alloc]initWithTopGoodsJson:dic];
}

- (instancetype)initWithTopGoodsJson:(NSDictionary *)topGoodsJson{
    
    NSArray *dataArr = topGoodsJson[@"data"][@"player"];
    
    NSMutableDictionary *mutaDic = [NSMutableDictionary dictionary];
    
    NSMutableArray *Players = [NSMutableArray array];
    NSMutableArray *goods = [NSMutableArray array];
    
    for (NSDictionary *player in dataArr) {
        
        self.small_NewImage = player[@"photo"][@"small"];
        self.goods_id = player[@"actionId"];
        
        [Players addObject:self.small_NewImage];
        [goods addObject:self.goods_id];
    }
    
    mutaDic[@"small"] = Players;
    mutaDic[@"goods_id"] = goods;
    return [mutaDic copy];
}


@end
