//
//  mainTableViewModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/26.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "mainTableViewModel.h"

@implementation mainTableViewModel
+(id)parseTableViewModel:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.image = dic[@"image"];
        self.helightImage = dic[@"heightImage"];
    }
    return self;
}
@end
