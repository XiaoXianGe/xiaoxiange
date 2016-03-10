//
//  UserModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/8/26.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, strong)NSArray *userData;

@property (nonatomic, strong)NSArray *userClassifyData;

+ (id)parseUserData;

+ (id)parseUserClassifyData:(NSString *)classifyName;

@end
