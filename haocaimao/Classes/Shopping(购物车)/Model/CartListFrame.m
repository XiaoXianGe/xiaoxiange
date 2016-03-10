//
//  CartListFrame.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/18.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "CartListFrame.h"
#import "CartDoodsListModel.h"
#define HCMTen 10
#define HCMTwenty 20
#define HCMfive 5
#define HCMtextWidth 180
#define HCMthirty 30

@implementation CartListFrame
//static  BOOL good;
- (void)setListModel:(CartDoodsListModel *)listModel{
    _listModel = listModel;
//    self.goods = ^(BOOL obj){
//       good = obj;
//        
//    };
   
        
    
    CGSize shopSize = [listModel.shopName sizeWithFont:HCMshopNameFont withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGFloat goodShopLabelX = HCMTen;
    
    self.goodShopLabelF = CGRectMake(goodShopLabelX, HCMfive + 5, shopSize.width, shopSize.height);
    
    CGFloat clickBtnH = 15;
    
    //CGFloat clickBtnW = HCMthirty;
    
   // self.clickEditBtnF = CGRectMake(HCMScreenWidth - clickBtnH-clickBtnW, 4, clickBtnW, clickBtnH);
   
    
    self.deleteShopBtnF = CGRectMake(HCMScreenWidth - self.clickEditBtnF.size.width-80, -HCMTwenty, 60, clickBtnH);

    self.halvingLineImaF = CGRectMake(0, CGRectGetMaxY(self.goodShopLabelF) + HCMfive, HCMScreenWidth, 1);
    
    CGFloat goodsImgWH = 80;
    
     self.goodsImgF = CGRectMake(HCMthirty+HCMTen, HCMTen, goodsImgWH, goodsImgWH);
    
    self.selectedBtnF = CGRectMake(8, CGRectGetMidY(self.goodsImgF)-10, HCMTwenty, HCMTwenty);
    
    CGSize goodsNameLabelSize = [listModel.goods_name sizeWithFont:HCMgoodsNameFont withSize:CGSizeMake(HCMtextWidth, 40)];
    
    CGFloat goodsNameLabelX = CGRectGetMaxX(self.goodsImgF)+HCMTen;
    
    self.goodsNameLabelF = CGRectMake(goodsNameLabelX, CGRectGetMidY(self.goodsImgF)-40, goodsNameLabelSize.width, goodsNameLabelSize.height);
    
    CGSize goodsAttrValueLabelSize = [listModel.goods_attr_value sizeWithFont:HCMgoodsNameFont withSize:CGSizeMake(HCMtextWidth, HCMTwenty)];
    
    self.goodsAttrValueLabelF = CGRectMake(goodsNameLabelX, CGRectGetMaxY(self.goodsNameLabelF)+HCMTen, goodsAttrValueLabelSize.width, goodsAttrValueLabelSize.height);
    
    CGSize goods_priceSize = [listModel.goods_price sizeWithFont:HCMgoods_priceFont withSize:CGSizeMake(HCMtextWidth, MAXFLOAT)];
    
    CGFloat reduceGoodsY = CGRectGetMaxY(self.goodsAttrValueLabelF)+HCMfive;
    
    self.goods_priceF = CGRectMake(goodsNameLabelX, reduceGoodsY, goods_priceSize.width, goods_priceSize.height);
    
    self.reduceGoodsF = CGRectMake(HCMScreenWidth - 85,reduceGoodsY , HCMTwenty, HCMTwenty);
    
    self.numberGoodsF = CGRectMake(CGRectGetMaxX(self.reduceGoodsF), reduceGoodsY, HCMthirty, HCMTwenty);
    
    self.addGoodsF = CGRectMake(CGRectGetMaxX(self.numberGoodsF), reduceGoodsY, HCMTwenty, HCMTwenty);
    
    self.goodsViewF = CGRectMake(0, 0, HCMScreenWidth, CGRectGetMaxY(self.goodsImgF)+HCMTen);
    
    self.cellHeightF = CGRectGetMaxY(self.goodsViewF)+HCMTen;
    }
@end
