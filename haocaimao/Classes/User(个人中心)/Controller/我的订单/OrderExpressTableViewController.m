//
//  OrderExpressTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 16/6/7.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import "OrderExpressTableViewController.h"
#import "MJExtension.h"
#import "OrderExpressCell.h"

@interface OrderExpressTableViewController ()

@end

@implementation OrderExpressTableViewController

static NSString *const orderExpressID = @"orderExpressCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"物流信息";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderExpressCell class]) bundle:nil] forCellReuseIdentifier:orderExpressID];
    
//自动计算高度，ios8之后才可以使用
//    self.tableView.estimatedRowHeight = 60;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.backgroundColor = HCMColor(239, 239, 244, 1.0);
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    _array = [OrderExpressModel objectArrayWithKeyValuesArray:_dict[@"content"]];
    
    //创建头部视图
    [self setUpHeardView];
    
    [SVProgressHUD dismiss];
    
}

//创建头部视图
-(void)setUpHeardView{
    
    UIView * hearderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HCMScreenWidth, 60)];
    UILabel * shipping_name = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, HCMScreenWidth, 18)];
    UILabel * invoice_no = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, HCMScreenWidth, 18)];
    UIView * hearderLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 52, HCMScreenWidth,8)];
    
    shipping_name.text = [NSString stringWithFormat:@"承运来源:%@",_dict[@"shipping_name"]];
    invoice_no.text = [NSString stringWithFormat:@"运单编号:%@",_dict[@"invoice_no"]];
    [shipping_name setFont:[UIFont systemFontOfSize:16]];
    [invoice_no setFont:[UIFont systemFontOfSize:16]];
    [shipping_name setTextColor:HCMColor(99, 99, 99, 1.0)];
    [invoice_no setTextColor:HCMColor(99, 99, 99, 1.0)];
    
    hearderView.backgroundColor = [UIColor whiteColor];
    hearderLineView.backgroundColor = HCMColor(239, 239, 244, 1.0);
    [hearderView addSubview:shipping_name];
    [hearderView addSubview:invoice_no];
    [hearderView addSubview:hearderLineView];
    
    self.tableView.tableHeaderView = hearderView;
}

-(void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    OrderExpressCell *cell = [tableView dequeueReusableCellWithIdentifier:orderExpressID];
    
    OrderExpressModel *model = [OrderExpressModel objectWithKeyValues:_array[indexPath.row]];
    
    cell.contextLabel.text = model.context;
    cell.timeLabel.text = model.time;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderExpressModel *model = [OrderExpressModel objectWithKeyValues:_array[indexPath.row]];
    HCMLog(@"%f",model.cellH);
    return model.cellH;
}


@end
