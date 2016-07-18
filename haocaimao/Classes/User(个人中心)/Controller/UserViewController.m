//
//  UserViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/17.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//
//
//pp 个人中心，余额，优惠券，猫豆的接口:http://www.haocaimao.com/ecmobile/index.php?url=user/account


#import "UserViewController.h"
#import "HCMVipLoginViewController.h"

#import "HCMUserEnshrineCollectionViewController.h"
#import "HCMUserLocationTableViewController.h"
#import "HCMUserEditTableVC.h"

#import "HCMHotGoodsTableViewController.h"
#import "HCMOrderHistoryTableVC.h"
#import "HCMWaitForTheDeliveryTableVC.h"

#import "HCMNotReceivingTableVC.h"
#import "HCMNonPaymentTableVC.h"
#import "AddressNerworking.h"

#import "HCMVIPUserModel.h"
#import "HCMLayoutEnshrine.h"
#import "UserModel.h"
#import "AddressModel.h"

#import "HCMVIPCenterViewController.h"
#import "HCMMyWalletTableViewController.h"
#import "HCMFeedBacksViewController.h"
#import "HCMRecentBrowseTableViewController.h"

#import "HCMHelpTableViewController.h"
#import "HCMAllListTableVC.h"
#import "partnerCell.h"

#import "PartnerViewController.h"
#import "HomeNetwork.h"
#import "HCMPartnerInfoModel.h"
#import "HCMPartnerCenterViewController.h"
#import "MJExtension.h"

#import "HCMMesageViewController.h"

@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource,UITabBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableViewCell *myOrderCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *waitingForDoingCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *myWalletCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *BalanceCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *addressCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *HCMCentreCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *AirlinesCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *HelpMeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *partnerCell;


@property (strong, nonatomic)HCMVIPUserModel *vipUserMobel;

@property (weak, nonatomic) IBOutlet UITableView *UserTableVIew;

@property (strong, nonatomic) IBOutlet UIView *UserLoginView;

@property (strong, nonatomic)NSArray *userArray;

@property (strong, nonatomic)HCMVipLoginViewController *userLogin;
@property (strong, nonatomic)HCMUserLocationTableViewController *userLocationVC;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UIImageView *profileImgBg;

@property (weak, nonatomic) IBOutlet UIButton *userImage;
@property (weak, nonatomic) IBOutlet UIButton *clickLogin;

@property (weak, nonatomic) IBOutlet UITabBar *tabbar;

@property (weak, nonatomic) IBOutlet UITabBarItem *noPayItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *noShipmentsItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *noReceiveItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *ordeHistoryItme;

@property (strong, nonatomic)NSUserDefaults *defaults;

@property (assign, nonatomic)BOOL status;

//HCM2.0
@property (weak, nonatomic) IBOutlet UILabel *MaoDou;
@property (weak, nonatomic) IBOutlet UILabel *YouHuiJuan;
@property (weak, nonatomic) IBOutlet UILabel *money;

@property (strong,nonatomic) NSDictionary *dic;
//@property (strong,nonatomic)UINib *nib;
@property (weak, nonatomic) IBOutlet UILabel *partnerInfoLabel;

@end

@implementation UserViewController



-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

-(HCMVIPUserModel *)vipUserMobel{
    
    if (!_vipUserMobel) {
        _vipUserMobel = [[HCMVIPUserModel alloc]init];
    }
    return _vipUserMobel;
}

- (NSArray *)userArray{
    
    if (!_userArray) {
        
        UserModel *model = [UserModel parseUserData];
        _userArray =  model.userData;
    }
    return _userArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置头视图
    self.navigationItem.title = @"个人中心";
    
    self.tabbar.delegate = self;
    
    self.tabbar.tintColor = HCMColor(144, 144, 144, 1.0);
    self.nameLabel.text = @"登录/注册";
    
    [self updateLoginViewHeight];
    
    self.UserTableVIew.tableHeaderView = self.UserLoginView;
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickEdit) image:@"profile-refresh-site-icon" highImage:@"profile-refresh-site-icon"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(isMessage) image:@"noMessage" highImage:@"noMessage"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:@"UserLoginOut" object:nil];
    
    [self setTabbarImage];
    
}

