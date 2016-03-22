//
//  HCMAllListTableVC.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/22.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMAllListTableVC.h"

#import "HCMPayOrderWebViewVC.h"
#import "HCMNonPaymentCell.h"
#import "HCMNoPayFooterview.h"
#import "HCMNoPayHeadview.h"

#import "AddressNerworking.h"

#import "OrderListModel.h"
#import "GoodsListModel.h"
#import "DealViewController.h"

@interface HCMAllListTableVC ()

@property (strong, nonatomic) UIImageView *noDataView;

@property (strong, nonatomic)NSMutableArray *SectionsCount;
@property (strong, nonatomic)NSMutableArray *numberOfRowsInSection;

@property (nonatomic, strong)NSString *sid;
@property (nonatomic, strong)NSString *uid;

@property (nonatomic, strong)NSUserDefaults *defaults;
@end

@implementation HCMAllListTableVC

{
    int _page;
    int _initCount;
}

static NSString * const reuseIdentifier = @"MyCell";
static NSString * const headerReuseIdentifier = @"TableViewSectionHeaderViewIdentifier";
static NSString * const footerReuseIdentifier = @"TableViewSectionFooterViewIdentifier";

- (UIImageView *)noDataView{
    if (!_noDataView) {
        UIImageView * noDataView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"no-plist"]];
        noDataView.centerX = HCMScreenWidth/2;
        [self.view addSubview:noDataView];
        _noDataView = noDataView;
    }
    return _noDataView;
}

-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults  standardUserDefaults];
    }
    return _defaults;
}

- (NSMutableArray *)SectionsCount{
    if (!_SectionsCount) {
        _SectionsCount = [NSMutableArray array];
    }
    return _SectionsCount;
}

- (NSMutableArray *)numberOfRowsInSection{
    
    if (!_numberOfRowsInSection) {
        _numberOfRowsInSection = [NSMutableArray array];
    }
    return _numberOfRowsInSection;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"全部订单";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HCMNonPaymentCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerReuseIdentifier];
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:footerReuseIdentifier];
    
     self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(theDropdownLoadMore)];
    
    [self.tableView.header beginRefreshing];
    
}

- (void)theDropdownLoadMore{
    
    [self.SectionsCount removeAllObjects];
    [self.numberOfRowsInSection removeAllObjects];
    _page = 1;
    [self.tableView reloadData];
    
    [self networking];
}

- (void)networking{
    
    self.defaults = [NSUserDefaults  standardUserDefaults];
    self.uid = [self.defaults objectForKey:@"uid"];
    self.sid = [self.defaults objectForKey:@"sid"];
    
    NSDictionary *dict = @{@"session":@{@"uid":self.uid,@"sid":self.sid},
                           @"type":@"all_list",
                           @"pagination":@{@"count":@20,@"page":@(_page)}};
    //all_list
    [[AddressNerworking sharedManager]postOrderList:dict successBlock:^(id responseBody) {
        
        self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(toLoadMoreData)];
        
        if (responseBody[@"status"][@"error_code"]) {
            
            [self.tableView.header endRefreshing];
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            [self.tableView reloadData];
            
            return ;
        }
        NSMutableArray *dictsArray = [NSMutableArray array];
        NSMutableArray *goodListArrays = [NSMutableArray array];
        
        for (NSDictionary *dicts in responseBody[@"data"]) {
            OrderListModel *orderList = [OrderListModel parseOrderListDict:dicts];
            
            [dictsArray addObject:orderList];
            
            NSMutableArray *goodArrays = [NSMutableArray array];
            
            for (NSDictionary *goodsDict in dicts[@"goods_list"]) {
                
                GoodsListModel *goodlist = [GoodsListModel parseGoodsListDict:goodsDict];
                
                [goodArrays addObject:goodlist];
                
            }
            
            [goodListArrays addObject:goodArrays];
        }
        if (goodListArrays.count < 20) {
            [self.tableView.footer setHidden:YES];
        }
        _page += 1;
        _initCount = [responseBody[@"paginated"][@"total"] intValue];
        
        [self.numberOfRowsInSection addObjectsFromArray:goodListArrays];
        [self.SectionsCount addObjectsFromArray:dictsArray];
        
        [self.tableView.header  endRefreshing];
        [self.tableView.footer endRefreshing];
        
        [SVProgressHUD showSuccessWithStatus:nil];
        [self.tableView reloadData];
        
    } failureBlock:^(NSString *error) {
        
        [self.tableView.header  endRefreshing];
        [self.tableView.footer endRefreshing];
        
        [SVProgressHUD showInfoWithStatus:@"网络有问题"];
        
    }];
    
}

