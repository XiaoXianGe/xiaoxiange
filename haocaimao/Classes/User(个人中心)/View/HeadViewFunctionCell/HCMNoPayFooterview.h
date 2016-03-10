//
//  HCMNoPayFooterview.h
//  haocaimao
//
//  Created by 好采猫 on 15/9/9.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCMNoPayFooterview : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *formated_shipping_fee_label;
@property (weak, nonatomic) IBOutlet UILabel *formated_bonus_label;
@property (weak, nonatomic) IBOutlet UILabel *formated_integral_money_label;
@property (weak, nonatomic) IBOutlet UILabel *formated_total_fee_label;

@end
