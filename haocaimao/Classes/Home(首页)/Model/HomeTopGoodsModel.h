//
//  HomeTopGoodsModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/8/18.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeTopGoodsModel : NSObject

//广告栏图片
@property(nonatomic,copy)NSString *small_NewImage;
//广告栏
@property(nonatomic,copy)NSString *url_New;
@property(nonatomic, strong)NSMutableArray *array;

//状态
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *goods_id;

+(NSMutableDictionary *)NewsWithJSON:(NSDictionary *)dic;


@end
