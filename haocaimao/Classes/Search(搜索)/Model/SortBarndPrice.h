//
//  SortBarndPrice.h
//  haocaimao
//
//  Created by 李芷贤 on 15/9/18.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortBarndPrice : NSObject



/*
 "data": [
 {
 "price_min": 0,
 "price_max": 40000
 },
 {
 "price_min": 40000,
 "price_max": 80000
 },
 
 */

@property(copy,nonatomic)NSString *price_min;
@property(copy,nonatomic)NSString *price_max;


/**
 *  解析价格模型
 */
+(id)parseSortPriceWith:(NSDictionary *)dict;


@end
