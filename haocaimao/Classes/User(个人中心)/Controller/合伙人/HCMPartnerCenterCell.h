//
//  HCMPartnerCenterCell.h
//  合伙人test
//
//  Created by 好采猫 on 16/3/9.
//  Copyright © 2016年 好采猫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCMPartnerCenterCell : UITableViewCell

/** 左边label */
@property (weak, nonatomic) IBOutlet UILabel *Label_Left;
/** 中间label */
@property (weak, nonatomic) IBOutlet UILabel *Label_Middle;
/** 右边label */
@property (weak, nonatomic) IBOutlet UILabel *Label_Right;
/** 中间的20%透明白色VIew */
@property (weak, nonatomic) IBOutlet UIView *whiteVIew;


@end
