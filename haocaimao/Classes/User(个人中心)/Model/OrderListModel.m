//
//  OrderListModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/11.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

+ (id)parseOrderListDict:(NSDictionary *)dict{
   return [[OrderListModel alloc]initWithDictionary:dict];
}

- (id)initWithDictionary:(NSDictionary *)dataDic{
    
    self = [super init];
    
    if (self) {
    
        self.order_id = dataDic[@"order_id"];
        self.order_sn = dataDic[@"order_sn"];
        
        NSString *timeStr = dataDic[@"order_time"];
        NSRange range = [dataDic[@"order_time"] rangeOfString:@"+"];
        timeStr = [timeStr substringToIndex:range.location];
        
        self.order_time = timeStr;
        self.total_fee = [NSString stringWithFormat:@"%@元",dataDic[@"total_fee"]];
        self.formated_bonus = dataDic[@"formated_bonus"];
        self.formated_shipping_fee = dataDic[@"formated_shipping_fee"];
        self.formated_integral_money = dataDic[@"formated_integral_money"];
        self.pay_code = dataDic[@"order_info"][@"pay_code"];
        self.order_status = dataDic[@"order_status"];
     
    }
    
    return self;
    
}

@end
