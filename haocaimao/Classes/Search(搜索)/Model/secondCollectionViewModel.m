//
//  secondCollectionViewModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/2.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "secondCollectionViewModel.h"

@implementation secondCollectionViewModel
+(id)parsesecondCollectionViewModel:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.cateId2 = dic[@"cateId2"];
        self.cateName2 = dic[@"cateName2"];
        self.cateInfo3 = dic[@"cateInfo3"];
        self.cateId3 = dic[@"cateId3"];
        self.cateName3 = dic[@"cateName3"];
        self.cateLogo = dic[@"cateLogo"];
       
    }
    return self;
}
@end
