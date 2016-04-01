//
//  HCMOrderInfoTableVC.m
//  haocaimao
//
//  Created by 好采猫 on 16/3/18.
//  Copyright © 2016年 haocaimao. All rights reserved.
//  订单详情

#import "HCMOrderInfoTableVC.h"
#import "HCMOrderInfoModel.h"
#import "HCMOrderInfoCell.h"
#import "AddressNerworking.h"
#import "MJExtension.h"
#import "HCMOrderInfoCellModel.h"

#import "HCMPayOrderWebViewVC.h"
#import "HCMPayWay.h"

@interface HCMOrderInfoTableVC ()<UIActionSheetDelegate>
/** 订单号 */
@property (weak, nonatomic) IBOutlet UILabel *orderSN;
/** 收件人 */
@property (weak, nonatomic) IBOutlet UILabel *consignee;
/** 电话 */
@property(nonatomic,weak)IBOutlet UILabel  * mobile;
/** 地址 */
@property(nonatomic,weak)IBOutlet UILabel * address;
/** 支付方式 */
@property(nonatomic,weak)IBOutlet UILabel * paymentName;
/** 订单状态 */
@property(nonatomic,weak)UILabel * orderStatus;
/** 付款状态 */
@property(nonatomic,weak)IBOutlet UILabel * payStatus;
/** 配送状态 */
@property(nonatomic,weak)IBOutlet UILabel * shippingStatus;
/** 普通发票 */
@property(nonatomic,weak)IBOutlet UILabel * invPayee;
/** 普通发票 - 明细 */
@property(nonatomic,weak)IBOutlet UILabel * invContent;
/** 增值税发票 */
@property(nonatomic,copy)NSString * postscript;
/** 增值税发票 -  单位名称 */
@property(nonatomic,weak)IBOutlet UILabel * unitName;
/** 增值税发票 -  注册号码 */
@property(nonatomic,weak)IBOutlet UILabel * registeredMobile;
/** 增值税发票 -  银行名称 */
@property(nonatomic,weak)IBOutlet UILabel * bankName;
/** 增值税发票 -  注册地址 */
@property(nonatomic,weak)IBOutlet UILabel * registeredAddress;
/** 增值税发票 -  银行账号 */
@property(nonatomic,weak)IBOutlet UILabel * bankAccount;
/** 增值税发票 -  纳税人识别码 */
@property(nonatomic,weak)IBOutlet UILabel * taxpayerIDCode;
/** 商品总价 */
@property(nonatomic,weak)IBOutlet UILabel * goodsAmount;
/** 运费 */
@property(nonatomic,weak)IBOutlet UILabel * shippingFee;
/** 实付款 */
@property(nonatomic,weak)IBOutlet UILabel * orderAmount;
/** 下单时间 */
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
/** 纳税人的VIew */
@property (weak, nonatomic) IBOutlet UIView *postScriptView;
/** 头部试图VIew */
@property (strong, nonatomic) IBOutlet UIView *headerView;
/** 尾部试图VIew */
@property (strong, nonatomic) IBOutlet UIView *footerView;
/** 取消订单button */
@property (weak, nonatomic) IBOutlet UIButton *cancelOrder;
/** 去付款button */
@property (weak, nonatomic) IBOutlet UIButton *payOrder;



@end

@implementation HCMOrderInfoTableVC

static NSString *const orderInfoID = @"orderInfoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HCMOrderInfoCell class]) bundle:nil] forCellReuseIdentifier:orderInfoID];
   
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -35, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = HCMColor(239, 239, 244, 1.0);
    
    [self loadOrderInfoWith:self.model];
    
    self.headerView.height = 165;
    self.tableView.tableHeaderView = self.headerView;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [SVProgressHUD dismiss];
}

