//
//  HCMNonPaymentTableVC.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/8.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//  未付款  待发货 待收货  历史订单 均出自同一个模型

#import "HCMNonPaymentTableVC.h"

#import "HCMPayOrderWebViewVC.h"
#import "HCMNonPaymentCell.h"
#import "HCMNoPayFooterview.h"
#import "HCMNoPayHeadview.h"

#import "AddressNerworking.h"
#import "MBProgressHUD+MJ.h"

#import "OrderListModel.h"
#import "GoodsListModel.h"

#import "DealViewController.h"
#import "WeChatPayModel.h"

@interface HCMNonPaymentTableVC ()<WXApiDelegate>

@property (strong, nonatomic)NSMutableArray *SectionsCount;
@property (strong, nonatomic)NSMutableArray *numberOfRowsInSection;

@property (nonatomic, strong)NSString *sid;
@property (nonatomic, strong)NSString *uid;

@property (nonatomic, strong)NSUserDefaults *defaults;
@property (strong, nonatomic)UIImageView *noDataView;
@property (strong ,nonatomic)OrderListModel * orderList;

@end

@implementation HCMNonPaymentTableVC
{
    int _page;
    int _initCount;
}
-(OrderListModel *)orderList{
    if (!_orderList) {
        _orderList = [[OrderListModel alloc]init];
    }
    return _orderList;
}

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
        _defaults = [NSUserDefaults standardUserDefaults];
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

static NSString * const reuseIdentifier = @"MyCell";

static NSString * const headerReuseIdentifier = @"TableViewSectionHeaderViewIdentifier";

static NSString * const footerReuseIdentifier = @"TableViewSectionFooterViewIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"待付款";
        
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HCMNonPaymentCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerReuseIdentifier];
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:footerReuseIdentifier];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(theDropdownLoadMore)];
   
    [self.tableView.header beginRefreshing];
    
   
    
}

-(void)WX_PayInfo{
     [self.tableView.header beginRefreshing];
}

// 上啦刷新
- (void)theDropdownLoadMore{
    
    [self.SectionsCount removeAllObjects];
    [self.numberOfRowsInSection removeAllObjects];
    
    _page = 1;
    
    [self.tableView reloadData];
    [self networking];
}