//适配
-(void)updateLoginViewHeight
{
    
    if (HCMScreenWidth == 414.0) {
         HCMLog(@"%f",HCMScreenWidth);
        self.UserLoginView.height = 186.3;
        self.UserTableVIew.tableHeaderView.height = 186.3;
        self.userImg.layer.cornerRadius = self.userImg.width / 2 - 1;
        self.userImg.clipsToBounds = YES;
        [self.UserTableVIew reloadData];
    }else if (HCMScreenWidth == 375.0) {
         HCMLog(@"%f",HCMScreenWidth);
        self.UserLoginView.height = 168.5;
        self.UserTableVIew.tableHeaderView.height = 168.5;
        self.userImg.layer.cornerRadius = self.userImg.width / 2 - 4;
        self.userImg.clipsToBounds = YES;
        [self.UserTableVIew reloadData];
    }else if(HCMScreenWidth == 320.0){
        HCMLog(@"%f",HCMScreenWidth);
        self.UserLoginView.height = 144;
        self.UserTableVIew.tableHeaderView.height = 144;
        self.userImg.layer.cornerRadius = self.userImg.width / 2 - 6;
        self.userImg.clipsToBounds = YES;
        [self.UserTableVIew reloadData];
    }
    
}

-(void)isMessage
{
    HCMMesageViewController *msgVC = [[HCMMesageViewController alloc]init];
    
    [self.navigationController pushViewController:msgVC animated:YES];
    
}

// 设置tabbar 没有背景线条
- (void)setTabbarImage
{
    
    CGRect rect = CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self.tabbar setBackgroundImage:img];
    
    [self.tabbar setShadowImage:img];
    
    NSArray *array = @[@"user_wait_for_pay",@"user_wait_for_send",@"user_wait_for_speak",@"user_feedback"];
    
    NSUInteger index = 0;
    
    for (UITabBarItem *item in self.tabbar.items) {
        
        item.image = [[UIImage imageNamed:array[index]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        index++;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self isLogin];
    
    
    [self getInfomationForMyWallet];
    
     [self isUpdateAPP];
}

-(void)getInfomationForMyWallet
{
    
    if (self.status) {
        
        
        NSString *sid = [self.defaults objectForKey:@"sid"];
        NSString *uid = [self.defaults objectForKey:@"uid"];
        
        NSDictionary *dict = @{@"session":@{@"sid":sid,@"uid":uid}};
        
        [[AddressNerworking sharedManager]postMyWallet:dict successBlock:^(id responseBody) {
            
            if (responseBody[@"status"][@"error_code"]) {
                return ;
            }
            
            self.dic = responseBody;
            self.MaoDou.text =  [responseBody[@"data"][@"point"] description];
            self.money.text =[responseBody[@"data"][@"money"] description];
            self.YouHuiJuan.text = [responseBody[@"data"][@"coupon"] description];
            
        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:error];
            
        }];
        
    }
    
}


#pragma mark - UITabBarDelegate代付款，发货，收货，反馈

