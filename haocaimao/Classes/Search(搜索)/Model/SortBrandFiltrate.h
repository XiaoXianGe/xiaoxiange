//
//  SortBrandFiltrate.h
//  haocaimao
//
//  Created by 李芷贤 on 15/9/17.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortBrandFiltrate : NSObject

/*
 "data": [
 {
 "url": "1425407971030414494.jpg",
 "brand_name": "3M",
 "brand_id": "44"
 },
 {
 "url": "1425408017362195446.jpg",
 "brand_name": "冠桦",
 "brand_id": "45"
 },
 */

@property(strong,nonatomic)NSString *brand_name;
@property(strong,nonatomic)NSString *brand_id;

/**
 *  解析牌子模型
 */
+(id)parseSortFiltrateWith:(NSDictionary *)dict;



@end
