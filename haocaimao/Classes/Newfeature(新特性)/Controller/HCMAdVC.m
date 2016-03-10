//
//  HCMAdVC.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/4.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMAdVC.h"
#import "HCMTabBarViewController.h"

@interface HCMAdVC ()

@property (strong, nonatomic) UIImageView *adImageView;
@property (strong, nonatomic) NSTimer *adTImer;

@end

@implementation HCMAdVC
{
    int _count;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [bgImage setImage:[UIImage imageNamed:@"new-ad"]];
    
    self.adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 100, 200, 200)];
    
    [self.view addSubview:bgImage];
     [self.view addSubview:self.adImageView];
    
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:@"http://p3.img.cctvpic.com/nettv/newgame/cdn_pic/2503/mzm.ygiqaoff.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:self.adImageView.frame];
        [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }];
    
    _count = 0;
    
    self.adTImer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTheCountdown:) userInfo:nil repeats:YES];
}

- (void)startTheCountdown:(NSTimer *)timer{
    
    _count ++;
    
    if (_count == 3) {
        
        [timer invalidate];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window setBackgroundColor:[UIColor whiteColor]];
        
        [UIView transitionWithView:window duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            window.rootViewController = [[HCMTabBarViewController alloc]init];
        } completion:nil];
    }
}


- (void)clickBtn{
    
    [self.adTImer invalidate];
    
    UIWebView *adWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [adWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.haocaimao.com/mobile/index.php?m=default&c=goods&a=index&id=161"]]];
    [self.view addSubview:adWebView];
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 44, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"channel_delete_btn"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
}

- (void)clickBackBtn{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window setBackgroundColor:[UIColor whiteColor]];
    
    [UIView transitionWithView:window duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
         window.rootViewController = [[HCMTabBarViewController alloc]init];
    } completion:nil];
}

@end
