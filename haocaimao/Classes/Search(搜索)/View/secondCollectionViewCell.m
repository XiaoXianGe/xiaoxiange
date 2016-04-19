//
//  secondCollectionViewCell.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/1.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "secondCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface secondCollectionViewCell()
@property (weak, nonatomic) UIImageView *goodsImageView;
@property (weak, nonatomic) UILabel *goodsName;


@end
@implementation secondCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *goodsImageView = [[UIImageView alloc]init];
        self.goodsImageView = goodsImageView;
        [self addSubview:goodsImageView];
        UILabel *goodsName = [[UILabel alloc]init];
        goodsName.font = [UIFont systemFontOfSize:10];
        if (HCMScreenWidth == 414.0) {
            goodsName.font = [UIFont systemFontOfSize:11];
        }
        goodsName.textAlignment = NSTextAlignmentCenter;
        goodsName.textColor = HCMColor(66, 66, 66, 1);
        self.goodsName = goodsName;
        
        [self addSubview:goodsName];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width =(HCMScreenWidth - 100 - 40)/3;
    self.goodsImageView.frame = CGRectMake(0, 0, width, width);
    self.goodsName.frame = CGRectMake(0, width, width, 20);
}
- (void)setGoods_name:(NSString *)goods_name{
    _goods_name = goods_name;
    self.goodsName.text = goods_name;
}
- (void)setGoods_image:(NSString *)goods_image{
    _goods_image = goods_image;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.goods_image] placeholderImage:[UIImage imageNamed:@"searcher-no-result-empty-icon"]];
}
@end
