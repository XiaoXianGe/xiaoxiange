//
//  mainTableViewModel.h
//  haocaimao
//
//  Created by 好采猫 on 15/11/26.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mainTableViewModel : NSObject
@property (strong, nonatomic) NSArray *image;
@property (strong, nonatomic) NSArray *helightImage;
+(id)parseTableViewModel:(NSDictionary *)dict;

@end