// 设置tabbar的跳转事件（代付款，发货，收货，反馈）
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    switch (item.tag) {
        case 101:
            [self notPaying];
            item.selectedImage = [[UIImage imageNamed:@"user_wait_for_pay"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            break;
        case 102:
            [self notReceiving];
            item.selectedImage = [[UIImage imageNamed:@"user_wait_for_send"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            break;
        case 103:
            [self waitForTheDelivery];
            item.selectedImage = [[UIImage imageNamed:@"user_wait_for_speak"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            break;
        case 104:
            [self orderHistory];
            item.selectedImage = [[UIImage imageNamed:@"user_feedback"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            break;
    }
}

#pragma mark - 判断是否为登录状态

- (void)isLogin
{
    
    self.status = [self.defaults boolForKey:@"status"];
    
    if (self.status) {

            //判断是否为合伙人
            if( [[self.defaults objectForKey:@"realName"] isEqualToString:@""] ){
                
                self.partnerInfoLabel.text = @"申请合伙人>";
            }else{
                self.partnerInfoLabel.text = @"进入合伙人中心>";
            }
            
            [self networking];
            
            self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(networking)];
            
            //[self.tableView addHeaderWithTarget:self action:@selector(networking)];
            
            NSData *imgData = [self.defaults objectForKey:@"imgData"];
            if (imgData == nil) {
                [self.userImg sd_setImageWithURL:[NSURL URLWithString:[self.defaults objectForKey:@"headimgurl"]] placeholderImage:[UIImage imageNamed:@"profile-no-avatar-icon"]];
            }else{
                UIImage *img = [UIImage imageWithData:imgData];
                [self.userImg setImage:img];
            }
        
    }else{
         HCMLog(@"no == self.status");
        
        self.vipUserMobel = nil;
        [self.tableView.header endRefreshing];
        [self.userImg setImage:[UIImage imageNamed:@"user_loginRegion"]];
        self.nameLabel.text = @"";
        self.money.text = @"0";
        self.MaoDou.text = @"0";
        self.YouHuiJuan.text = @"0";
        self.userImage.hidden = YES;
        self.clickLogin.enabled = YES;
        self.partnerInfoLabel.text = @"申请合伙人>";
        
        [self weakUpLogin];
    }
}

//登录提醒
-(void)weakUpLogin
{
   
    //当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    
    //上次的时间戳
    NSString *LastSecond = [self.defaults objectForKey:@"LastSecond_login"];
    
    if (!LastSecond) { //如果没有时间戳，把当前时间戳 存进去
        
        [self.defaults setObject:timeString forKey:@"LastSecond_login"];
        [self.defaults synchronize];
        
    }else{ //如果有时间戳,判断两个时间
        
        // 当前时间戳                  上次时间戳
        NSInteger second = [timeString integerValue] - [LastSecond integerValue];
        
        if ( second > 3600 *24) {
            
            //将当前的时间戳存到沙盒
            [self.defaults setObject:timeString forKey:@"LastSecond_login"];
            [self.defaults synchronize];
            
            self.vipUserMobel = nil;
            [self.tableView.header endRefreshing];
            UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"登录" message:@"登录提醒，你尚未登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [aler show];

        }
    }

}

- (void)networking
{
    
    if (self.status) {
        self.userImage.hidden = !self.status;
        
        self.clickLogin.enabled = !self.status;
        
        NSString *userName = [self.defaults objectForKey:@"userName"];
        
        self.nameLabel.text = userName ? userName : @"";
        
        NSString *sid = [self.defaults objectForKey:@"sid"];
        NSString *uid = [self.defaults objectForKey:@"uid"];
        
        NSDictionary *dict = @{@"session":@{@"sid":sid,@"uid":uid}};
        
        [[AddressNerworking sharedManager]postUserInfo:dict successBlock:^(id responseBody) {
            
            if (responseBody[@"status"][@"error_code"]) {
                
                self.vipUserMobel = nil;
                [self.tableView.header endRefreshing];
                UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"登录超时" message:@"登录超时，请您重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
               [aler show];
               return ;
                
            }
            
            self.vipUserMobel = [HCMVIPUserModel parseVIPUserDict:responseBody[@"data"]];
            
            [self.defaults setBool:[responseBody[@"status"][@"succeed"] boolValue] forKey:@"status"];
            [self.defaults synchronize];
            [self setUserInfo:self.vipUserMobel];
            
            [self.tableView.header endRefreshing];
            
            [self.tableView reloadData];
            
        } failureBlock:^(NSString *error) {
            
            [self.tableView.header endRefreshing];
            [SVProgressHUD showInfoWithStatus:@"网络有问题"];
            
        }];
        
    }else{
        [self.tableView.header endRefreshing];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"确定"]) {
        
        [self.defaults setBool:NO forKey:@"status"];
        [self.defaults setObject:nil forKey:@"userName"];
        [self.defaults removeObjectForKey:@"headimgurl"];
        
        [self.defaults removeObjectForKey:@"imgData"];
        
        [self.defaults removeObjectForKey:@"sid"];
        [self.defaults removeObjectForKey:@"uid"];
        [self.defaults removeObjectForKey:@"realName"];
        
        [self.defaults synchronize];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLoginOut" object:nil userInfo:nil];
        
        NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie*cookie in [cookieJar cookies]) {
            [cookieJar deleteCookie:cookie];
        }
        
        [self loginLogin];
        
    } else if([title isEqualToString:@"现在更新"]){
        
        HCMLog(@"点点点去下载");

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/hao-cai-mao/id1050857234"]];
        
       
    }

}

// 设置 tabbar 的badgeValue值
- (void)setUserInfo:(HCMVIPUserModel *)vipUserMobel
{
    
    if (![vipUserMobel.await_pay isEqualToString:@"0"]) {
        self.noPayItem.badgeValue = vipUserMobel.await_pay;
    }else{
        self.noPayItem.badgeValue = nil;
    }
    
    if (![vipUserMobel.await_ship isEqualToString:@"0"]) {
        self.noShipmentsItem.badgeValue = vipUserMobel.await_ship;
    }else{
        self.noShipmentsItem.badgeValue = nil;
    }
    
    if (![vipUserMobel.shipped isEqualToString:@"0"]) {
        self.noReceiveItem.badgeValue  = vipUserMobel.shipped;;
    }else{
        self.noReceiveItem.badgeValue = nil;
    }
    
    if (![vipUserMobel.finished isEqualToString:@"0"]) {
        self.ordeHistoryItme.badgeValue = vipUserMobel.finished;
    }else{
        self.ordeHistoryItme.badgeValue = nil;
    }
    
}

#pragma mark - navigationItemR

// 点击了设置
- (void)clickEdit
{
    
    HCMUserEditTableVC *UserEditVC = [[HCMUserEditTableVC alloc]initWithNibName:@"HCMUserEditTableVC" bundle:nil];
    
    [self.navigationController pushViewController:UserEditVC animated:YES];
    
}

#pragma mark - tableView protocol

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return 2;
    if (section == 2) {
        return 3;
    }else{
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return self.myOrderCell;
        }else{
            return self.waitingForDoingCell;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return self.myWalletCell;
        }else{
            return self.BalanceCell;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return self.addressCell;
        }else if(indexPath.row == 1){
          return self.partnerCell;
        }else{
            return self.HCMCentreCell;
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return self.AirlinesCell;
        }else{
            return self.HelpMeCell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self allList];
        }
        if (indexPath.row == 1) {
            [self orderHistory];
        }
        return;
    }
    
    if (indexPath.section == 1) {
        [self myWallet];
        return;
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self addressList];//收货管理地址
        }
        if (indexPath.row == 1) {
            [self PartnerCenter];//合伙人
        }
        if (indexPath.row == 2) {
            [self VIPCenter];//会员中心
        }
        return;
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            [self feedBack];//想提意见，找打囖
        }
        
        if (indexPath.row == 1) {
            [self userHelp];//帮助
        }
        return;
    }
    
}


