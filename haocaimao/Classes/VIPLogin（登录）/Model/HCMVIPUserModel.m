//
//  HCMVIPUserModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/10.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMVIPUserModel.h"

@implementation HCMVIPUserModel

+ (id)parseVIPUserDict:(NSDictionary *)dict{
    
    return [[HCMVIPUserModel alloc]initWithDictionary:dict];
    
}
/*
 user =         {
 "collection_num" = 2;
 email = "136145214@qq.com";
 id = 22994;
 name = "\U6d4b\U8bd5\U5458iOS2";
 "order_num" =             {
 "await_pay" = 2;
 "await_ship" = 0;
 finished = 0;
 shipped = 0;
 };
 "rank_level" = 0;
 "rank_name" = "\U6ce8\U518c\U4f1a\U5458";
 */
- (id)initWithDictionary:(NSDictionary *)Dic {
    
    self = [super init];
    
    if (self) {
        
        self.collection_num = Dic[@"collection_num"];
        self.email = Dic[@"email"];
        self.name = Dic[@"name"];
        self.await_pay = Dic[@"order_num"][@"await_pay"];
        self.await_ship = Dic[@"order_num"][@"await_ship"];
        self.finished = Dic[@"order_num"][@"finished"];
        self.shipped = Dic[@"order_num"][@"shipped"];
        self.rank_level = Dic[@"rank_level"];
        self.rank_name = Dic[@"rank_name"];
        
    }
    
    return self;
}
@end
