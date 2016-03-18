//
//  HCMFlowCheckOrderTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/16.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//  结算界面

#import "HCMFlowCheckOrderTableViewController.h"
#import "invContentListVC.h"
#import "HCMUserLocationTableViewController.h"
#import "HCMPayOrderWebViewVC.h"

#import "FlowCheckCell.h"
#import "MJExtension.h"

#import "CartListModel.h"
#import "OrderGoodsListModel.h"

#import "CartNetwork.h"
#import "WeChatPayModel.h"

@interface HCMFlowCheckOrderTableViewController ()<UIActionSheetDelegate ,InvContentListVCDelegate,WXApiDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UILabel *consignee;// 收件人
@property (weak, nonatomic) IBOutlet UILabel *tel; // 电话
@property (weak, nonatomic) IBOutlet UILabel *address; // 地址
@property (weak, nonatomic) IBOutlet UILabel *countrys; // 省市区
@property (weak, nonatomic) IBOutlet UILabel *payment; // 支付方式
@property (weak, nonatomic) IBOutlet UILabel *shipping; // 配送方式
@property (weak, nonatomic) IBOutlet UILabel *invContent; // 发票信息

@property (weak, nonatomic) IBOutlet UILabel *freeMoney; // 运费
@property (weak, nonatomic) IBOutlet UILabel *integral; // 积分
@property (weak, nonatomic) IBOutlet UILabel *bonus; // 红包

@property (weak, nonatomic) IBOutlet UILabel *totalPrice; // 总额

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *payWayArray;

@property(assign ,nonatomic)NSInteger payTag;
@property(assign,nonatomic)BOOL MarkPay;

@property (strong, nonatomic)NSDictionary *invDict;

@property (strong, nonatomic)NSString *sid;
@property (strong, nonatomic)NSString *uid;
@property (strong, nonatomic)NSMutableArray *orderGoodsArrays;

@property (strong, nonatomic)OrderGoodsListModel *orderGoods;
@property (strong,nonatomic)WeChatPayModel *wechatmmodel;

@end

@implementation HCMFlowCheckOrderTableViewController

static NSString * const reuseIdentifier = @"MyCell";

-(WeChatPayModel *)wechatmmodel{
    if (!_wechatmmodel) {
        _wechatmmodel = [[WeChatPayModel alloc]init];
    }
    return _wechatmmodel;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"结算";
 
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"index-body-bg"]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FlowCheckCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //self.tableView.tableHeaderView.height = 456;
    self.headerView.height = 464;
   
    
}

- (void)clickBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [SVProgressHUD show];
    [super viewWillAppear:animated];
    
    [self network];
    
    self.tabBarController.tabBar.hidden = YES;
    
    //接收支付成功的通知
    [HCMNSNotificationCenter addObserver:self selector:@selector(clickBack) name:@"WX_PaySuccess" object:nil];
    
    //接收支付失败的通知
    [HCMNSNotificationCenter addObserver:self selector:@selector(clickBack) name:@"WX_PayFailure" object:nil];

    
}

- (void)network{
        
    NSUserDefaults *defaults = [NSUserDefaults  standardUserDefaults];
    self.uid = [defaults objectForKey:@"uid"];
    self.sid = [defaults objectForKey:@"sid"];
    
    NSDictionary *dict = @{@"session":@{@"uid":self.uid,@"sid":self.sid}};
    
    [[CartNetwork sharedManager]postFlowCheckOrder:dict successBlock:^(id responseBody) {
        
        
        if (responseBody[@"status"][@"error_code"]) {
            
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            self.tableView.tableHeaderView = self.headerView;
            self.tableView.tableFooterView = self.footerView;
            return ;
        }
        
        [SVProgressHUD showSuccessWithStatus:nil];
    
        NSMutableArray *mutabArrays = [NSMutableArray array];
        
        for (NSDictionary *dicts in responseBody[@"data"][@"goods_list"]) {
            CartListModel *carts = [CartListModel parseCartListDict:dicts];
            [mutabArrays addObject:carts];
        }
        
        self.orderGoods = [OrderGoodsListModel parseOrderGoodsListDict:responseBody[@"data"]];
        
        [self initWithFooterHeaderViewData:self.orderGoods];
        
        self.orderGoodsArrays = mutabArrays;
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = self.footerView;
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSString *error) {
        
        self.tableView.tableHeaderView.hidden = YES;
        self.tableView.tableFooterView.hidden = YES;
        
        [SVProgressHUD showInfoWithStatus:@"网络错误"];
    }];
    
}
#pragma mark - 初始化 头尾视图

