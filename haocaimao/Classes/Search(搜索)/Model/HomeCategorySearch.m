//
//  HomeCategorySearch.m
//  haocaimao
//
//  Created by 李芷贤 on 15/9/10.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HomeCategorySearch.h"

@implementation HomeCategorySearch

+(id)categoryWithJson:(NSDictionary *)dic{
    return [[self alloc]initWithCategoryDic:dic];
}
-(id)initWithCategoryDic:(NSDictionary *)dic{
    
    self = [super init];
    
    
    if (self) {
        
        self.cateId = dic[@"cateId"];
        self.cateName = dic[@"cateName"];
        self.cateLogo = dic[@"cateLogo"];
    }
    
    return self;
}


@end
