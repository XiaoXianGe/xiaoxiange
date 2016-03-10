//
//  HCMWebViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/27.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMWebViewController.h"

#import "UserModelTool.h"
#import "AddressNerworking.h"
@interface HCMWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
/**
 *  时间定时器
 */
@property (strong, nonatomic)NSTimer *timer;

@end

@implementation HCMWebViewController

static NSString *const url = @"http://www.haocaimao.com/ecmobile/?url=article";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = self.titleName;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    [self networkRequest:self.titleName];
    
}

- (void)clickBack
{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)networkRequest:(NSString *)netKey{
    
    
    NSDictionary *dict = @{@"article_id":[self modelParsingParameter:netKey]};
    
    [SVProgressHUD show];
    
    [[AddressNerworking sharedManager]postUserArticle:dict url:url successBlock:^(id responseBody) {
        
        [SVProgressHUD showSuccessWithStatus:nil];
        
        if (responseBody[@"status"][@"error_code"]) {
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
        
        NSString *webPath = responseBody[@"data"];
        
        [self.webView loadHTMLString:webPath baseURL:nil];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:@"网络错误"];
        
    }];
    
}

- (NSString *)modelParsingParameter:(NSString *)parameter{
    
    return [UserModelTool userClassifyWebView:parameter];
    
}



@end
