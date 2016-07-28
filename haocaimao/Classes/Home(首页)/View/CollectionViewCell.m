//
//  CollectionViewCell.m
//  haocaimao
//
//  Created by 好采猫 on 15/10/14.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "CollectionViewCell.h"
@interface CollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *good_Image;
@property (weak, nonatomic) IBOutlet UILabel *good_Name;

@property (weak, nonatomic) IBOutlet UILabel *shop_price;


@end

@implementation CollectionViewCell

-(void)setCategoryModel:(HomeCategoryCellModel *)categoryModel{
    
    _categoryModel = categoryModel;
    
    [self.good_Image sd_setImageWithURL:[NSURL URLWithString:categoryModel.goods_image] placeholderImage:[UIImage imageNamed:@"searcher-no-result-empty-icon"]];
    
    self.good_Name.text = categoryModel.goods_name;
    
    if ([categoryModel.promote_price isEqualToString:@""]) {
         self.shop_price.text = [NSString stringWithFormat:@"￥%@",categoryModel.goods_price];
    }else{
         self.shop_price.text = [NSString stringWithFormat:@"￥%@",categoryModel.promote_price];
    }
   
    //promote_price
    
    
    
    self.goods_id = categoryModel.goods_id;
    
}


@end
