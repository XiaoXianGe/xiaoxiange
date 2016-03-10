//
//  OrderGoodsListModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/9/16.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderGoodsListModel : NSObject

@property (nonatomic, strong)NSString *consignee;
@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSString *tel;
@property (nonatomic, strong)NSString *country_name;
@property (nonatomic, strong)NSString *province_name;
@property (nonatomic, strong)NSString *district_name;
@property (nonatomic, strong)NSString *city_name;

@property (nonatomic, strong)NSArray *shipping_list;
@property (nonatomic, strong)NSArray *payment_list;
@property (nonatomic, strong)NSArray *inv_content_list;
@property (nonatomic, strong)NSArray *inv_type_list;


+ (id)parseOrderGoodsListDict:(NSDictionary *)dict;

@end