#pragma mark 付款&发货&收货&订单
/**
 *  未付款
 */
- (void)notPaying
{
    
    if (!self.status) {
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        return;
    }
    //self.noPayItem.badgeValue = nil;
    HCMNonPaymentTableVC *nonPaymentVC = [[HCMNonPaymentTableVC alloc]initWithNibName:@"HCMNonPaymentTableVC" bundle:nil];
    [self.navigationController pushViewController:nonPaymentVC animated:YES];
}
/**
 *  等待发货
 */
- (void)waitForTheDelivery
{
    
    if (!self.status) {
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        return;
    }
    //self.ordeHistoryItme.badgeValue = nil;
    HCMWaitForTheDeliveryTableVC *waitForTheDeliveryVC = [[HCMWaitForTheDeliveryTableVC alloc]initWithNibName:@"HCMWaitForTheDeliveryTableVC" bundle:nil];
    [self.navigationController pushViewController:waitForTheDeliveryVC animated:YES];
}
/**
 *  未收货
 */
- (void)notReceiving
{
    
    if (!self.status) {
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        return;
    }
    //self.noReceiveItem.badgeValue = nil;
    HCMNotReceivingTableVC *notReceivingVC = [[HCMNotReceivingTableVC alloc]initWithNibName:@"HCMNotReceivingTableVC" bundle:nil];
    [self.navigationController pushViewController:notReceivingVC animated:YES];
    
}
/**
 *  全部订单
 */
