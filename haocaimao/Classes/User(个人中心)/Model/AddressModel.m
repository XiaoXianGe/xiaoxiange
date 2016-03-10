//
//  AddressModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/6.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

+ (id)parseAddressData:(NSDictionary *)dict{
    
    return [[AddressModel alloc]initWithDictionaryData:dict];
    
}

- (id)initWithDictionaryData:(NSDictionary *)dataDic {
    
    self = [super init];
    
    if (self) {
        
        self.ID = dataDic[@"id"];
        self.consignee = dataDic[@"consignee"];
        self.province_name = dataDic[@"province_name"];
        self.city_name = dataDic[@"city_name"];
        self.district_name = dataDic[@"district_name"];
        self.address = dataDic[@"address"];
        self.default_address = dataDic[@"default_address"];

    }
    return self;
}
@end
