//
//  HCMDealCell.m
//  ScrollPageDown_Demo
//
//  Created by 李芷贤 on 16/3/1.
//  Copyright © 2016年 LJH. All rights reserved.
//

#import "HCMDealCell.h"

@interface HCMDealCell()

/** 商品名字 */
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
/** 商品价格 */
@property (weak, nonatomic) IBOutlet UILabel *shop_price;
/** 市场价格 */
@property (weak, nonatomic) IBOutlet UILabel *market_price;
/** 库存 */
@property (weak, nonatomic) IBOutlet UILabel *goods_number;


@end




@implementation HCMDealCell

- (void)awakeFromNib {
    
}

-(void)setHCMDealModel:(HCMDealModel *)HCMDealModel{
    
    _HCMDealModel = HCMDealModel;
    
    self.goods_name.text = self.HCMDealModel.goods_name;
    
    self.shop_price.text = [NSString stringWithFormat:@"￥ %@",self.HCMDealModel.shop_price];
    
    self.market_price.text = [NSString stringWithFormat:@"市场价格: %@",self.HCMDealModel.market_price];
    
    self.goods_number.text = [NSString stringWithFormat:@"库存: %@",self.HCMDealModel.goods_number];
    
}

@end
