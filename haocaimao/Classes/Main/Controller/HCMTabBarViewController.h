//
//  HCMTabBarViewController.h
//  好采猫
//
//  Created by 好采猫 on 15/8/4.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCMShoppingTableViewController.h"
@interface HCMTabBarViewController : UITabBarController

@property(nonatomic, copy) NSString *badgeValue;
@property(strong,nonatomic)HCMShoppingTableViewController *shopping;
@end
