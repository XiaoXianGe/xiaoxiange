//
//  HomeCategorySearch.h
//  haocaimao
//
//  Created by 李芷贤 on 15/9/10.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCategorySearch : NSObject


@property(nonatomic,copy)NSString *cateId;
@property(nonatomic,copy)NSString *cateName;
@property (copy, nonatomic) NSString *cateLogo;


+(id)categoryWithJson:(NSDictionary *)dic;



@end
