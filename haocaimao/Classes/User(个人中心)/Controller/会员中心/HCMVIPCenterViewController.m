//
//  HCMVIPCenterViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/10.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMVIPCenterViewController.h"
#import "HCMLayoutEnshrine.h"
#import "HCMUserEnshrineCollectionViewController.h"
#import "HCMVipLoginViewController.h"

#import "HCMUserEditTableVC.h"
#import "HCMHongBaoTableViewController.h"
#import "HCMChangePasswordViewController.h"

#import "HCMMyWalletTableViewController.h"
#import "HCMBusinessViewController.h"
#import "HCMStockoutTableViewController.h"
#import "HCMSaleGoodsTableViewController.h"

#import "AddressNerworking.h"
#import "HCMUserInfoViewController.h"


@interface HCMVIPCenterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;

@property (weak, nonatomic) IBOutlet UILabel *UserNmae;
@property (weak, nonatomic) IBOutlet UILabel *level;

@property (weak, nonatomic) IBOutlet UILabel *money;

@property (strong, nonatomic)NSUserDefaults *defaults;

@property (assign, nonatomic)BOOL status;

@end

@implementation HCMVIPCenterViewController

-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"会员俱乐部";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    [self getTheInfo];
    
    [self networking];
    
}

- (void)networking{
     self.status = [self.defaults boolForKey:@"status"];
    if (self.status) {
        
        NSString *sid = [self.defaults objectForKey:@"sid"];
        NSString *uid = [self.defaults objectForKey:@"uid"];
        
        NSDictionary *dict = @{@"session":@{@"sid":sid,@"uid":uid}};
        
        [[AddressNerworking sharedManager]postUserInfo:dict successBlock:^(id responseBody) {
            
            if (responseBody[@"status"][@"error_code"]) {
                [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
                return ;
            }
            self.UserNmae.text = [responseBody[@"data"][@"name"] description];
            [self.UserNmae adjustsFontSizeToFitWidth];
            self.level.text = [NSString stringWithFormat:@"%@ 级",[responseBody[@"data"][@"rank_level"]description]];
            

        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:@"网络有问题"];
            
        }];
        
    }
}

-(void)getTheInfo{
        
    if (self.dic[@"data"][@"money"]) {
        self.money.text = [NSString stringWithFormat:@"%@ 元",[self.dic[@"data"][@"money"] description]];
    }
    
    self.status = [self.defaults boolForKey:@"status"];
    
    if (self.status) {
        
        NSData *imgData = [self.defaults objectForKey:@"imgData"];
        if (imgData == nil) {
            [self.headIcon setImage:[UIImage imageNamed:@"头像"]];
        }else{
            UIImage *img = [UIImage imageWithData:imgData];
            [self.headIcon setImage:img];
        }
        
    }else{
        
        [self.headIcon setImage:[UIImage imageNamed:@"头像"]];
        
    }
    
    
}

- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

//注销帐号
- (IBAction)exitLogin {
    
    HCMUserEditTableVC *UserEditVC = [[HCMUserEditTableVC alloc]initWithNibName:@"HCMUserEditTableVC" bundle:nil];
    
    [self.navigationController pushViewController:UserEditVC animated:YES];
    
}

//用户信息
- (IBAction)accountMsg {
    
    HCMUserInfoViewController  *vc = [[HCMUserInfoViewController alloc]initWithNibName:@"HCMUserInfoViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

//我的红包
- (IBAction)myHongBao {
    
    HCMHongBaoTableViewController *hbVC = [[HCMHongBaoTableViewController alloc]initWithNibName:@"HCMHongBaoTableViewController" bundle:nil];
    [self.navigationController pushViewController:hbVC animated:YES];
    
}

//修改密码
- (IBAction)changePassword {
    
    HCMChangePasswordViewController *pwvc = [[HCMChangePasswordViewController alloc]initWithNibName:@"HCMChangePasswordViewController" bundle:nil];
    
    [self.navigationController pushViewController:pwvc animated:YES];
    
    
}

//资金管理（我的钱包）
- (IBAction)myWallet {
    
    HCMMyWalletTableViewController *mywVc = [[HCMMyWalletTableViewController alloc]initWithNibName:@"HCMMyWalletTableViewController" bundle:nil];
    
    [self.navigationController pushViewController:mywVc animated:YES];
    
}

//企业申请
- (IBAction)business {
    
    HCMBusinessViewController *busVC = [[HCMBusinessViewController alloc]initWithNibName:@"HCMBusinessViewController" bundle:nil];
    [self.navigationController pushViewController:busVC animated:YES];
    
}

//缺货登记
- (IBAction)Stockout {
    
    HCMStockoutTableViewController *skVC = [[HCMStockoutTableViewController alloc]initWithNibName:@"HCMStockoutTableViewController" bundle:nil];
    
    [self.navigationController pushViewController:skVC animated:YES];
    
}


//售后服务
- (IBAction)AfterSalesService {
    [SVProgressHUD showInfoWithStatus:@"功能暂未开通"];
}

//特价商品
- (IBAction)SALEGoods {
    
    [SVProgressHUD showInfoWithStatus:@"功能暂未开通"];return;
    /*
    HCMSaleGoodsTableViewController *saleVC = [[HCMSaleGoodsTableViewController alloc]initWithNibName:@"HCMSaleGoodsTableViewController" bundle:nil];
    
    [self.navigationController pushViewController:saleVC animated:YES];
     */
    
}

//跳转动画
-(void)animationtype{
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.75;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    //animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromTop;
    
    [self.view.window.layer addAnimation:animation forKey:nil];
    
}

@end
