//
//  HCMTabBar.m
//  haocaimao
//
//  Created by 好采猫 on 16/2/23.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import "HCMTabBar.h"
#import "HCMAdvisoryViewController.h"
#import "HCMVipLoginViewController.h"
#import "HomeNetwork.h"

@interface HCMTabBar()<UIAlertViewDelegate>

/** 我要咨询 按钮 */
@property(nonatomic,weak)UIButton * consultingBtn;

@property (strong, nonatomic)NSUserDefaults *defaults;

@property (assign, nonatomic)BOOL status;

@property(nonatomic,weak)UIView * backView;

@end

@implementation HCMTabBar

-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        //去除tabbar顶部线条 (此线会档住"我要咨询"按钮)
        CGRect rect = CGRectMake(0, 0, HCMScreenWidth, HCMScreenHeight);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self setBackgroundImage:img];
        [self setShadowImage:img];
        
        //添加咨询按钮consultingBtn
        UIButton * consultingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [consultingBtn setBackgroundImage:[UIImage imageNamed:@"我要询价"] forState:UIControlStateNormal];
//        [consultingBtn setBackgroundImage:[UIImage imageNamed:@"我要询价"] forState:UIControlStateHighlighted];
        
        [consultingBtn sd_setImageWithURL:[NSURL URLWithString:@"http://www.haocaimao.com/ios/33.png"] forState:UIControlStateNormal];
        [consultingBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:@"http://www.haocaimao.com/ios/33.png"] forState:UIControlStateHighlighted];
        
        [consultingBtn addTarget:self action:@selector(goToconsulting) forControlEvents:UIControlEventTouchUpInside];

//        consultingBtn.size = consultingBtn.currentBackgroundImage.size;
        consultingBtn.size = CGSizeMake(50, 47);
       
        self.consultingBtn = consultingBtn;
        
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = HCMColor(56, 56, 56,1.0);

        [self insertSubview:backView atIndex:0];
        [self addSubview:self.consultingBtn];
        
        self.backView = backView;

    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //改变tabbar的高度
//    self.y = HCMScreenHeight - 45;
//    self.height = 45;
    
   // UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    self.backView.frame = CGRectMake(0, 0, HCMScreenWidth, 56);
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    // 设置发布按钮的frame
    self.consultingBtn.center = CGPointMake(width * 0.5, height * 0.5);
    
    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    for (UIView *button in self.subviews) {
        if (![button isKindOfClass:[UIControl class]] || button == self.consultingBtn) continue;
        
        // 计算按钮的x值
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 增加索引
        index++;
    }
}

//我要咨询
-(void)goToconsulting{
    
    self.status = [self.defaults boolForKey:@"status"];
    
    if (!_status) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"立即登录" message:@"登录之后，才可以询价噢" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
        [alert show];
        
    }else{
        HCMAdvisoryViewController *adVC = [[HCMAdvisoryViewController alloc]initWithNibName:@"HCMAdvisoryViewController" bundle:nil];
        
        [self.window.rootViewController presentViewController:adVC animated:YES completion:nil];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        //根据点击的按钮的index，获取这个按钮的标题
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        
        if ([title isEqualToString:@"去登录"]) {
            
            HCMVipLoginViewController *login =[[HCMVipLoginViewController alloc]init];
            
            [self.window.rootViewController presentViewController:login animated:YES completion:nil];
            
        }
    
}

@end
