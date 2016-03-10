//
//  HCMPartnerInfoModel.h
//  haocaimao
//
//  Created by 好采猫 on 16/3/10.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCMPartnerInfoModel : NSObject
/** 申请人邮箱 */
@property(copy,nonatomic)NSString *email;
/** 申请人电话 */
@property(copy,nonatomic)NSString *mobilePhone;
/** 申请人性别 */
@property(copy,nonatomic)NSString *sex;

@end
