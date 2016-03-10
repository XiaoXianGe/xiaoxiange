//
//  UserModel.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/26.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "UserModel.h"
#import "UserModelTool.h"

@implementation UserModel

+ (id)parseUserClassifyData:(NSString *)classifyName{
    return [[self alloc]initWithUserClassiftData:classifyName];
}

- (id)initWithUserClassiftData:(NSString *)classifyName{
    
    self = [super init];
    if (self) {
        self.userClassifyData = [UserModelTool userClassify:classifyName];
    }
    return self;
}

+ (id)parseUserData{

    return [[self alloc]initWithUserData];
}

- (id)initWithUserData{
    
    self = [super init];
    
    if (self) {
        self.userData = [UserModelTool user];
    }
    return self;
}
@end
