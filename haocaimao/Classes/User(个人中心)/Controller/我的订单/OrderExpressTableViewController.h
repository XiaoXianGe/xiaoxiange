//
//  OrderExpressTableViewController.h
//  haocaimao
//
//  Created by 好采猫 on 16/6/7.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderExpressModel.h"
@interface OrderExpressTableViewController : UITableViewController


/** 数组 */
@property(nonatomic,strong)NSArray * array;

/** model */
@property(nonatomic,strong)OrderExpressModel * model;

/** 字典 */
@property(nonatomic,strong)NSDictionary * dict;


@end
