//
//  HCMUserLocationTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/29.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//  收货地址管理

#import "HCMUserLocationTableViewController.h"
#import "HCMUserLocationTableViewControllerTableViewCell.h"
#import "HCMAddLocationTableViewController.h"

#import "AddressModel.h"

#import "AddressNerworking.h"
@interface HCMUserLocationTableViewController ()

@property (strong, nonatomic)HCMAddLocationTableViewController *HCMAddLocationVC;

@property (strong, nonatomic)NSArray *adderssArrays;

@property (strong, nonatomic)NSUserDefaults *defaults;

@end

@implementation HCMUserLocationTableViewController

-(NSUserDefaults *)defaults{
    
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HCMUserLocationTableViewControllerTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.title = @"收货地址管理";
    
    [self setBackgroundImage];
    
    [self setnavigationItemLR];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self network];
    
}

- (void)network{
        
    NSString *uid = [self.defaults objectForKey:@"uid"];
    NSString *sid = [self.defaults objectForKey:@"sid"];
    
    NSDictionary *mutabDitc = @{@"session":@{@"uid":uid,@"sid":sid}};
    [SVProgressHUD show];
    [[AddressNerworking sharedManager]postaddresslist:mutabDitc successBlock:^(id responseBody) {
        
        HCMLog(@"收货地址管理%@",responseBody);
                
        if (responseBody[@"status"][@"error_code"]) {
            
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
        
        [SVProgressHUD showSuccessWithStatus:nil];
        
        NSMutableArray *mutabArray = [NSMutableArray array];
        
        for (NSDictionary *dict in responseBody[@"data"]) {
            AddressModel *address = [AddressModel parseAddressData:dict];
            [mutabArray addObject:address];
        }
                
        self.adderssArrays = mutabArray;
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:@"网络错误"];
        
    }];
}

#pragma mark -navigationItem right&left

- (void)setnavigationItemLR{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(edit) image:@"nav-add" highImage:@"nav-add"];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"nav-back" highImage:@"nav-back"];
    
}

- (void)edit{
    
    self.HCMAddLocationVC = [[HCMAddLocationTableViewController alloc]initWithNibName:@"HCMAddLocationTableViewController" bundle:nil];
    
    [self.navigationController pushViewController:self.HCMAddLocationVC animated:YES];
}

- (void)back{
    
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - cgimage
- (void)setBackgroundImage{
    UIImageView * imageBg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    
    imageBg.image = [UIImage imageNamed:@"searcher-no-result-empty-icon"];
    imageBg.contentMode = UIViewContentModeScaleAspectFit;
    imageBg.hidden = YES;
    [self.tableView setBackgroundView:imageBg];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.adderssArrays count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HCMUserLocationTableViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AddressModel *address = self.adderssArrays[indexPath.row];
    
    cell.userName.text = address.consignee;
#warning 预留了电话的接口
    //cell.name.text = @"预留电话接口...";
    
    NSString *str = [NSString stringWithFormat:@"%@ %@ %@",address.province_name,address.city_name,address.district_name];
    
    cell.addresseLabel.text = address.address;
    
    cell.location.text = str;
    
    cell.click.hidden = ![address.default_address intValue];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    AddressModel *address = self.adderssArrays[indexPath.row];

    self.HCMAddLocationVC = [[HCMAddLocationTableViewController alloc]initWithNibName:@"HCMAddLocationTableViewController" bundle:nil];
    
    self.HCMAddLocationVC.adderssID = address.ID;
    
    self.HCMAddLocationVC.tableView.tableFooterView.hidden = NO;
    [self.navigationController pushViewController:self.HCMAddLocationVC animated:YES];
    
}

@end
