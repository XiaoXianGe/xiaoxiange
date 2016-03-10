//
//  secondCollectionViewModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/12/2.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface secondCollectionViewModel : NSObject
@property (strong, nonatomic) NSString *cateId2;
@property (strong, nonatomic) NSString *cateName2;
@property (strong, nonatomic) NSArray *cateInfo3;
@property (strong, nonatomic) NSString *cateBanner;
@property (strong, nonatomic) NSString *cateId3;
@property (strong, nonatomic) NSString *cateName3;
@property (strong, nonatomic) NSString *cateLogo;
@property (strong, nonatomic) NSString *cateId;

+(id)parsesecondCollectionViewModel:(NSDictionary *)dict;



@end
