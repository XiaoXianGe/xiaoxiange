//
//  CategoryGoods.h
//  UICollectionView Section
//
//  Created by 好采猫 on 15/10/15.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface CategoryGoods : NSObject


@property (nonatomic, strong)NSString *goods_name;

@property (nonatomic, strong)NSString *goods_id;

@property (nonatomic, strong)NSString *market_price;

@property (nonatomic, strong)NSString *shop_price;

@property (nonatomic, strong)NSString *goods_thumb;

@property (nonatomic, strong)NSString *promote_price;
@property (strong, nonatomic) NSDictionary *img;

+(id)parsingDataOfDict:(NSDictionary *)dic;
@end