- (void)toLoadMoreData{
    
    if ([self.SectionsCount count] == _initCount) {
        
        [SVProgressHUD showSuccessWithStatus:@"没有更多数据"];
        [self.tableView.footer endRefreshing];
        return;
    }
    
    [self networking];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)clickBack
{   [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([self.SectionsCount count] == 0) {
        self.noDataView.hidden = NO;
        [self.tableView.footer endRefreshing];

        
    }else{
        self.noDataView.hidden = YES;
    }
    
    return [self.SectionsCount count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.numberOfRowsInSection[section] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HCMNonPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    GoodsListModel *goodslist = self.numberOfRowsInSection[indexPath.section][indexPath.row];
    
    cell.goodsName.text = goodslist.name;
    cell.goodsNumber.text = [NSString stringWithFormat:@"× %@",goodslist.goods_number];
    cell.shopPrice.text = [NSString stringWithFormat:@"价格:%@",goodslist.formated_shop_price];
    cell.shopPrice.font = [UIFont systemFontOfSize:12];
    
    if ([goodslist.imgSmall isKindOfClass:[NSArray class]]) {
        [cell.goodsImg setImage:[UIImage imageNamed:@"placeholder-image"]];
    }else{
    
    [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:goodslist.imgSmall] placeholderImage:[UIImage imageNamed:@"placeholder-image"]];
    
    }
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = cell.bounds;
    btn.tag = [goodslist.goods_id integerValue];
    [btn addTarget:self action:@selector(clickCell:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
    
    return cell;
}

-(void)clickCell:(UIButton *)goodsID{
    DealViewController *dealVC = [[DealViewController alloc]initWithNibName:@"DealViewController" bundle:nil];
    dealVC.goods_id = [NSString stringWithFormat:@"%lu",(long)goodsID.tag];
    [self.navigationController pushViewController:dealVC animated:YES];
    
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuseIdentifier];
    OrderListModel *orderList = self.SectionsCount[section];
    
    UIView *headView = (UIView *)[myHeader.contentView viewWithTag:66];
    UILabel *snlabel = (UILabel *)[headView viewWithTag:67];
    UILabel *timelabel = (UILabel *)[headView viewWithTag:68];
    UILabel *head_orderID = (UILabel *)[headView viewWithTag:69];
    
    snlabel.text = [NSString stringWithFormat:@"订单编号 %@",orderList.order_sn];
    timelabel.text = [NSString stringWithFormat:@"订单编号 %@",orderList.order_time];
    head_orderID.text = orderList.order_id;
    
    
    if (headView == nil) {
        
        HCMNoPayHeadview *headview = [[HCMNoPayHeadview alloc]initWithNibName:@"HCMNoPayHeadview" bundle:nil];
        
        CGRect snRECT = CGRectMake(15, 8, 200, 15);
        CGRect timeRECT = CGRectMake(15, 23, 280, 15);
        
        UILabel *SNLabel = [self setLabelsRect:snRECT textAlignment:YES];
        SNLabel.text = [NSString stringWithFormat:@"订单编号 %@",orderList.order_sn];
        SNLabel.font = [UIFont systemFontOfSize:11];
        
        SNLabel.tag = 67;
        
        UILabel *timeLabel = [self setLabelsRect:timeRECT textAlignment:YES];
        timeLabel.text = [NSString stringWithFormat:@"成交时间 %@",orderList.order_time];
        timeLabel.tag = 68;
        timeLabel.font = [UIFont systemFontOfSize:11];
        
        UILabel *head_orderID = [self setLabelsRect:CGRectMake(0, 0, 0, 0) textAlignment:YES];
        head_orderID.tag = 69;
        head_orderID.textColor = [UIColor redColor];
        head_orderID.text = orderList.order_id;
        
        //订单详情btn
        UIButton *orderInfoBtn = [self setButtonRect:CGRectMake(240 , 13, 60, 20) bgImage:@"button-narrow-gray" title:@"订单详情"];
        [orderInfoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [orderInfoBtn addTarget:self action:@selector(orderInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        headView = headview.view;
        headView.tag = 66;
        
        [headview.view addSubview:head_orderID];
        [headview.view addSubview:orderInfoBtn];
        [headview.view addSubview:timeLabel];
        [headview.view addSubview:SNLabel];
        [myHeader.contentView addSubview:headView];
        
    }
    
    return myHeader;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView  *myFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerReuseIdentifier];
    OrderListModel *orderList = self.SectionsCount[section];
    
    UIView *footer = (UIView *)[myFooter.contentView viewWithTag:80];
    UILabel *totalLabel = (UILabel *)[footer viewWithTag:81];
    
    totalLabel.text = orderList.total_fee;
    
    if (footer == nil) {
        
        HCMNoPayFooterview *footerView = [[HCMNoPayFooterview alloc]initWithNibName:@"HCMNoPayFooterview" bundle:nil];
        
        UILabel *total_fee_label = [self setLabelsRect:CGRectMake(60, 10, 110, 20) textAlignment:YES];
        total_fee_label.tag = 81;
        total_fee_label.textColor = [UIColor redColor];
        total_fee_label.text = orderList.total_fee;
        
        
        
        footer = footerView.view;
        footer.tag = 80;
        
        [footer addSubview:total_fee_label];//总价格
        
        [myFooter.contentView addSubview:footer];
    }
    return myFooter;
}


//完成图
-(UIImageView *)setImageView:(CGRect )rectF bgImage:(NSString *)bgImage{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rectF];
    
    [imageView setImage:[UIImage imageNamed:@"yingzhang"]];
    
    return imageView;
    
}
// 点击订单详情
-(void)orderInfo:(UIButton *)btn{
    
    HCMLogFunc;
    
    
    
    
}
// 抽取代码 设置btn
- (UIButton *)setButtonRect:(CGRect )rectF bgImage:(NSString *)bgImage title:(NSString *)title{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:rectF];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [btn setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    return btn;
}
- (UILabel *)setLabelsRect:(CGRect )rectF textAlignment:(BOOL )isAlignment{
    
    UILabel *label = [[UILabel alloc]initWithFrame:rectF];
    
    label.font = [UIFont systemFontOfSize:14];
    
    label.textAlignment = isAlignment ? NSTextAlignmentLeft : NSTextAlignmentRight;
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
@end

