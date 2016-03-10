//
//  HongBaoModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/12/4.
//  Copyright © 2015年 haocaimao. All rights reserved.
//红包

#import <Foundation/Foundation.h>

#import "MJExtension.h"

@interface HongBaoModel : NSObject

/** 金额*/
@property(strong,nonatomic) NSString *type_money;
/** 最少购买金额*/
@property(strong,nonatomic) NSString *min_goods_amount;
/** 结束时间*/
@property(strong,nonatomic) NSString *use_enddate;
/** 开始时间*/
@property(strong,nonatomic) NSString *use_startdate;
/** 状态*/
@property(strong,nonatomic) NSString *status;

@end
