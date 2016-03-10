//
//  PartnerIndex2Model.h
//  haocaimao
//
//  Created by 好采猫 on 16/3/10.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartnerIndex2Model : NSObject

/** 订单号 */
@property(nonatomic,copy)NSString * orderSN;
/** 分成状态 */
@property(nonatomic,copy)NSString * status;
/** 现金分成 */
@property(nonatomic,copy)NSString * orderAmount;
/** 后台查询ID */
@property(nonatomic,copy)NSString * orderId;
/** 提成佣金 */
@property(nonatomic,copy)NSString * commission;
/** 下单时间 */
@property(nonatomic,copy)NSString * confirmTime;


@end
