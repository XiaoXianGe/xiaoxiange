//
//  HCMNonPaymentCell.h
//  haocaimao
//
//  Created by 好采猫 on 15/9/8.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCMNonPaymentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *shopPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumber;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (strong ,nonatomic)NSString * payWayStr;
@end
