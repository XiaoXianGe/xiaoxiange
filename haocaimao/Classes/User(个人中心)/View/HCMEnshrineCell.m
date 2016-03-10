//
//  HCMEnshrineCell.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/1.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMEnshrineCell.h"


@interface HCMEnshrineCell()

@property (weak, nonatomic) IBOutlet UIImageView *commodityImage;
@property (weak, nonatomic) IBOutlet UILabel *commodityName;
@property (weak, nonatomic) IBOutlet UILabel *commodityCostPrice;



@end

@implementation HCMEnshrineCell


-(void)setEnshrine:(UserEnshrine *)enshrine{
    
    _enshrine = enshrine;

    [self.commodityImage sd_setImageWithURL:[NSURL URLWithString:enshrine.img_small] placeholderImage:[UIImage imageNamed:@"searcher-no-result-empty-icon"]];
    self.commodityName.text = enshrine.name;
    
    self.commodityCostPrice.text = [NSString stringWithFormat:@"￥%@",[enshrine.promote_price isEqualToString:@""] ? enshrine.shop_price : enshrine.promote_price];
    
    self.rem_ID = enshrine.rec_id;
    
}

- (IBAction)clickDelete:(UIButton *)sender {
        
    [self.delegate clickDeleteCell:self];
    
}
//
//- (void)drawRect:(CGRect)rect
//{
//    [[UIImage imageNamed:@"index-body-bg"] drawAsPatternInRect:rect];
//}

@end
