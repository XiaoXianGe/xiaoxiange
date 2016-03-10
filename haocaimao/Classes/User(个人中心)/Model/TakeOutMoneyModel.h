//
//  TakeOutMoneyModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/12/23.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface TakeOutMoneyModel : NSObject
/** 添加时间 */
@property(strong,nonatomic) NSString *add_time;
/** 提现 */
@property(strong,nonatomic) NSString *type;
/** 金额 */
@property(strong,nonatomic) NSString *amount;
/** 银行名+帐号 */
@property(strong,nonatomic) NSString *user_note;
/** 状态 */
@property(strong,nonatomic) NSString *pay_status;

@end
