//
//  UserEnshrine.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/1.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "UserEnshrine.h"

@implementation UserEnshrine

+ (id)parseEnshrineData:(NSDictionary *)dict{
    
    return [[UserEnshrine alloc]initWithDictionaryData:dict];
    
}

- (id)initWithDictionaryData:(NSDictionary *)dataDic {
    
    self = [super init];
    
    if (self) {
        
        self.goods_id = dataDic[@"goods_id"];
        self.name = dataDic[@"name"];
        self.market_price = dataDic[@"market_price"];
        self.shop_price = dataDic[@"shop_price"];
        self.promote_price = dataDic[@"promote_price"];
        self.img_small = dataDic[@"img"][@"small"];
        self.rec_id = dataDic[@"rec_id"];

        }
    return self;
}

@end
