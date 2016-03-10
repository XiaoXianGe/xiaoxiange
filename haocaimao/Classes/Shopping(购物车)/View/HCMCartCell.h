//
//  HCMCartCell.h
//  haocaimao
//
//  Created by 好采猫 on 15/9/15.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartListFrame;
@class HCMCartCell;

@protocol HCMCartCellDelegate <NSObject>

- (void)clickDeleteGoodsCell:(HCMCartCell *)cell redID:(NSString *)redID;
- (void)clickDeleteShopGoodsCell:(HCMCartCell *)cell seller_id:(NSString *)seller_id;

- (void)clickEditGoodsNumberCell:(HCMCartCell *)cell redID:(NSString *)redID number:(int)number;

@end

@interface HCMCartCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)CartListFrame *cartGoods;

@property (nonatomic, weak)id<HCMCartCellDelegate> delegate;


@end
