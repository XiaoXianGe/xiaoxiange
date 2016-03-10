
//
//  HCMAddLocationTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/29.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//  添加一个收货地址

#import "HCMAddLocationTableViewController.h"
#import "HCMUserLocationTableViewController.h"
#import "EcmobileRegionVC.h"

#import "HCMVIPUserModel.h"

#import "AFNetworking.h"
#import "AddressNerworking.h"
@interface HCMAddLocationTableViewController ()<EcmobileRegionViewControllerDelegate>

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *locations;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *emali;
@property (weak, nonatomic) IBOutlet UITextField *postcode;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UITextField *address;

@property (strong, nonatomic)NSString *uid;
@property (strong, nonatomic)NSString *sid;

@property (strong, nonatomic)NSString *regionsID;
@end

@implementation HCMAddLocationTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.locationName =  @"请选择";
    
    self.title = @"编辑收货地址";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(addLocation) image:@"nav-complete" highImage:@"nav-complete"];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"nav-back" highImage:@"nav-back"];
    
    self.tableView.tableFooterView = self.footView;
    
    self.tableView.tableFooterView.hidden = YES;
    
    if (self.adderssID) {
        
        [self networking];
    }
} 
// 网络请求
- (void)networking{
    
        NSUserDefaults *defaults = [NSUserDefaults  standardUserDefaults];
        
        self.uid = [defaults objectForKey:@"uid"];
        self.sid = [defaults objectForKey:@"sid"];
        
        NSDictionary *dict = @{@"session":@{@"uid":self.uid,@"sid":self.sid},@"address_id":self.adderssID};
    
        [SVProgressHUD show];
    
        [[AddressNerworking sharedManager]postAddressInfo:dict successBlock:^(id responseBody) {
        
            [SVProgressHUD dismiss];
            
            if (responseBody[@"status"][@"error_code"]) {
                
                [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
                return ;
            }
            
            self.name.text = responseBody[@"data"][@"consignee"];
            self.phone.text = responseBody[@"data"][@"tel"];
            self.emali.text = responseBody[@"data"][@"email"];
            self.address.text = responseBody[@"data"][@"address"];
            self.postcode.text = responseBody[@"data"][@"zipcode"];
            
            NSString *str = [NSString stringWithFormat:@"%@ %@ %@",responseBody[@"data"][@"province_name"],responseBody[@"data"][@"city_name"],responseBody[@"data"][@"district_name"]];
            
            self.regionsID = [NSString stringWithFormat:@"%@ %@ %@",responseBody[@"data"][@"province"],responseBody[@"data"][@"city"],responseBody[@"data"][@"district"]];
            
            self.location.text = self.locationName = str;
            [SVProgressHUD showSuccessWithStatus:nil];
            [self.tableView reloadData];
            
        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:@"网络错误"];
            
        }];
        
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

#pragma  mark - navigationItem L&R

-(void)back{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 添加收货地址 各种判断必要条件不能为空
- (void)addLocation{
    
    if ([self.name.text length] < 2 && [self.address.text length] < 2) {
        
        [SVProgressHUD showInfoWithStatus:@"必填项，不能为空"];
        return;
    }
    
    if ([self.phone.text length] < 8) {
        
        [SVProgressHUD showInfoWithStatus:@"电话号码过短"];
        return;
    }

    if ( self.emali.text.length < 6  ||  ![self.emali.text hasSuffix:@".com"]  ) {//
        
        [SVProgressHUD showInfoWithStatus:@"邮箱格式不正确"];
        return;
    }
    
    if ([self.locationName isEqualToString:@"请选择"]) {
        
        [SVProgressHUD showInfoWithStatus:@"请选择省市区"];
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults  standardUserDefaults];
    self.uid = [defaults objectForKey:@"uid"];
    self.sid = [defaults objectForKey:@"sid"];
    
    NSArray *stringsID = [self.regionsID componentsSeparatedByString:@" "];
    
    NSString *provinceID = @"";
    NSString *cityLeveID = @"";
    NSString *cityID = @"";
    
    if ([stringsID count] == 3) {
        provinceID = stringsID[0];
        cityLeveID = stringsID[1];
        cityID = stringsID[2];
    }else {
        provinceID = stringsID[0];
        cityLeveID = stringsID[1];
    }
    
    // 判断点击时 地址ID 是否有值 来做出不同的事件
    if (!self.adderssID) {
        
    // 添加新的地址
    NSDictionary *dict = @{@"session":@{@"sid":self.sid,@"uid":self.uid}
                           ,@"address":@{@"country":@1,
                                         @"province":provinceID,
                                         @"city":cityLeveID,
                                         @"district":cityID,
                                         @"consignee":self.name.text,
                                         @"email":self.emali.text,
                                         @"tel":self.phone.text,
                                         @"address":self.address.text,
                                         @"zipcode":self.postcode.text}};
        [SVProgressHUD show];
    [[AddressNerworking sharedManager]postAddressAdd:dict successBlock:^(id responseBody) {
        if (responseBody[@"status"][@"error_code"]) {
            
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
        
        [SVProgressHUD showSuccessWithStatus:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:@"网络错误"];
    }];
        return;
        
    }else{
        
        NSArray *strArray = [self.locationName componentsSeparatedByString:@" "];

        NSString *province_name = nil;
        NSString *city_name = nil;
        NSString *district_name = nil;
        
        if ([strArray count] == 3) {
            province_name = strArray[0];
            city_name = strArray[1];
            district_name = strArray[2];
        }else {
            province_name = strArray[0];
            city_name = strArray[1];
        }
                
        // 修改原有的地址
        NSDictionary *updataDict = @{@"address_id":self.adderssID,
                                     @"session":@{@"sid":self.sid,@"uid":self.uid},
                                     @"address":@{
                                             @"id":self.adderssID,
                                             @"consignee":self.name.text,
                                             @"country":@"1",
                                             @"province":provinceID,
                                             @"city":cityLeveID,
                                             @"district":cityID,
                                             @"tel":self.phone.text,
                                             @"address":self.address.text,
                                             @"zipcode":self.postcode.text,
                                             @"email":self.emali.text,
                                             @"country_name":@"中国",
                                             @"province_name":province_name,
                                             @"city_name":city_name,
                                             @"district_name":district_name}};
        [SVProgressHUD show];
        [[AddressNerworking sharedManager]postAddressUpData:updataDict successBlock:^(id responseBody) {
            
            if (responseBody[@"status"][@"error_code"]) {
                
                [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
                return ;
            }
            
            [SVProgressHUD showSuccessWithStatus:nil];
        } failureBlock:^(NSString *error) {
            [SVProgressHUD showInfoWithStatus:@"网络错误"];
           
        }];
    }
}

#pragma mark - 选择地址
- (IBAction)selectArea:(UIButton *)sender {
    
    EcmobileRegionVC *ERVC = [[EcmobileRegionVC alloc]initWithNibName:@"EcmobileRegionVC" bundle:nil];
    ERVC.delegate = self;
    [self.navigationController pushViewController:ERVC animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = self.locations[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 4) {
        self.location.text = self.locationName;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 20;
}

#pragma mark - 尾部事件 
// 删除地址
- (IBAction)DeleteAddress:(UIButton *)sender {
    
    NSDictionary *dict = @{@"session":@{@"sid":self.sid,@"uid":self.uid},
                           @"address_id":self.adderssID};
    [SVProgressHUD show];
    [[AddressNerworking sharedManager]postAddressDelete:dict successBlock:^(id responseBody) {
        if (responseBody[@"status"][@"error_code"]) {
            
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:@"网络错误"];
    }];
    
}

// 设置为默认
- (IBAction)tolerant:(UIButton *)sender {
    
    NSDictionary *dict = @{@"session":@{@"sid":self.sid,@"uid":self.uid},
                           @"address_id":self.adderssID};
    [SVProgressHUD show];
    [[AddressNerworking sharedManager]postAddressSetDefault:dict successBlock:^(id responseBody) {
       
        if (responseBody[@"status"][@"error_code"]) {
            
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:@"网络错误"];
    }];
    
}

#pragma mark - 键盘退下
- (IBAction)TextField_DidEndOnExit:(UITextField *)sender {
    
    [sender resignFirstResponder];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

#pragma mark -  EcmobileRegionDelegate
// 选择省市区 的 协议 
-(void)EcmobileRegionDidChanged:(EcmobileRegionVC *)ecmobileRegionVC withMessage:(NSString *)msg andID:(NSString *)msgID{
    self.locationName = msg;
    self.regionsID = msgID;
    [self.tableView reloadData];
}

@end





