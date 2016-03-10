//
//  CartListModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/9/17.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartListModel : NSObject

@property (nonatomic, strong)NSString *goods_name;
@property (nonatomic, strong)NSString *goods_number;
@property (nonatomic, strong)NSString *goods_price;

+ (id)parseCartListDict:(NSDictionary *)dict;

@end
