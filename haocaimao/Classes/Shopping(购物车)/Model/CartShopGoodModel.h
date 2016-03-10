//
//  CartShopGoodModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/11/23.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartShopGoodModel : NSObject
@property (strong, nonatomic) NSArray *goods_list;

+ (id)parseCartShopGoodDict:(NSDictionary *)dict;
@end
