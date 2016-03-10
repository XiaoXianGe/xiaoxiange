//
//  RegionModel.m
//  adderleDemo
//
//  Created by 好采猫 on 15/10/13.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "RegionModel.h"

@implementation RegionModel

+(id)initRegionModelDict:(NSDictionary *)dict{
    
    return [[RegionModel alloc]initWithRegionModelDict:dict];
}


- (id)initWithRegionModelDict:(NSDictionary *)dict{
    
    self = [super init];
    
    if (self) {
        
        _ID = dict[@"id"];
        _name = dict[@"name"];
    }
    
    
    return self;
}

@end