- (void) clickBack {
        
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)loadOrderInfoWith:(HCMOrderInfoModel *)model{
    
    self.postScriptView.hidden = !(BOOL)self.model.postscript;
    
    if (self.postScriptView.hidden == YES) {
        self.footerView.height = 345;
        self.tableView.tableFooterView = self.footerView;
    }else{
        self.footerView.height = 415;
        self.tableView.tableFooterView = self.footerView;
        self.unitName.text = model.postscript[@"unitName"];
        self.taxpayerIDCode.text = model.postscript[@"taxpayerIDCode"];
        self.registeredMobile.text = model.postscript[@"registeredMobile"];
        self.registeredAddress.text = model.postscript[@"registeredAddress"];
        self.bankName.text = model.postscript[@"bankName"];
        self.bankAccount.text = model.postscript[@"bankAccount"];
    }
    //订单号，收件人，电话，地址
    self.orderSN.text = [NSString stringWithFormat:@"订单号:%@",model.orderSN];
    self.consignee.text = model.consignee;
    self.mobile.text = model.mobile;
    self.address.text = model.address;
    //支付方式
    self.paymentName.text = model.paymentName;
    //支付状态
    self.payStatus.text = model.payStatus;
    //订单状态
    if (![model.orderStatus isEqualToString:@"未确定"]) {
        //支付按钮是否隐藏
        self.cancelOrder.hidden = YES;
        self.payOrder.hidden = YES;
    }
    //配送状态
    if ([model.shippingStatus isEqualToString:@"--"]) {
        
        self.shippingStatus.text = @"未发货";
        
    }else{
        self.shippingStatus.text = model.shippingStatus;
    }
    
    //发票信息
    self.invPayee.text = model.invPayee.length ? model.invPayee : @"无";
    self.invContent.text = model.invContent.length ? model.invContent : @"无";
    //商品总额
    self.goodsAmount.text = [NSString stringWithFormat:@"￥%.2f",([model.orderAmount floatValue] - [model.shippingFee floatValue])];
    //订单运费
    self.shippingFee.text = [NSString stringWithFormat:@"￥%@",model.shippingFee];
    //订单总额
    self.orderAmount.text = [NSString stringWithFormat:@"￥%@",model.orderAmount];
    //订单时间
    self.orderTime.text = [NSString stringWithFormat:@"下单时间:%@",model.addTime];
    

}
- (IBAction)gotoPay:(UIButton *)sender {
    
    [SVProgressHUD show];
    
    //<微信支付>
    if ([_payWay isEqualToString:@"wechatpay_unifiedorder"]) {
        
        [HCMPayWay WeChatPayWithorder_id:self.order_id];
        return;
        
    }else{  //<支付宝支付>或者<网银支付>

        HCMPayOrderWebViewVC *payVC = [[HCMPayOrderWebViewVC alloc]initWithNibName:@"HCMPayOrderWebViewVC" bundle:nil];
        
        payVC.orderID = self.order_id;
        payVC.status = NO;
        
        [self.navigationController pushViewController:payVC animated:YES];
        
    }

}

- (IBAction)cancelPay:(UIButton *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"取消订单后，订单降被删除哦。是否继续?" delegate:self cancelButtonTitle:@"否" destructiveButtonTitle:@"是" otherButtonTitles:nil, nil];
    
    [actionSheet showInView:self.tableView];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        //确定删除订单
//        UILabel *head_orderID = (UILabel *)[btn.superview viewWithTag:79];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *sid = [defaults objectForKey:@"sid"];
        NSString *uid = [defaults objectForKey:@"uid"];
        
        NSDictionary *dict = @{@"session":@{@"sid":sid,@"uid":uid},
                               @"order_id":self.order_id};
    
        [SVProgressHUD show];
        
        [[AddressNerworking sharedManager]postOrderCancel:dict successBlock:^(id responseBody) {
            
            if (responseBody[@"status"][@"error_desc"]) {
                [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];

            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failureBlock:^(NSString *error) {
            [SVProgressHUD showInfoWithStatus:@"网络出错"];
        }];

    }

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HCMOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfoID];
    
    HCMOrderInfoCellModel *model = self.goodsArray[indexPath.row];
    
    cell.goodName.text = model.goodsName;
    cell.goodPrice.text = [NSString stringWithFormat:@"￥%@",model.goodsPrice];
    cell.buyCount.text = [NSString stringWithFormat:@"x %@",model.goodsNumber];
    [cell.goodImage sd_setImageWithURL:[NSURL URLWithString:model.goodsThumb]];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
