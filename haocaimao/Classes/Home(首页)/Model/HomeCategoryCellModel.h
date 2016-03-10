//
//  HomeCategoryCellModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/8/13.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCategoryCellModel : NSObject

@property(nonatomic,copy)NSString *goods_id;
@property(nonatomic,copy)NSString *goods_name;
@property(nonatomic,copy)NSString *goods_price;
@property(nonatomic,copy)NSString *goods_image;
@property(nonatomic,copy)NSString *goods_market_price;
@property(nonatomic,copy)NSString *promote_price;


+(id)collectionGoodsWithCategoryJSON:(NSDictionary *)dic;
@end
