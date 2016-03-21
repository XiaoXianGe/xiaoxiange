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

@interface HCMOrderInfoTableVC ()
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
@property(nonatomic,weak)IBOutlet UILabel * orderStatus;
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
    
    [SVProgressHUD dismiss];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    
    self.title = @"订单详情";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HCMOrderInfoCell class]) bundle:nil] forCellReuseIdentifier:orderInfoID];
   
//    [self Networking];
    [self loadOrderInfoWith:self.model];
    
    self.headerView.height = 187;
    self.tableView.tableHeaderView = self.headerView;
    
}

//-(void)Networking{
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSString *sid = [defaults objectForKey:@"sid"];
//    NSString *uid = [defaults objectForKey:@"uid"];
//    
//    params[@"session"] = @{@"sid":sid,@"uid":uid};
//    params[@"order_id"] = self.order_id;
//
//    [[AddressNerworking sharedManager] postOrder_detailsURL:params successBlock:^(id responseBody) {
//        
//        HCMLog(@"....%@",responseBody);
//        
//        HCMOrderInfoModel *model = [HCMOrderInfoModel objectWithKeyValues:responseBody[@"data"]];
//        
//        [self loadOrderInfoWith:model];
//        
//        self.goodsArray = [HCMOrderInfoCellModel objectArrayWithKeyValuesArray:responseBody[@"data"][@"orderGoods"]];
//        
//        [self.tableView reloadData];
//        
//    } failureBlock:^(NSString *error) {
//        HCMLog(@"22222%@",error);
//        
//    }];
//    
//}

-(void)loadOrderInfoWith:(HCMOrderInfoModel *)model{
    
    if (self.model.postscript) {
      
    }
    self.postScriptView.hidden = !(BOOL)self.model.postscript;
    
    if (self.postScriptView.hidden == YES) {
        self.footerView.height = 380;
        self.tableView.tableFooterView = self.footerView;
    }
    if (self.postScriptView.hidden == NO) {
        self.footerView.height = 470;
        self.tableView.tableFooterView = self.footerView;
        self.unitName.text = model.postscript[@"unitName"];
        self.taxpayerIDCode.text = model.postscript[@"taxpayerIDCode"];
        self.registeredMobile.text = model.postscript[@"registeredMobile"];
        self.registeredAddress.text = model.postscript[@"registeredAddress"];
        self.bankName.text = model.postscript[@"bankName"];
        self.bankAccount.text = model.postscript[@"bankAccount"];
    }
    
    self.orderSN.text = [NSString stringWithFormat:@"订单号:%@",model.orderSN];
    self.consignee.text = model.consignee;
    self.mobile.text = model.mobile;
    self.address.text = model.address;
    self.payStatus.text = model.payStatus;
    self.orderStatus.text = model.orderStatus;
    self.shippingStatus.text = model.shippingStatus;
    self.invPayee.text = model.invPayee;
    self.invContent.text = model.invContent;
    self.goodsAmount.text = [NSString stringWithFormat:@"￥%.2f",([model.orderAmount floatValue] - [model.shippingFee floatValue])];
    self.shippingFee.text = [NSString stringWithFormat:@"￥%@",model.shippingFee];
    self.orderAmount.text = model.orderAmount;
    self.orderTime.text = [NSString stringWithFormat:@"下单时间:%@",model.addTime];
    
   
    
    


}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    
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

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

@end