// 网络请求
- (void)networking{
    
    self.defaults = [NSUserDefaults  standardUserDefaults];
    self.uid = [self.defaults objectForKey:@"uid"];
    self.sid = [self.defaults objectForKey:@"sid"];
    
    NSDictionary *dict = @{@"session":@{@"uid":self.uid,@"sid":self.sid},
                           @"type":@"await_pay",
                           @"pagination":@{@"count":@20,@"page":@(_page)}};
    
    [[AddressNerworking sharedManager]postOrderList:dict successBlock:^(id responseBody) {
        
//        HCMLog(@"....%@",responseBody);
        
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
            
            
            self.orderList = [OrderListModel parseOrderListDict:dicts];
            
            [dictsArray addObject:self.orderList];
            
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

// 下拉刷新
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
    
    [self.tableView.header beginRefreshing];
    
    //接收支付成功的通知
    [HCMNSNotificationCenter addObserver:self selector:@selector(WX_PayInfo) name:@"WX_PaySuccess" object:nil];
    //接收支付失败的通知
    [HCMNSNotificationCenter addObserver:self selector:@selector(WX_PayInfo) name:@"WX_PayFailure" object:nil];
}

- (void)clickBack

{   [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([self.SectionsCount count] == 0) {
        self.noDataView.hidden = NO;
        //[self.tableView.header endRefreshing];
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
    cell.shopPrice.text = goodslist.formated_shop_price;
    
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

// 头视图复用代码
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuseIdentifier];
    OrderListModel *orderList = self.SectionsCount[section];

    UIView *headView = (UIView *)[myHeader.contentView viewWithTag:66];
    UILabel *snlabel = (UILabel *)[headView viewWithTag:67];
    UILabel *timelabel = (UILabel *)[headView viewWithTag:68];
    UILabel *waitlabel = (UILabel *)[headView viewWithTag:69];
    
    waitlabel.text = [NSString stringWithFormat:@"等待付款"];
    snlabel.text = [NSString stringWithFormat:@"订单编号 %@",orderList.order_sn];
    timelabel.text = [NSString stringWithFormat:@"成交时间 %@",orderList.order_time];

    if (headView == nil) {
        
        HCMNoPayHeadview *headview = [[HCMNoPayHeadview alloc]initWithNibName:@"HCMNoPayHeadview" bundle:nil];
        
        CGRect snRECT = CGRectMake(15, 20, 200, 15);
        CGRect timeRECT = CGRectMake(15, 40, 280, 15);
        CGRect waitRECT = CGRectMake(250, 20, 200, 15);
        
        UILabel *waitlabel = [self setLabelsRect:waitRECT textAlignment:YES];
        waitlabel.text = [NSString stringWithFormat:@"等待付款"];
        waitlabel.tag = 69;
        
        UILabel *SNLabel = [self setLabelsRect:snRECT textAlignment:YES];
        SNLabel.text = [NSString stringWithFormat:@"订单编号 %@",orderList.order_sn];
        SNLabel.tag = 67;
        
        UILabel *timeLabel = [self setLabelsRect:timeRECT textAlignment:YES];
        timeLabel.text = [NSString stringWithFormat:@"成交时间 %@",orderList.order_time];
        timeLabel.tag = 68;
        
        headView = headview.view;
        headView.tag = 66;
        [headview.view addSubview:waitlabel];
        [headview.view addSubview:timeLabel];
        [headview.view addSubview:SNLabel];
    
        [myHeader.contentView addSubview:headView];
        
    }

    return myHeader;
    
}

// 尾视图 复用代码
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
        
    UITableViewHeaderFooterView  *myFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerReuseIdentifier];
    OrderListModel *orderList = self.SectionsCount[section];
    
    UIView *footer = (UIView *)[myFooter.contentView viewWithTag:80];
    UILabel *totalLabel = (UILabel *)[footer viewWithTag:81];
    UILabel *orderIDLabel = (UILabel *)[footer viewWithTag:79];
    UILabel *payway = (UILabel *)[footer viewWithTag:78];
    
    orderIDLabel.text = orderList.order_id;
    totalLabel.text = orderList.total_fee;
    payway.text = orderList.pay_code;
    
    if (footer == nil) {
        
        HCMNoPayFooterview *footerView = [[HCMNoPayFooterview alloc]initWithNibName:@"HCMNoPayFooterview" bundle:nil];
       
        UILabel *payway = [self setLabelsRect:CGRectMake(0, 0, 0, 0) textAlignment:YES];
        payway.tag = 78;
        payway.textColor = [UIColor whiteColor];
        payway.text = orderList.pay_code;
        
        
        UILabel *order_id = [self setLabelsRect:CGRectMake(0, 0, 0, 0) textAlignment:YES];
        order_id.tag = 79;
        order_id.textColor = [UIColor whiteColor];
        order_id.text = orderList.order_id;
        
        UILabel *total_fee_label = [self setLabelsRect:CGRectMake(60, 13, 110, 20) textAlignment:YES];
        total_fee_label.tag = 81;
        total_fee_label.textColor = [UIColor redColor];
        total_fee_label.text = orderList.total_fee;
        
        footer = footerView.view;
        footer.tag = 80;
        
        CGFloat X = footer.bounds.size.width;
        CGFloat Y = footer.bounds.size.height - 44;
        
        UIButton *cancelBtn = [self setButtonRect:CGRectMake(X - 140 , Y, 60, 20) bgImage:@"button-narrow-gray" title:@"取消付款"];
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelThePayment:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *payBtn = [self setButtonRect:CGRectMake(X - 70, Y, 60, 20) bgImage:@"button-narrow-red" title:@"付  款"];
        [payBtn addTarget:self action:@selector(clickPayment:) forControlEvents:UIControlEventTouchUpInside];
        
        [footer addSubview:payway];
        [footer addSubview:order_id];//付款用到的id
        [footer addSubview:total_fee_label];//总价格
        [footer addSubview:payBtn];//支付按钮
        [footer addSubview:cancelBtn];//取消按钮
        [myFooter.contentView addSubview:footer];
    }
    
    return myFooter;
}

// 抽取代码 设置btn
- (UIButton *)setButtonRect:(CGRect )rectF bgImage:(NSString *)bgImage title:(NSString *)title{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:rectF];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [btn setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    return btn;
}
// 抽取代码 设置 label
- (UILabel *)setLabelsRect:(CGRect )rectF textAlignment:(BOOL )isAlignment{
    
    UILabel *label = [[UILabel alloc]initWithFrame:rectF];
    
    label.font = [UIFont systemFontOfSize:14];
    
    label.textAlignment = isAlignment ? NSTextAlignmentLeft : NSTextAlignmentRight;
    
    return label;
}

// 点击支付
- (void)clickPayment:(UIButton *)btn{
    
    [SVProgressHUD showInfoWithStatus:@"跳转中"];
    UILabel *order_id = (UILabel *)[btn.superview viewWithTag:79];
    UILabel *payway = (UILabel *)[btn.superview viewWithTag:78];

    HCMLog(@"%@",payway.text);
    
    //<微信支付>
    if ([payway.text isEqualToString:@"wechatpay_unifiedorder"]) {
        
        self.defaults = [NSUserDefaults  standardUserDefaults];
        self.uid = [self.defaults objectForKey:@"uid"];
        self.sid = [self.defaults objectForKey:@"sid"];
        
        NSDictionary *dict = @{@"session":@{@"uid":self.uid,@"sid":self.sid},
                               @"order_id":order_id.text};
        NSLog(@"order_id---%@",order_id.text);
        [[AddressNerworking sharedManager]postAwaitPayWechatPayURL:dict successBlock:^(id responseBody) {
            
            if (responseBody[@"status"][@"error_code"]) {
                
                [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
                return ;
            }
            
            PayReq* req = [[PayReq alloc] init];
            req.partnerId = responseBody[@"data"][@"partnerid"];  //[dict objectForKey:@"partnerid"];
            req.prepayId  = responseBody[@"data"][@"prepayid"];   //[dict objectForKey:@"prepayid"];
            req.nonceStr  = responseBody[@"data"][@"noncestr"];   //[dict objectForKey:@"noncestr"];
            req.timeStamp = [responseBody[@"data"][@"timestamp"] intValue]; //@"1457331624";
            req.package   = responseBody[@"data"][@"package"];     //[dict objectForKey:@"package"];
            req.sign      = responseBody[@"data"][@"sign"];        //[dict objectForKey:@"sign"];
            [WXApi sendReq:req];
            
            NSLog(@"%@",responseBody[@"data"]);
            
        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:@"加载失败！"];
            
            
        }];
        return;
        
    }else{  //<支付宝支付>或者<网银支付>
        
        UILabel *order_id = (UILabel *)[btn.superview viewWithTag:79];
    
        HCMPayOrderWebViewVC *payVC = [[HCMPayOrderWebViewVC alloc]initWithNibName:@"HCMPayOrderWebViewVC" bundle:nil];
    
        payVC.orderID = order_id.text;
        payVC.status = NO;
    
        [self.navigationController pushViewController:payVC animated:YES];
        
    }

}
// 点击取消支付
- (void)cancelThePayment:(UIButton *)btn{
    
    UILabel *order_id = (UILabel *)[btn.superview viewWithTag:79];
    
    NSDictionary *dict = @{@"session":@{@"sid":self.sid,@"uid":self.uid},
                           @"order_id":order_id.text};
    
    [SVProgressHUD show];
    
    [[AddressNerworking sharedManager]postOrderCancel:dict successBlock:^(id responseBody) {
        
        
        if (responseBody[@"data"]) {
            [self theDropdownLoadMore];
        }else{
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
        }
        
    } failureBlock:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:@"网络出错"];
    }];
    
}

// 设计行高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 64;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}

-(void)dealloc{
    [HCMNSNotificationCenter removeObserver:self];
}
@end
