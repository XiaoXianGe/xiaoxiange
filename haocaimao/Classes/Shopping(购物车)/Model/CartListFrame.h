//
//  CartListFrame.h
//  haocaimao
//
//  Created by 好采猫 on 15/11/18.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CartDoodsListModel;
typedef void (^goodsBlock)(BOOL obj);
@interface CartListFrame : NSObject
/** 删除商店的按钮 */
@property (assign, nonatomic) CGRect deleteShopBtnF;
 /** 商品view */
@property (nonatomic, assign)CGRect goodsViewF;
 /** 点击编辑view */
@property (nonatomic, assign)CGRect clickEditBtnF;
 /** 商品店名 */
@property (nonatomic, assign)CGRect goodShopLabelF;
 /** 分割线 */
@property (nonatomic, assign)CGRect halvingLineImaF;
 /** 商品名称 */
@property (nonatomic, assign)CGRect goodsNameLabelF;
 /** 商品数量 */
@property (nonatomic, assign)CGRect goodsNumberLabelF;
 /** 商品规格 */
@property (nonatomic, assign)CGRect goodsAttrValueLabelF;

 /** 商品图片 */
@property (nonatomic, assign)CGRect goodsImgF;
 /** 选择按钮 */
@property (assign, nonatomic) CGRect selectedBtnF;
/** 商品价格 */
@property (nonatomic, assign)CGRect goods_priceF;

 /** 增加数量的按钮 */
@property (nonatomic, assign)CGRect addGoodsF;
 /** 减少数量的按钮 */
@property (nonatomic, assign)CGRect reduceGoodsF;
 /** 数量显示 */
@property (nonatomic, assign)CGRect numberGoodsF;
 /** cell的高度 */
@property (assign, nonatomic) CGFloat cellHeightF;
@property (assign, nonatomic) CGRect buyViewF;
@property (copy, nonatomic) goodsBlock goods;

@property (strong, nonatomic) CartDoodsListModel *listModel;
#define HCMgoodsNameFont [UIFont systemFontOfSize:12]
#define HCMshopNameFont  [UIFont systemFontOfSize:13]
#define HCMgoods_priceFont [UIFont systemFontOfSize:13]
@end
