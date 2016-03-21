//
//  HCMOrderInfoCell.h
//  haocaimao
//
//  Created by 好采猫 on 16/3/21.
//  Copyright © 2016年 haocaimao. All rights reserved.
//  订单详情的cell

#import <UIKit/UIKit.h>

@interface HCMOrderInfoCell : UITableViewCell
/** 商品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *image;
/** 商品名字 */
@property (weak, nonatomic) IBOutlet UILabel *goodName;
/** 商品价格 */
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;
/** 购买数量 */
@property (weak, nonatomic) IBOutlet UILabel *buyCount;

@end
