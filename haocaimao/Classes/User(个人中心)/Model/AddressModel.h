//
//  AddressModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/9/6.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//
//  地址管理模型

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
/**
 *  地址ID
 */
@property (strong, nonatomic)NSString *ID;
/**
 *  收件人
 */
@property (strong, nonatomic)NSString *consignee;
/**
 *  省
 */
@property (strong, nonatomic)NSString *province_name;
/**
 *  市
 */
@property (strong, nonatomic)NSString *city_name;
/**
 *  区
 */
@property (strong, nonatomic)NSString *district_name;
/**
 *  详细地址
 */
@property (strong, nonatomic)NSString *address;
/**
 *  是否为默认地址
 */
@property (strong, nonatomic)NSNumber *default_address;

+ (id)parseAddressData:(NSDictionary *)dict;

@end
