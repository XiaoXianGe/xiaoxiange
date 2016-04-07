//
//  HCMMyWalletTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/11.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMMyWalletTableViewController.h"
#import "AddressNerworking.h"
#import "HCMTakeMoneyTableViewController.h"
#import "HCMHongBaoTableViewController.h"

@interface HCMMyWalletTableViewController ()
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *userCellArr;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *youHuiJuan;
@property (weak, nonatomic) IBOutlet UILabel *MaoDou;

@property (strong, nonatomic)NSUserDefaults *defaults;
@property (assign, nonatomic)BOOL status;



@property(strong,nonatomic)NSDictionary *dic;

@end


@implementation HCMMyWalletTableViewController

-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

-(NSDictionary *)dic{
    if (!_dic) {
        _dic = [NSDictionary dictionary];
    }
    return _dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的钱包";
    
    self.tableView.backgroundColor = HCMColor(238, 238, 238,1);
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getInfomationForMyWallet];
    
}

-(void)getInfomationForMyWallet{

    self.status = [self.defaults boolForKey:@"status"];

    if (self.status) {
  
        NSString *sid = [self.defaults objectForKey:@"sid"];
        NSString *uid = [self.defaults objectForKey:@"uid"];
        
        NSDictionary *dict = @{@"session":@{@"sid":sid,@"uid":uid}};
        
        [[AddressNerworking sharedManager]postMyWallet:dict successBlock:^(id responseBody) {
           
            
            if (responseBody[@"status"][@"error_code"]) {
                [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
                return ;
            }
            
            self.dic = responseBody;
            self.MaoDou.text =  [NSString stringWithFormat:@"%@ 豆",[responseBody[@"data"][@"point"] description]];
            
            self.money.text =[NSString stringWithFormat:@"%@ 元",[responseBody[@"data"][@"money"] description]];
            self.youHuiJuan.text = [NSString stringWithFormat:@"%@ 券",[responseBody[@"data"][@"coupon"] description]];
            
        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:error];
            
        }];
        
    }
    
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.userCellArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.userCellArr[indexPath.row];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        HCMTakeMoneyTableViewController *moneyVC = [[HCMTakeMoneyTableViewController alloc]initWithNibName:@"HCMTakeMoneyTableViewController" bundle:nil];
        [self.navigationController pushViewController:moneyVC animated:YES];
        [SVProgressHUD showWithStatus:@"加载中"];
    }
    if(indexPath.row == 1){
        HCMHongBaoTableViewController *hongbaoVC = [[HCMHongBaoTableViewController alloc]initWithNibName:@"HCMHongBaoTableViewController" bundle:nil];
        [self.navigationController pushViewController:hongbaoVC animated:YES];
        [SVProgressHUD showWithStatus:@"加载中"];
    }
}

@end
