//
//  HCMSortTool.h
//  haocaimao
//
//  Created by 好采猫 on 16/4/16.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCMSortTool : NSObject

+ ( NSDictionary * )sortWithDictBrand_id:(NSInteger)brand_id keyWords:(NSString *)keyWords category_id:(NSString *)category_id price_min:(NSString *)price_min price_max:(NSString *)price_max page:(NSInteger)page sortWay:(NSString *)sortWay;
@end
