//
//  SortBrandFiltrate.m
//  haocaimao
//
//  Created by 李芷贤 on 15/9/17.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "SortBrandFiltrate.h"

@implementation SortBrandFiltrate

/**
 *  解析筛选模型
 */
+(id)parseSortFiltrateWith:(NSDictionary *)dict{
    return [[self alloc]initWithSortFiltrateJSON:dict];
}

-(id)initWithSortFiltrateJSON:(NSDictionary *)dict{
    
    self = [super init];
    
    if (self) {
        
        self.brand_id = dict[@"brand_id"];
        self.brand_name = dict[@"brand_name"];
        
    }
    
    return self;
}


@end
