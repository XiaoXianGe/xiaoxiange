//
//  HCMOrderInfoCellModel.h
//  haocaimao
//
//  Created by 好采猫 on 16/3/21.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCMOrderInfoCellModel : NSObject

/** 商品名字 */
@property(nonatomic,copy)NSString * goodsName;
/** 商品价格 */
@property(nonatomic,copy)NSString * goodsPrice;
/** 商品ID */
@property(nonatomic,copy)NSString * goodsId;
/** 商品数量 */
@property(nonatomic,copy)NSString * goodsNumber;




@end
