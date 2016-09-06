//
//  HCMUserLocationTableViewControllerTableViewCell.h
//  haocaimao
//
//  Created by 好采猫 on 15/8/29.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCMUserLocationTableViewControllerTableViewCell : UITableViewCell
/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *userName;
/**
 *  电话
 */
@property (weak, nonatomic) IBOutlet UILabel *name;
/**
 *  地区
 */
@property (weak, nonatomic) IBOutlet UILabel *location;
/**
 *  地址
 */
@property (weak, nonatomic) IBOutlet UILabel *addresseLabel;
/**
 *  被选中状态标图
 */
@property (weak, nonatomic) IBOutlet UIImageView *click;
/**
 *  编辑的btn
 */
@property (weak, nonatomic) IBOutlet UIButton *changeAddaressBtn;
/**
 *  删除的btn
 */
@property (weak, nonatomic) IBOutlet UIButton *deleAddressBtn;

@property (nonatomic, copy)void (^popVC)(NSInteger tag);

@property (nonatomic, copy)void (^deleAddress)(NSInteger tag);


@end
