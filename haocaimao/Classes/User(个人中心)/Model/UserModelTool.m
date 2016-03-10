//
//  UserModelTool.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/26.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "UserModelTool.h"

@implementation UserModelTool

- (NSArray *)getAndUserPlist{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"User" ofType:@"plist"];
    
    return [NSArray arrayWithContentsOfFile:path];
}

- (NSDictionary *)getAndClassiftPlist{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Property List" ofType:@"plist"];
    
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

+ (NSArray *)user{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dic in [[self alloc]getAndUserPlist]) {
        [array addObject: [[dic allKeys] lastObject]];
    }
    
    return [array copy];
}

+(NSArray *)userClassify:(NSString *)className{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dic in [[self alloc]getAndUserPlist]) {
        
       NSString *lastName  = [[dic allKeys] lastObject];
        
        if ([className isEqualToString:lastName]) {
            
            array = dic[className];
            
            return [array copy];
        }
    }
    return [array copy];
    
}

+ (NSString *)userClassifyWebView:(NSString *)webID{
    
    return [[self alloc]getAndClassiftPlist][webID];
}


@end
