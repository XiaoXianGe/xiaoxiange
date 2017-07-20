//
//  HCMSaleGoodsTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/13.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMSaleGoodsTableViewController.h"
#import "HCMSaleGoodsTableViewCell.h"
#import "HomeNetwork.h"
#import "SDCycleScrollView.h"
#import "HomeTopGoodsModel.h"

@interface HCMSaleGoodsTableViewController ()<SDCycleScrollViewDelegate>

@end

@implementation HCMSaleGoodsTableViewController

static NSString *const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HCMSaleGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    self.title = @"特价商品";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    
    
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

//
//-(void)sendHomeAdvertisementRequest{
//    
//    [[HomeNetwork sharedManager]postHomeAdvertisement:nil successBlock:^(id responseBody) {
//        
//        [self updateAdvertisingOfDic:responseBody];
//        
//    } failureBlock:^(NSString *error) {
//        
//        [SVProgressHUD showInfoWithStatus:error];
//    }];
//    
//}
//
//
////头部广告
//-(void)updateAdvertisingOfDic:(NSDictionary *)dict{
//    
//    CGRect frame = [[UIScreen mainScreen]bounds];
//    
//    UIView *testView = [[UIView alloc]init];
//    testView.frame = CGRectMake(0, 0, frame.size.width, 150);
//    
//    NSDictionary *dic = [HomeTopGoodsModel NewsWithJSON:dict];
//    NSArray * imageArray = dic[@"small"];
//   // self.receiveGoodsIDArray = dic[@"goods_id"];
//    
//    
//    
//    //网络加载 --- 创建带标题的图片轮播器
//    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, frame.size.width, 150) imageURLStringsGroup:imageArray]; // 模拟网络延时情景
//    
//    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//    cycleScrollView.delegate = self;
//    
//    cycleScrollView.placeholderImage = [UIImage imageNamed:@"Placeholder_ Advertise"];
//    
//    [testView addSubview:cycleScrollView];
//    self.tableView.tableHeaderView = testView;
//}
//
//


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCMSaleGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
}

@end