- (void)initWithFooterHeaderViewData:(OrderGoodsListModel *)orderGoods{
    
    self.consignee.text = orderGoods.consignee;
    self.tel.text = orderGoods.tel;
    self.address.text = orderGoods.address;
    self.countrys.text = [NSString stringWithFormat:@"%@ %@ %@ %@",orderGoods.country_name,orderGoods.province_name,orderGoods.district_name,orderGoods.city_name];
    
    NSString *strFee = [orderGoods.shipping_list lastObject][@"format_shipping_fee"];
    self.freeMoney.text = strFee;
    
    NSRange range = [strFee rangeOfString:@"."];
    
    strFee = [strFee substringToIndex:range.location + 3];
    
    float total = [self.total floatValue];
    float fee = [strFee floatValue];
    
    NSString *totalAddFee = [NSString stringWithFormat:@"%.2f 元",total + fee];
    
    self.totalPrice.text = totalAddFee;
    
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.orderGoodsArrays count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FlowCheckCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    CartListModel *carts = self.orderGoodsArrays[indexPath.row];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%@元",carts.goods_price];
    cell.numberLabel.text = [NSString stringWithFormat:@"x %@",carts.goods_number];
    cell.titelLbale.text = carts.goods_name;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
#pragma  mark -- 各种点击事件



//打开发票信息
- (IBAction)clickLnvoiceType:(UIButton *)sender {
    
    invContentListVC *InvVC = [[invContentListVC alloc]initWithNibName:@"invContentListVC" bundle:nil];
    
    InvVC.delegate = self;
    
    [self.navigationController pushViewController:InvVC animated:YES];
    
}
#pragma mark -invContentListVCDelegate

- (void)setInvContent:(invContentListVC *)invContent dictData:(NSDictionary *)dict{
    
    self.invDict = dict;
    HCMLog(@"%@",dict);
    NSString *str = dict[@"inv_type"];
    if ([str isEqualToString:@"普通发票"]) {
       self.invContent.text = dict[@"inv_payee"];
    }else{
        self.invContent.text = dict[@"inv_name"];
    }
    
    [self.tableView reloadData];
}

//打开地址信息
- (IBAction)clickAddress:(UIButton *)sender {
    
    HCMUserLocationTableViewController *userLocationVC = [[HCMUserLocationTableViewController alloc]initWithNibName:@"HCMUserLocationTableViewController" bundle:nil];
    
    [self.navigationController pushViewController:userLocationVC animated:YES];
    
}
- (IBAction)payWay:(UIButton *)sender {
    
    

    for (int i = 0 ; i < self.payWayArray.count; i++) {
        UIButton *btn = self.payWayArray[i];
        btn.selected = NO;
        btn.tag = i;
    }
    sender.selected = YES;
    self.payTag = sender.tag;
    
}

//提交订单
- (IBAction)clickSubmitListing:(UIButton *)sender {

    //检查资料是否完整
     NSString *pay = [[NSString alloc]init];
 
    //检查资料是否完整
    self.MarkPay = NO;
    for (UIButton *btn in self.payWayArray) {
        if (btn.selected == YES) {
            self.MarkPay = YES;
            if (self.payTag == 0) {//微信支付
                pay = @"8";
            }else if (self.payTag == 1){//支付宝
                pay = @"6";
            }
            
        }
    }
    if (self.MarkPay == NO) {
        [SVProgressHUD showInfoWithStatus:@"请选择支付方式"];
        return;
    }

   
    
    NSString *shipping = [self.orderGoods.shipping_list lastObject][@"shipping_id"];
    
    NSDictionary *doneDict = nil;
    
    if (self.invDict != nil) {
        
        if ([self.invDict[@"inv_type"] isEqualToString:@"普通发票"]) {
              //普通发票
            doneDict = @{@"session":@{@"sid":self.sid,@"uid":self.uid},
                         @"pay_id":pay,
                         @"inv_type":self.invDict[@"inv_type"],
                         @"inv_payee":self.invDict[@"inv_payee"],
                         @"inv_content":self.invDict[@"inv_content"],
                         @"shipping_id":shipping};
        }else{//增值税发票
            
            doneDict = @{@"session":@{@"sid":self.sid,@"uid":self.uid},
                         @"pay_id":pay,
                         @"inv_type":self.invDict[@"inv_type"],
                         @"inv_content":self.invDict[@"inv_content"],
                         @"inv_name":self.invDict[@"inv_name"],
                         @"inv_verify":self.invDict[@"inv_verify"],
                         @"inv_address":self.invDict[@"inv_address"],
                         @"inv_tel":self.invDict[@"inv_tel"],
                         @"inv_bank":self.invDict[@"inv_bank"],
                         @"inv_bankuser":self.invDict[@"inv_bankuser"],
                         @"shipping_id":shipping};
        }
        
        
    }else{
        
        doneDict = @{@"session":@{@"sid":self.sid,@"uid":self.uid},
                               @"pay_id":pay,
                               @"shipping_id":shipping};
    }
    
    
    
    
    [[CartNetwork sharedManager]postflowDone:doneDict successBlock:^(id responseBody) {

        
        if (responseBody[@"status"][@"error_code"]) {
            
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
        
        self.wechatmmodel =[WeChatPayModel objectWithKeyValues:responseBody[@"data"][@"appapiInfo"]];
        
        [SVProgressHUD showSuccessWithStatus:@"提交订单成功"];
        
        //如果属于 微信支付
        NSString *wechatPay = @"wechatpay_unifiedorder";
        
        if ([responseBody[@"data"][@"order_info"][@"pay_code"] isEqualToString:wechatPay]) {
            //调起微信支付
            PayReq* req = [[PayReq alloc] init];
            req.partnerId = _wechatmmodel.partnerid;  //[dict objectForKey:@"partnerid"];
            req.prepayId  = _wechatmmodel.prepayid;   //[dict objectForKey:@"prepayid"];
            req.nonceStr  = _wechatmmodel.noncestr;   //[dict objectForKey:@"noncestr"];
            req.timeStamp = [_wechatmmodel.timestamp intValue]; //@"1457331624";
            req.package   = _wechatmmodel.package;    //[dict objectForKey:@"package"];
            req.sign      = _wechatmmodel.sign;       //[dict objectForKey:@"sign"];
            [WXApi sendReq:req];
            
        }else{ // 其他网页支付  支付宝 and 网银
            
            HCMPayOrderWebViewVC *payOrderWebViewVC = [[HCMPayOrderWebViewVC alloc]initWithNibName:@"HCMPayOrderWebViewVC" bundle:nil];
            
            payOrderWebViewVC.orderID = responseBody[@"data"][@"order_id"];
            
            payOrderWebViewVC.status = YES;
            
            [self.navigationController pushViewController:payOrderWebViewVC animated:YES];
            
        }
        
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:@"请到(我的->代付款)完成支付"];
        
    }];
    
}



-(void)dealloc{
    [HCMNSNotificationCenter removeObserver:self];
}

@end
