//
//  BrandViewController.h
//  haocaimao
//
//  Created by 李芷贤 on 15/9/17.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BrandViewController : UIViewController



@property(copy,nonatomic)NSString *category_id;
@property(copy,nonatomic)NSString *keywords;

@property(strong,nonatomic)NSString *brand_name;
@property(assign,nonatomic)NSInteger brand_id;

@property(copy,nonatomic)NSString *price_min;
@property(copy,nonatomic)NSString *price_max;

@end
