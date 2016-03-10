//
//  OutOfGoodsModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/12/3.
//  Copyright © 2015年 haocaimao. All rights reserved.
// 缺货登记

#import <Foundation/Foundation.h>
#import "MJExtension.h"


@interface OutOfGoodsModel : NSObject

/** 商品名称 */
@property(strong,nonatomic) NSString *goodsName;
/** 商品备注 */
@property(strong,nonatomic) NSString *goodsDesc;
/** 商品数量 */
@property(strong,nonatomic) NSString *goodsNumber;
/** 状态 */
@property(strong,nonatomic) NSString *status;

@end
