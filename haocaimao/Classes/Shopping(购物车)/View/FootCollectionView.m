//
//  FootCollectionView.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/17.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "FootCollectionView.h"
#import "FootCollectionFlowLayout.h"
@interface FootCollectionView ()
@property (weak, nonatomic) UILabel *topName;
@property (weak, nonatomic) UIImageView *lineView;
@property (weak, nonatomic) UIPageControl *page;
@property (weak, nonatomic) UIButton *popBtn;



@end
@implementation FootCollectionView
+(instancetype)loadCollectionView{
    FootCollectionView *fool = [[FootCollectionView alloc]initWithFrame:CGRectMake(0, 35 ,HCMScreenWidth,  200) collectionViewLayout:[[FootCollectionFlowLayout alloc]init]];
    fool.backgroundColor = [UIColor whiteColor];
    fool.showsHorizontalScrollIndicator= YES;
        [fool registerNib:[UINib nibWithNibName:@"FootCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    return fool;
}

@end
