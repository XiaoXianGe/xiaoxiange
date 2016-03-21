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

@end

@implementation HCMOrderInfoTableVC

static NSString *const orderInfoID = @"orderInfoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HCMOrderInfoCell class]) bundle:nil] forCellReuseIdentifier:orderInfoID];
   
}

-(void)Networking{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *sid = [defaults objectForKey:@"sid"];
    NSString *uid = [defaults objectForKey:@"uid"];
    
    params[@"session"] = @{@"sid":sid,@"uid":uid};
    params[@"order_id"] = self.order_id;

    [[AddressNerworking sharedManager] postOrder_detailsURL:params successBlock:^(id responseBody) {
        
        HCMLog(@"....%@",responseBody);
        
        HCMOrderInfoModel *model = [HCMOrderInfoModel objectWithKeyValues:responseBody[@"data"]];
        
        
    } failureBlock:^(NSString *error) {
        HCMLog(@"22222%@",error);
        
    }];
    
}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCMOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfoID];
    
    
    
    
    
    return cell;
}



@end
