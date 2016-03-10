//
//  SortBarndPrice.m
//  haocaimao
//
//  Created by 李芷贤 on 15/9/18.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "SortBarndPrice.h"

@implementation SortBarndPrice



+(id)parseSortPriceWith:(NSDictionary *)dict{
    return [[self alloc]initWithSortPriceJSON:dict];
}

-(id)initWithSortPriceJSON:(NSDictionary *)dict{
    
    self = [super init];
    
    if (self) {
        
        self.price_max = dict[@"price_max"];
        self.price_min = dict[@"price_min"];

    }
    
    return self;
}

@end
