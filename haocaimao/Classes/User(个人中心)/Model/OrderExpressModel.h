//
//  OrderExpressModel.h
//  haocaimao
//
//  Created by 好采猫 on 16/6/7.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderExpressModel : NSObject
/** 物流信息 */
@property(nonatomic,strong)NSString * context;
/** 物流时间 */
@property(nonatomic,strong)NSString * time;
/** 物流定位 */
@property(nonatomic,strong)NSString * location;
/** cell的高度 */
@property(nonatomic)CGFloat cellH;

@end
