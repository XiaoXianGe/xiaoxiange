//
//  HCMOrderInfoTableVC.h
//  haocaimao
//
//  Created by 好采猫 on 16/3/18.
//  Copyright © 2016年 haocaimao. All rights reserved.
//  订单详情

#import <UIKit/UIKit.h>
@class HCMOrderInfoModel;

@interface HCMOrderInfoTableVC : UITableViewController

/** 订单id */
@property(nonatomic,copy) NSString * order_id;

/** model */
@property(nonatomic,strong) HCMOrderInfoModel *model;

/** 商品数量 */
@property(nonatomic,strong)NSArray * goodsArray;

/** 支付方式 */
@property(nonatomic,strong)NSString * payWay;


@end
