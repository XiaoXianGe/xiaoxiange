//
//  RegionModel.h
//  adderleDemo
//
//  Created by 好采猫 on 15/10/13.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegionModel : NSObject

@property (strong, nonatomic)NSString *ID;
@property (strong, nonatomic)NSString *name;

+(id) initRegionModelDict:(NSDictionary *)dict;

@end
