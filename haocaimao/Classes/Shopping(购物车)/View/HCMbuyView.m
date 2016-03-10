//
//  HCMbuyView.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/16.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMbuyView.h"

#define HCMBtnW 90
#define HCMBtnH 30
#define HCMBtn 40
#define HCMBtnX 50
@interface HCMbuyView()
@property (weak, nonatomic) UIImageView *backgroundImage;
@property (weak, nonatomic) UIButton *actBtn;
@property (weak, nonatomic) UIButton *attBtn;
@property (weak, nonatomic) UIView *headerView;



@end

@implementation HCMbuyView
- (instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.x = self.y = 0;
        self.width = HCMScreenWidth;
        self.height = HCMScreenHeight/2 - 90;
        
        [self setupheaderView];
           }
    return self;
}

- (void)setupheaderView{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    self.headerView = headerView;
    [self addSubview:headerView];
    UIImageView *imagaView = [[UIImageView alloc]init];
    imagaView.image = [UIImage imageNamed:@"image-info-buy-gouwuche"];
    self.backgroundImage = imagaView;
    [headerView addSubview:imagaView];
   
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self setupButtonWithView:headerView];
    }
    
}


- (void)setupButtonWithView:(UIView *)headerView{
    
    UIButton *actBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [actBtn setBackgroundImage:[UIImage imageNamed:@"item-info-buy-huodong"] forState:UIControlStateNormal];
    [actBtn addTarget:self action:@selector(clickActBtn) forControlEvents:UIControlEventTouchUpInside];
    self.actBtn = actBtn;
    [headerView addSubview:actBtn];
    
    UIButton *attBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [attBtn setBackgroundImage:[UIImage imageNamed:@"item-info-buy-guanzhu"] forState:UIControlStateNormal];
    [attBtn addTarget:self action:@selector(clickAttBtn) forControlEvents:UIControlEventTouchUpInside];
    self.attBtn = attBtn;
    
    [headerView addSubview:attBtn];
}

- (void)showHeaderView{
    [self removeFromSuperview];
}//外界控制header显示方法
- (void)clickActBtn{
    [SVProgressHUD showInfoWithStatus:@"功能暂未开通"];
}
- (void)clickAttBtn{
    [SVProgressHUD showInfoWithStatus:@"功能暂未开通"];

}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.headerView.x = 0;
    self.headerView.y = 10;
    self.headerView.width = HCMScreenWidth;
    self.headerView.height = HCMScreenHeight/2 - 100  ;
    
    self.backgroundImage.x = (HCMScreenWidth - 160)/2 ;
    self.backgroundImage.y = 0;
    self.backgroundImage.width = 160;
    self.backgroundImage.height = 140;
    
    self.actBtn.x = HCMBtnX;
    self.actBtn.height = HCMBtnH;
    self.actBtn.width = HCMBtnW;
    self.actBtn.y = self.headerView.height- HCMBtn;
    
    self.attBtn.x = HCMScreenWidth - HCMBtnX - HCMBtnW;
    self.attBtn.height = HCMBtnH;
    self.attBtn.width = HCMBtnW;
    self.attBtn.y = self.headerView.height- HCMBtn;
    
    
    
    
    
}
@end
