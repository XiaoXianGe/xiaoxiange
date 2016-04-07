//
//  DealModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/8/25.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealModel : NSObject

@property(nonatomic,copy)NSString *goods_id;
@property(nonatomic,copy)NSString *goods_name;
@property(nonatomic,copy)NSString *buyMax;
@property(nonatomic,strong)NSNumber * collected;

@property(nonatomic,copy)NSString *market_price;
@property(nonatomic,copy)NSString *shop_price;
@property(nonatomic,copy)NSString * goods_number;
@property(nonatomic,copy)NSString * is_shipping;

@property(nonatomic,copy)NSString *small_img_URL;
@property(nonatomic,copy)NSString *thumb_pictures_URL;
@property(nonatomic,copy)NSString *small_pictures_URL;

@property(nonatomic,copy)NSString *formated_promote_price;
@property(nonatomic,strong)NSNumber *promote_price;
@property(nonatomic,copy)NSString *promote_end_date;
//规格value
@property(nonatomic,copy)NSString *format_label;
@property(nonatomic,copy)NSString *add_formatPrice;
@property(nonatomic,copy)NSString *format_price;
@property(nonatomic,copy)NSString *format_id;

@property(nonatomic,copy)NSString *app_app;
@property(nonatomic,copy)NSString *mgoods_desc;

+(id)GoodsDealWithJSON:(NSDictionary *)dic;

+(id)GoodsSmallPicturesWithJSON:(NSDictionary *)dic;

+(id)GoodsPicturesWithJSON:(NSDictionary *)dic;

+(id)GoodFormatMessageWithJSON:(NSDictionary *)dic;




@end
