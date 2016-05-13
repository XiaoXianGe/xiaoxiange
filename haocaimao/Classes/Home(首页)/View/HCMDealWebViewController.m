//
//  HCMDealWebViewController.m
//  haocaimao
//
//  Created by 李芷贤 on 15/8/31.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMDealWebViewController.h"
#import "MBProgressHUD+MJ.h"
#import "DealModel.h"
#import "DealViewController.h"
#import "HomeNetwork.h"


@interface HCMDealWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *DealwebView;
@property (strong, nonatomic)NSTimer *timer;
@property(nonatomic,strong)DealModel *deal;
@property(nonatomic,strong)DealViewController *dealController;
@end

@implementation HCMDealWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"商品详情";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    self.DealwebView.scalesPageToFit = YES;
    
}


-(void)clickBack{
    
    [MBProgressHUD hideHUD];
    
    [self.timer invalidate];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MBProgressHUD showMessage:@"加载中"];
    
    NSDictionary *dict = @{@"goods_id":self.receive_id};
    
    [[HomeNetwork sharedManager]postGoodsDesc:dict successBlock:^(id responseBody) {
        
        NSString *webPath = responseBody[@"data"];
        
        HCMLog(@"webPath %@",webPath);
        
        [self.DealwebView loadHTMLString:webPath baseURL:nil];
        
        [MBProgressHUD hideHUD];
        
    } failureBlock:^(NSString *error) {
        
        [MBProgressHUD hideHUD];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(clickBack) userInfo:nil repeats:NO];
        
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        [MBProgressHUD showMessage:@"加载失败"];
            
    }];
    
}




@end
