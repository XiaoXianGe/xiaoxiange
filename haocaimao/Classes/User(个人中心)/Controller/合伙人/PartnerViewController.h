//
//  PartnerViewController.h
//  haocaimao
//
//  Created by 好采猫 on 16/1/27.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartnerViewController : UIViewController
/** 申请人邮箱 */
@property(copy,nonatomic)NSString *email;
/** 申请人电话 */
@property(copy,nonatomic)NSString *mobilePhone;
/** 申请人性别 */
@property(assign, nonatomic)NSInteger sex;

@end
