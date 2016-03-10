//
//  UserModelTool.h
//  haocaimao
//
//  Created by 好采猫 on 15/8/26.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModelTool : NSObject

+ (NSString *)userClassifyWebView:(NSString *)webID;

+ (NSArray *)user;

+ (NSArray *)userClassify:(NSString *)className;


@end
