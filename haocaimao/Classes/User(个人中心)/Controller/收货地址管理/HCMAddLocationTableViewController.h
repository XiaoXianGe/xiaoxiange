//
//  HCMAddLocationTableViewController.h
//  haocaimao
//
//  Created by 好采猫 on 15/8/29.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//  添加一个收货地址

#import <UIKit/UIKit.h>

@interface HCMAddLocationTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UIView *footView;

@property (strong, nonatomic) NSString *locationName;

@property (strong, nonatomic)NSString *adderssID;

@end
