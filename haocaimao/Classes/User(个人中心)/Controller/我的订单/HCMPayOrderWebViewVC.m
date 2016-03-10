//
//  HCMPayOrderWebViewVC.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/18.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMPayOrderWebViewVC.h"
#import "HCMShoppingTableViewController.h"

#import "AddressNerworking.h"

@interface HCMPayOrderWebViewVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic,strong)NSUserDefaults *defaults;

@end

@implementation HCMPayOrderWebViewVC

-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults  standardUserDefaults];
    }
    return _defaults;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"支付";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    [self network];
    
}

// 请求支付界面
- (void)network{
    
    self.defaults = [NSUserDefaults  standardUserDefaults];
    NSString *uid = [self.defaults objectForKey:@"uid"];
    NSString *sid = [self.defaults objectForKey:@"sid"];
    
    NSDictionary *dict = @{@"session":@{@"uid":uid,@"sid":sid},
                           @"order_id":self.orderID};
    [SVProgressHUD show];
    
    [[AddressNerworking sharedManager]postOrderPay:dict successBlock:^(id responseBody) {
        
        if (responseBody[@"status"][@"error_code"]) {
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:nil];
        [self.webView loadHTMLString:responseBody[@"data"] baseURL:nil];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:@"订单已转到未付款"];
        
    }];
    
}

// 支付界面
- (void)clickBack{
    
    [SVProgressHUD dismiss];
    
    if (self.status) {

        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
@end
