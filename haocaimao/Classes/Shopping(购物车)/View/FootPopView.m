//
//  FootPopView.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/17.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "FootPopView.h"
#import "FootCollectionViewCell.h"
#import "CategoryGoods.h"
@interface FootPopView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end
@implementation FootPopView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        FootCollectionView *fool = [FootCollectionView loadCollectionView];
        self.fool = fool;
        fool.delegate = self;
        fool.dataSource = self;
        [self addSubview:fool];
        fool.backgroundColor =  HCMColor(242, 242, 242, 1.0);
        
        UIImageView *Top = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, HCMScreenWidth, 35)];
        Top.backgroundColor = [UIColor whiteColor];
        [self addSubview:Top];

        
        UILabel *topName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 25)];
        topName.text = @"你可能想要";
        topName.textColor = [UIColor darkGrayColor];
        [self addSubview:topName];
        
        UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        popBtn.frame = CGRectMake(HCMScreenWidth - 40, 5, 30, 30);
        [popBtn setImage:[UIImage imageNamed:@"item-info-popViewDown@2x 2"] forState:UIControlStateNormal];
        [HCMNSNotificationCenter postNotificationName:@"pop" object:self userInfo:@{@"popBtn":popBtn,@"fool":self.fool}];
        [self addSubview:popBtn];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, HCMScreenHeight/2 - 80, HCMScreenWidth, 230);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _goods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FootCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    CategoryGoods *good = _goods[indexPath.row];

    cell.shopName.text = good.goods_name;
    
    cell.money.text = [NSString stringWithFormat:@"%@元", good.shop_price];
   
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:good.img[@"small"]] placeholderImage:[UIImage imageNamed:@"searcher-no-result-empty-icon"]];
    return cell;
}


- (void)showFoolView{
    [self removeFromSuperview];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CategoryGoods *good = _goods[indexPath.row];

    [HCMNSNotificationCenter postNotificationName:@"clickCollectionView" object:nil userInfo:@{@"good_id":good.goods_id}];
}
- (void)setGoods:(NSMutableArray *)goods{
    _goods = goods;
    [self.fool reloadData];
}
@end
