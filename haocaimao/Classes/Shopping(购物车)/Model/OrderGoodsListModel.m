//
//  OrderGoodsListModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/16.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "OrderGoodsListModel.h"

@implementation OrderGoodsListModel

+ (id)parseOrderGoodsListDict:(NSDictionary *)dict{
    return [[OrderGoodsListModel alloc]initWithDictionary:dict];
}

- (id)initWithDictionary:(NSDictionary *)dataDic{
    
    self = [super init];
    
    if (self) {
        
        self.consignee = dataDic[@"consignee"][@"consignee"];
        self.address = dataDic[@"consignee"][@"address"];
        self.tel = dataDic[@"consignee"][@"mobile"];
        self.country_name = dataDic[@"consignee"][@"country_name"];
        self.province_name = dataDic[@"consignee"][@"province_name"];
        self.district_name = dataDic[@"consignee"][@"district_name"];
        self.city_name = dataDic[@"consignee"][@"city_name"];
        self.shipping_list = dataDic[@"shipping_list"];
        self.payment_list = dataDic[@"payment_list"];
        self.inv_content_list = dataDic[@"inv_content_list"];
        self.inv_type_list = dataDic[@"inv_type_list"];
        
    }

    return self;
}
@end
