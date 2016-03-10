//
//  HCMCartSection.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/24.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMCartSection.h"
#import "CartListFrame.h"
#import "CartDoodsListModel.h"

@interface HCMCartSection()

@property (nonatomic, weak)UIView *goodsView;//商品view
@property (nonatomic, weak)UILabel *goodShopLabel; //商店名称
@property (nonatomic, weak)UIImageView *halvingLineIma; //分割线
@property (assign, nonatomic) CGRect deleteShopBtnF;

@end
@implementation HCMCartSection
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self shopView];
        self.frame = CGRectMake(0, 0, HCMScreenWidth, 40);
    }
    
    return self;
}
- (void)shopView{
    
    UIView *goodsView = [[UIView alloc]init];
    goodsView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:goodsView];
    self.goodsView = goodsView;
   
    
    UILabel *goodShopLabel = [[UILabel alloc]init];
    goodShopLabel.textColor = [UIColor redColor];
    goodShopLabel.font = HCMshopNameFont;
    
    [self.goodsView addSubview:goodShopLabel];
    self.goodShopLabel = goodShopLabel;
    
    UIImageView *halvingLine = [[UIImageView alloc]init];
    halvingLine.backgroundColor = [UIColor grayColor];
    
    [self.goodsView addSubview:halvingLine];
    self.halvingLineIma = halvingLine;
    
   
}

- (void)setListFrame:(CartListFrame *)listFrame{
    _listFrame = listFrame;
    self.goodsView.frame = CGRectMake(0,0 ,HCMScreenWidth ,30);
    self.goodShopLabel.frame = listFrame.goodShopLabelF;
    self.goodShopLabel.text = listFrame.listModel.shopName;
    self.halvingLineIma.frame = listFrame.halvingLineImaF;
    self.deleteShopBtnF = listFrame.deleteShopBtnF;

}
@end
