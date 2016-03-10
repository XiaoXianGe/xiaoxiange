//
//  EcmobileRegionVC.m
//  adderleDemo
//
//  Created by 好采猫 on 15/10/13.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "EcmobileRegionVC.h"

#import "RegionModel.h"

#import "AddressNerworking.h"

@interface EcmobileRegionVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSArray *provinces;
@property (nonatomic, strong)NSArray *citys;
@property (nonatomic, strong)NSArray *districts;

@property (nonatomic, strong)NSString *province;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *district;

@property (nonatomic, strong)NSString *provinceID;
@property (nonatomic, strong)NSString *cityID;
@property (nonatomic, strong)NSString *districtID;

@property (weak, nonatomic) IBOutlet UITableView *provinceTV;
@property (weak, nonatomic) IBOutlet UITableView *cityTV;
@property (weak, nonatomic) IBOutlet UITableView *districtTV;

@end

@implementation EcmobileRegionVC

static NSString *const provinceIdentifier = @"provinceIdentifier";
static NSString *const cityIdentifier = @"cityIdentifier";
static NSString *const districtIdentifier = @"districtIdentifier";

static NSString *const regionURL = @"http://www.haocaimao.com/ecmobile/?url=region";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"区域";
    
    [self.provinceTV registerClass:[UITableViewCell class] forCellReuseIdentifier:provinceIdentifier];
    [self.cityTV registerClass:[UITableViewCell class] forCellReuseIdentifier:cityIdentifier];
    [self.districtTV registerClass:[UITableViewCell class] forCellReuseIdentifier:districtIdentifier];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"nav-back" highImage:@"nav-back"];
    
    [self initRegionData];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)back{
     [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

// 初始化省数据
- (void)initRegionData{
    
    NSDictionary *dict = @{@"parent_id":@(1)};
    [SVProgressHUD show];
    [[AddressNerworking sharedManager]postRegionUrl:dict url:regionURL successBlock:^(id responseBody) {
        
        NSMutableArray *array = [NSMutableArray  array];
        
        for (NSDictionary *dicts in responseBody[@"data"][@"regions"]) {
            
            RegionModel *regionM = [RegionModel initRegionModelDict:dicts];
            [array addObject:regionM];
        }
        
        self.provinces = [array copy];
        [self.provinceTV reloadData];
        [SVProgressHUD showSuccessWithStatus:nil];
    } failureBlock:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:@"网络错误"];
    }];
    
}

#pragma mark - Table view data source
// 这里用了3个tableView  注意每个table 显示的数据不一样
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.provinceTV) {
        return [self.provinces count];
    }else if (tableView == self.cityTV){
        return [self.citys count];
    }else{
        return [self.districts  count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.provinceTV){
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:provinceIdentifier forIndexPath:indexPath];
    RegionModel *regionM = self.provinces[indexPath.row];
    cell.textLabel.text = regionM.name;
    
    return cell;
        
    }else if(tableView == self.cityTV){
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityIdentifier forIndexPath:indexPath];
    RegionModel *regionM = self.citys[indexPath.row];
    cell.textLabel.text = regionM.name;
    
    return cell;
        
    }else{
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:districtIdentifier forIndexPath:indexPath];
    RegionModel *regionM = self.districts[indexPath.row];
    cell.textLabel.text = regionM.name;
    
    return cell;
        
    }
}

#pragma  mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.provinceTV) {
        int leftRow = (int)[self.provinceTV indexPathForSelectedRow].row;
        RegionModel *regionM = self.provinces[leftRow];
        self.province = regionM.name;
        self.provinceID = regionM.ID;
        self.districts = nil;
        [self.districtTV reloadData];
        [self cityNetwork:regionM.ID];
    }
    
    if (tableView == self.cityTV) {
        
        int leftRow = (int)[self.cityTV indexPathForSelectedRow].row;
        RegionModel *regionM = self.citys[leftRow];
        self.city = regionM.name;
        self.cityID = regionM.ID;
        [self districtNetwork:regionM.ID];
    
    }
    
    if (tableView == self.districtTV) {
        
        RegionModel *district = self.districts[indexPath.row];
        
        NSString *img = [NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,district.name];
        NSString *imgID = [NSString stringWithFormat:@"%@ %@ %@",self.provinceID,self.cityID,district.ID];
        [self.delegate EcmobileRegionDidChanged:self withMessage:img andID:imgID];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
// 城市的网络请求
- (void)cityNetwork:(NSString *)parent{
    
    NSDictionary *dict = @{@"parent_id":parent};
     [SVProgressHUD show];
    [[AddressNerworking sharedManager]postRegionUrl:dict url:regionURL successBlock:^(id responseBody) {
        
        NSMutableArray *array = [NSMutableArray  array];
        
        for (NSDictionary *dicts in responseBody[@"data"][@"regions"]) {
            
            RegionModel *regionM = [RegionModel initRegionModelDict:dicts];
            [array addObject:regionM];
        }
        
        self.citys = [array copy];
        [self.cityTV reloadData];
        [SVProgressHUD showSuccessWithStatus:nil];
    } failureBlock:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:@"网络错误"];
    }];
    
}
// 市区的网络请求
- (void)districtNetwork:(NSString *)parent{
    
    NSDictionary *dict = @{@"parent_id":parent};
     [SVProgressHUD show];
    [[AddressNerworking sharedManager]postRegionUrl:dict url:regionURL successBlock:^(id responseBody) {
        
        NSMutableArray *array = [NSMutableArray  array];
        
        for (NSDictionary *dicts in responseBody[@"data"][@"regions"]) {
            
            RegionModel *regionM = [RegionModel initRegionModelDict:dicts];
            [array addObject:regionM];
            
        }
        [SVProgressHUD showSuccessWithStatus:nil];
        
        if ([responseBody[@"data"][@"more"] isEqual: @(0)]) {
            
            NSString *img = [NSString stringWithFormat:@"%@ %@",self.province,self.city];
            NSString *imgID = [NSString stringWithFormat:@"%@ %@",self.provinceID,self.cityID];
            [self.delegate EcmobileRegionDidChanged:self withMessage:img andID:imgID];
            [self.navigationController popViewControllerAnimated:YES];
        };
        
        self.districts = [array copy];
        [self.districtTV reloadData];
        
    } failureBlock:^(NSString *error) {
       [SVProgressHUD showInfoWithStatus:@"网络错误"];
    }];
    
}



@end







