//
//  HCMTakeOutMoneyTableViewCell.h
//  haocaimao
//
//  Created by 好采猫 on 15/12/23.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCMTakeOutMoneyTableViewCell : UITableViewCell
//时间
@property (weak, nonatomic) IBOutlet UILabel *add_time;
//提现
@property (weak, nonatomic) IBOutlet UILabel *type;
//金额
@property (weak, nonatomic) IBOutlet UILabel *amount;
//状态
@property (weak, nonatomic) IBOutlet UILabel *pay_status;
//银行账号
@property (weak, nonatomic) IBOutlet UILabel *user_note;

@end