- (void)allList
{
    
    if (!self.status) {
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        return;
    }
    //self.noShipmentsItem.badgeValue = nil;
    HCMAllListTableVC *orderHistoryVC = [[HCMAllListTableVC alloc]initWithNibName:@"HCMAllListTableVC" bundle:nil];
    [self.navigationController pushViewController:orderHistoryVC animated:YES];
    
    
}


/**
 *  已完成订单
 */
- (void)orderHistory
{
    
    if (!self.status) {
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        return;
    }
    //self.noShipmentsItem.badgeValue = nil;
    HCMOrderHistoryTableVC *orderHistoryVC = [[HCMOrderHistoryTableVC alloc]initWithNibName:@"HCMOrderHistoryTableVC" bundle:nil];
    [self.navigationController pushViewController:orderHistoryVC animated:YES];
    
}

#pragma mark 点击登录

- (IBAction)clickLogin:(UIButton *)sender
{
    
    [self loginLogin];
    
}

- (void)loginLogin
{
    self.userLogin = [[HCMVipLoginViewController alloc]initWithNibName:@"HCMVipLoginViewController" bundle:nil];
    
    [self.navigationController pushViewController:self.userLogin animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}
#pragma  mark - 点击更换头像

- (IBAction)setHeadImage:(UIButton *)sender
{
    
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - 点击了 我的收藏与收货地址管理
// 收货地址管理
- (void)addressList
{
    
    if (self.status) {
        
        self.userLocationVC = [[HCMUserLocationTableViewController  alloc]initWithNibName:@"HCMUserLocationTableViewController" bundle:nil];
        
        [self.navigationController pushViewController:self.userLocationVC animated:YES];
        
        return;
    }else{
        
        HCMVipLoginViewController *vipLoginVC = [[HCMVipLoginViewController alloc]initWithNibName:@"HCMVipLoginViewController" bundle:nil];
        
//        [self animationtype];//跳转动画
        
        [self.navigationController pushViewController:vipLoginVC animated:YES];
    }
}
//我的钱包
-(void)myWallet
{
    if (self.status) {
        
        HCMMyWalletTableViewController *mywallet = [[HCMMyWalletTableViewController alloc]initWithNibName:@"HCMMyWalletTableViewController" bundle:nil];
        
        [self.navigationController pushViewController:mywallet animated:YES];
        
        return;
    }else{
        
        HCMVipLoginViewController *vipLoginVC = [[HCMVipLoginViewController alloc]initWithNibName:@"HCMVipLoginViewController" bundle:nil];
        
//        [self animationtype];//跳转动画
        
        [self.navigationController pushViewController:vipLoginVC animated:YES];
    }
}
//合伙人中心
-(void)PartnerCenter
{
    if (self.status) {
        NSString * sid = [self.defaults objectForKey:@"sid"];
        NSString * uid = [self.defaults objectForKey:@"uid"];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        params[@"session"] = @{@"sid":sid,@"uid":uid};
        
        [[HomeNetwork sharedManager]postPartnerFormURL:params successBlock:^(id responseBody) {
            HCMLog(@"%@",responseBody);
            
            if (responseBody[@"status"][@"error_desc"]) {
                [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
                
                [self userGoLogin];
                
                return ;
            }
            
            NSString *str = [NSString stringWithFormat:@"%@",responseBody[@"data"][@"salesPartnerStatus"]];
            
            if ([str isEqualToString:@"0"]) {
                //未注册和合伙人 跳到申请界面
                HCMLog(@"未注册和合伙人");
                
                HCMPartnerInfoModel *partnerModel = [HCMPartnerInfoModel objectWithKeyValues:responseBody[@"data"][@"userProfile"]];
                
                PartnerViewController *partner = [[PartnerViewController alloc]initWithNibName:@"PartnerViewController" bundle:nil];
                
                partner.email = partnerModel.email;
                partner.mobilePhone = partnerModel.mobilePhone;
                partner.sex = [partnerModel.sex integerValue];
                
                [self.navigationController pushViewController:partner animated:YES];
            }else{
                //已注册合伙人 显示合伙人收益信息
                HCMLog(@"已注册合伙人");
                HCMPartnerCenterViewController *vc =[[HCMPartnerCenterViewController alloc]init];
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        } failureBlock:^(NSString *error) {
            HCMLog(@"合伙人失败");
            [SVProgressHUD showInfoWithStatus:@"请求失败"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
            
        }];
        return;
        
    }else{
        
        //这里是非登录状态(!_self.status)
        [SVProgressHUD showInfoWithStatus:@"客官,请先登录~"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [self userGoLogin];
    }

}

//会员俱乐部
-(void)VIPCenter
{
    if (self.status) {
        
        HCMVIPCenterViewController *vip = [[HCMVIPCenterViewController alloc]initWithNibName:@"HCMVIPCenterViewController" bundle:nil];
        
        vip.dic = self.dic;
        
        [self.navigationController pushViewController:vip animated:YES];
        
        return;
    }else{
        
        HCMVipLoginViewController *vipLoginVC = [[HCMVipLoginViewController alloc]initWithNibName:@"HCMVipLoginViewController" bundle:nil];
        
//        [self animationtype];//跳转动画
        
        [self.navigationController pushViewController:vipLoginVC animated:YES];
    }
}
//服务反馈
-(void)feedBack
{
    if (self.status) {
        
        HCMFeedBacksViewController *feedback = [[HCMFeedBacksViewController alloc]initWithNibName:@"HCMFeedBacksViewController" bundle:nil];
        
        [self.navigationController pushViewController:feedback animated:YES];
        
        return;
    }else{
        
        HCMVipLoginViewController *vipLoginVC = [[HCMVipLoginViewController alloc]initWithNibName:@"HCMVipLoginViewController" bundle:nil];
        
//        [self animationtype];//跳转动画
        
        [self.navigationController pushViewController:vipLoginVC animated:YES];
    }
}
//帮助
-(void)userHelp
{
    
    HCMHelpTableViewController *helpVC = [[HCMHelpTableViewController alloc]initWithNibName:@"HCMHelpTableViewController" bundle:nil];
    
    [self.navigationController pushViewController:helpVC animated:YES];
    
}

//我的收藏
- (IBAction)myCollection:(UIButton *)sender
{
    
    if (!self.status) {
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        return;
    }
    
    
    HCMLayoutEnshrine * layout = [[HCMLayoutEnshrine alloc]init];
    
    HCMUserEnshrineCollectionViewController *HCMUserEnshrineVC = [[HCMUserEnshrineCollectionViewController alloc]initWithCollectionViewLayout:layout];
    
    [self.navigationController pushViewController:HCMUserEnshrineVC animated:YES];
    
    
    
}
//浏览记录
- (IBAction)recentBrowse:(UIButton *)sender
{
    
    if (!self.status) {
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        return;
    }
    
    HCMRecentBrowseTableViewController *rbVC = [[HCMRecentBrowseTableViewController alloc]initWithNibName:@"HCMRecentBrowseTableViewController" bundle:nil];
    
    [self.navigationController pushViewController:rbVC animated:YES];
}
//关注的品牌
- (IBAction)hotGoods:(UIButton *)sender
{
    //接口地址http://www.haocaimao.com/ecmobile/index.php?url=user/hotBrand
    
    [SVProgressHUD showInfoWithStatus:@"活动暂时未开放！"];
//    HCMHotGoodsTableViewController *hotGoods = [[HCMHotGoodsTableViewController alloc]init];
//    [self.navigationController pushViewController:hotGoods animated:YES];
//    
//    
    
}

- (void)animationtype
{
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.75;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    //animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromTop;
    
    [self.view.window.layer addAnimation:animation forKey:nil];
    
}

#pragma mark - NSNotificationCenter
-(void)userLoginOut
{
    
    self.noPayItem.badgeValue = nil;
    self.noReceiveItem.badgeValue = nil;
    self.noShipmentsItem.badgeValue = nil;
    self.ordeHistoryItme.badgeValue = nil;
    self.vipUserMobel = nil;
    
    [self.tableView reloadData];
}

#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [self.userImg setImage:image];
    
    NSData *imgData = nil;
    
    if (UIImagePNGRepresentation(image) == nil) {
        
        imgData = UIImageJPEGRepresentation(image, 1);
        
    } else {
        
        imgData = UIImagePNGRepresentation(image);
    }
    
    [self.defaults setObject:imgData forKey:@"imgData"];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 用户登录
 */
-(void)userGoLogin
{
    HCMVipLoginViewController *vipLoginVC = [[HCMVipLoginViewController alloc]init];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController pushViewController:vipLoginVC animated:YES];
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//版本更新提醒
-(void)isUpdateAPP
{
    
    //当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    
    //上次的时间戳
    NSString *LastSecond = [self.defaults objectForKey:@"LastSecond"];

    if (!LastSecond) { //如果没有时间戳，把当前时间戳 存进去

        [self.defaults setObject:timeString forKey:@"LastSecond"];
        [self.defaults synchronize];
        
    }else{ //如果有时间戳,判断两个时间

                            // 当前时间戳                  上次时间戳
        NSInteger second = [timeString integerValue] - [LastSecond integerValue];
        
        if ( second > 3600* 24 * 3) { // second > 一小时(3600 * 24 * 7)
            //将当前的时间戳存到沙盒
            [self.defaults setObject:timeString forKey:@"LastSecond"];
            [self.defaults synchronize];
            
            //取出当前版本号
            NSString *key = @"CFBundleShortVersionString";
            
            //当前软件的版本号（从Info.plist中获得）
            NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
            HCMLog(@"%@",currentVersion);
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"system"] = @"ios";
            params[@"version"] = currentVersion;
            
            [[AddressNerworking sharedManager]postVersionCheckURL:params successBlock:^(id responseBody) {

                if ([responseBody[@"data"][@"latestVersion"] isEqualToString:@"0"]) {
                    
                    NSString *msg = [NSString stringWithFormat:@"好采猫APP已经更新到%@版本！\n立即下载",responseBody[@"data"][@"versionSN"]];
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"更新版本提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"现在更新", nil];
                    
                    [alert show];
                    
                }else{
                    HCMLog(@"APP是最新版拉！");
                }

            } failureBlock:^(NSString *error) {
                
                HCMLog(@"请求失败");
                [SVProgressHUD showInfoWithStatus:@"请求失败"];
                
            }];
        }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [self.tableView.header endRefreshing];
    
    
}

#pragma  mark - dealloc
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
