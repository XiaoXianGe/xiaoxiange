//
//  CartDoodsListModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/9/14.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartDoodsListModel : NSObject
/**
 *  商品ID
 */
@property (nonatomic, strong)NSString *rec_id;
/**
 *  商品名称
 */
@property (nonatomic, strong)NSString *goods_name;
/**
 *  商品价格
 */
@property (nonatomic, strong)NSString *goods_price;
/**
 *  商品数量
 */
@property (nonatomic, strong)NSString *goods_number;
/**
 *  商品图片url
 */
@property (nonatomic, strong)NSString *img_small;

/**
 *  商品规格
 */
@property (nonatomic, strong)NSString *goods_attr_value;

/**
 *  商品规格
 */
@property (nonatomic, strong)NSString *buymax;
/** 商店名称 */
@property (strong, nonatomic) NSString *shopName;
/** 商店名称 */
@property (strong, nonatomic) NSString *seller_id;
/** 商品id */
@property (strong, nonatomic) NSString *goods_id;

+ (id)parseCartDoodsListDict:(NSDictionary *)dict;
/*{
    status = {
        succeed = 1
    },
    data = {
        goods_list = [
        {
            goods_attr_id = ,
            extension_code = ,
            is_shipping = 0,
            market_price = 1.08元,
            is_real = 1,
            img = {
                thumb = http://www.haocaimao.com/images/201510/goods_img/8149_G_1445644767539.jpg,
                url = http://www.haocaimao.com/images/201510/source_img/8149_G_1445644767829.jpg,
                small = http://www.haocaimao.com/images/201510/thumb_img/8149_thumb_G_1445644767503.jpg
            },
            goods_name = CM 朝美 2002新型防尘口罩 防雾霾工业粉尘口罩保暖夏季口罩,
            goods_attr = ,
            parent_id = 0,
            rec_type = 0,
            goods_img = images/201510/goods_img/8149_G_1445644767539.jpg,
            buymax_start_date = 1970/01/01 08:00:00 +0800,
            subtotal = 0.90元,
            is_gift = 0,
            goods_price = 0.90元,
            goods_id = 8149,
            goods_number = 1,
            original_img = images/201510/source_img/8149_G_1445644767829.jpg,
            pid = 8149,
            buymax = 0,
            buymax_end_date = 1970/01/01 08:00:00 +0800,
            can_handsel = 0,
            seller_id = 0,
            goods_sn = 2002新型防尘口罩,
            rec_id = 38828
        }
                      ],
        total = {
            saving = 0.18元,
            virtual_goods_count = 0,
            save_rate = 17%,
            market_price = 1.08元,
            real_goods_count = 1,
            goods_amount = 0.9,
            goods_price = 0.90元
        }
    }
}
*/
@end
