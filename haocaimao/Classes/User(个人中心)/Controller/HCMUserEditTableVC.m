//
//  HCMUserEditTableVC.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/2.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMUserEditTableVC.h"

#import "HCMVipLoginViewController.h"

#import "SDImageCache.h"

@interface HCMUserEditTableVC ()<UIActionSheetDelegate>
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *Cells;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UITableViewCell *appInfo;
@property (weak, nonatomic) IBOutlet UILabel *diskLabel;

@property (strong, nonatomic)NSUserDefaults *defaults;

@property (assign, nonatomic)NSUInteger cacheSize;
@end

@implementation HCMUserEditTableVC

- (NSUserDefaults *)defaults{
    
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tableView.tableFooterView = self.footView;
    
    self.tableView.tableFooterView.hidden = ![self.defaults boolForKey:@"status"];
    
    self.cacheSize = [[SDImageCache sharedImageCache]getSize];
    
    NSString *cacheStr = [NSString stringWithFormat:@"图片缓存 %.2lfMB",(double)self.cacheSize/1024/1024];
    
    self.diskLabel.text = cacheStr;
    
    [self.tableView reloadData];
    
    self.tabBarController.tabBar.hidden = YES;

}

#pragma leftBarButtonItem
- (void)clickBack
{
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else{
        return [self.Cells count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        return self.appInfo;
    }else{
        if (0 == indexPath.row) {
            return self.Cells[indexPath.row];
        }else{
            return self.Cells[indexPath.row];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        // 打电话
        if (indexPath.row == 0){
            NSURL *phoneURL = [NSURL URLWithString:@"tel:4008-776-879"];
            UIWebView *phoneWeb = [[UIWebView alloc]initWithFrame:CGRectZero];
            [phoneWeb loadRequest:[NSURLRequest requestWithURL:phoneURL]];
            [self.view addSubview:phoneWeb];
            
        }
        // 跳到官网
        if (indexPath.row == 1) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.haocaimao.com"]];
        }
    }
}

// 清除图片缓存
- (IBAction)clickClearDisk:(UIButton *)sender {
    
    
    [UIView animateWithDuration:1 animations:^{
        
        sender.transform = CGAffineTransformRotate(sender.transform, M_PI);
        
        [[SDImageCache sharedImageCache] clearDisk];
        self.diskLabel.text = @"图片缓存";
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"app信息";
    }else{
        return @"官方信息";
    }
}

#pragma mark - 注销
- (IBAction)userCancel:(UIButton *)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"是否注销账户" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:nil];
    
    [sheet showInView:self.view];
    
}
// 注销的话 清除http的cookie
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        [self.defaults setBool:NO forKey:@"status"];
        [self.defaults setObject:nil forKey:@"userName"];
        [self.defaults removeObjectForKey:@"sid"];
        [self.defaults removeObjectForKey:@"uid"];
        [self.defaults removeObjectForKey:@"headimgurl"];
        [self.defaults removeObjectForKey:@"imgData"];
        [self.defaults removeObjectForKey:@"unionid"];

        [self.defaults synchronize];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLoginOut" object:nil userInfo:nil];
        
        NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie*cookie in [cookieJar cookies]) {
            [cookieJar deleteCookie:cookie];
        }
        
        CATransition *animation = [CATransition animation];
        animation.duration = 1;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"rippleEffect";
        //animation.type = kCATransitionFade;
        animation.subtype = kCATransitionFromTop;
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        HCMVipLoginViewController *vipLogin = [[HCMVipLoginViewController alloc]initWithNibName:@"HCMVipLoginViewController" bundle:nil];
        
        [self.navigationController pushViewController:vipLogin animated:YES];
        
    }
}


@end
