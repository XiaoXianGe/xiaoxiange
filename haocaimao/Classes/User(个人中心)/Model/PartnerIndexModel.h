//
//  PartnerIndexModel.h
//  haocaimao
//
//  Created by 好采猫 on 16/3/10.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartnerIndexModel : NSObject

/** 等级 */
@property(copy,nonatomic)NSString *rank;
/** 注册人数 */
@property(copy,nonatomic)NSString *amount;
/** 分成比例 */
@property(copy,nonatomic)NSString *proportion;

@end
