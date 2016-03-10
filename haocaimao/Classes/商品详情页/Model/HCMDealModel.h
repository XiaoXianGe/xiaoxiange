//
//  HCMDealModel.h
//  ScrollPageDown_Demo
//
//  Created by 好采猫 on 16/3/2.
//  Copyright © 2016年 LJH. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface HCMDealModel : NSObject
/** 商品的id */
@property(nonatomic,copy)NSString *goods_id;
/** 商品的名字 */
@property(nonatomic,copy)NSString *goods_name;
/** 商品的最大购买数 */
@property(nonatomic,copy)NSString *buyMax;
/** 商品的收藏 */
@property(nonatomic,strong)NSNumber * collected;
/** 商品的市场价格 */
@property(nonatomic,copy)NSString *market_price;
/** 商品的当前价格 */
@property(nonatomic,copy)NSString *shop_price;
/** 商品的库存 */
@property(nonatomic,copy)NSString *goods_number;
/** 规格数量数组 */
@property(nonatomic,copy)NSString *specification;
/** web 商品详情 */
@property(nonatomic,copy)NSString *mgoods_desc;
/** 商品详情里面的scrollView */
@property(nonatomic,copy)NSString *pictures;


//额外属性//
/** Cell的高度 */
@property (assign,nonatomic)CGFloat CellHeight;

@end
