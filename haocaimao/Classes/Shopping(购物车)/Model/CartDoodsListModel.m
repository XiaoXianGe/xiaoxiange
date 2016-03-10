//
//  CartDoodsListModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/14.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "CartDoodsListModel.h"

@implementation CartDoodsListModel

-(NSString *)goods_attr_value{
    if (!_goods_attr_value) {
        _goods_attr_value = [[NSString alloc]init];
    }
    return _goods_attr_value;
}

+ (id)parseCartDoodsListDict:(NSDictionary *)dict{
    return [[CartDoodsListModel alloc]initWithDictionary:dict];
}

- (id)initWithDictionary:(NSDictionary *)dataDic{

    self = [super init];
    
    if (self) {
        
        self.shopName = @"好采猫官方旗舰店";
               self.rec_id = dataDic[@"rec_id"];
        self.goods_name = dataDic[@"goods_name"];
        self.goods_price = dataDic[@"goods_price"];
        self.goods_number = dataDic[@"goods_number"];
         self.img_small = dataDic[@"img"][@"small"];
        self.seller_id = dataDic[@"seller_id"];
        self.buymax = dataDic[@"buymax"];
        self.goods_id = dataDic[@"goods_id"];
        if ([dataDic[@"goods_attr"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = dataDic[@"goods_attr"];
            
            for (int i = 0 ; i < arr.count; i++) {
                self.goods_attr_value = [self.goods_attr_value stringByAppendingString:dataDic[@"goods_attr"][i][@"value"]];
            }
            
        }
        
    }
    return self;
}

@end

