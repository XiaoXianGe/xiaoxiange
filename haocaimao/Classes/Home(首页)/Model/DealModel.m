//
//  DealModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/25.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "DealModel.h"
#import "GoodsFormartMessage.h"

@implementation DealModel



//获取商品的价格数量
+(id)GoodsDealWithJSON:(NSDictionary *)dic{
    
    return [[self alloc]initWithGoodsDealJson:dic];
}

- (id)initWithGoodsDealJson:(NSDictionary *)GoodsDealJson{
    self.goods_id = GoodsDealJson[@"data"][@"id"];
    self.goods_name = GoodsDealJson[@"data"][@"goods_name"];
    self.buyMax = GoodsDealJson[@"data"][@"buymax"];
    self.collected = GoodsDealJson[@"data"][@"collected"];
    self.shop_price = GoodsDealJson[@"data"][@"shop_price"];
    self.market_price = GoodsDealJson[@"data"][@"market_price"];
    self.goods_number = GoodsDealJson[@"data"][@"goods_number"];
    self.small_img_URL = GoodsDealJson[@"data"][@"img"][@"small"];
    self.formated_promote_price = GoodsDealJson[@"data"][@"formated_promote_price"];
    self.promote_price = GoodsDealJson[@"data"][@"promote_price"];
    self.promote_end_date = GoodsDealJson[@"data"][@"promote_end_date"];
    self.is_shipping = GoodsDealJson[@"data"][@"is_shipping"];
    
    self.app_app = GoodsDealJson[@"data"][@"app_app"];
    self.mgoods_desc = GoodsDealJson[@"data"][@"mgoods_desc"];
    return self;
}


//获取商品的小图
+(id)GoodsSmallPicturesWithJSON:(NSDictionary *)dic{
    return [[self alloc]initWithSmallPicturesJson:dic];
}
-(id)initWithSmallPicturesJson:(NSDictionary *)dic{
   
    self = [super init];
    
    if (self) {
        //商品小图
        self.small_pictures_URL = dic[@"small"];
        
    }
    return self;
}

//获取商品的大图
+(id)GoodsPicturesWithJSON:(NSDictionary *)dic{
    return [[self alloc]initWithGoodsPicturesJson:dic];
}

-(id)initWithGoodsPicturesJson:(NSDictionary *)dic{
    
    self = [super init];
    
    if (self) {
        //商品大图
        self.thumb_pictures_URL = dic[@"thumb"];
    }
    
    return self;
}



//获取规格信息
+(id)GoodFormatMessageWithJSON:(NSDictionary *)dic{
    return [[self alloc]initWithGoodsFormatJson:dic];
}
-(id)initWithGoodsFormatJson:(NSDictionary *)dic{
    
    self = [super init];
    
    if (self) {
        
        self.format_label = dic[@"label"];
        self.add_formatPrice = dic[@"price"];
        self.format_price = dic[@"format_price"];
        self.format_id = dic[@"id"];
        
    }
    return self;
    
}




@end
