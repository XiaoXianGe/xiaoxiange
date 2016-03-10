//
//  weiXinData.h
//  haocaimao
//
//  Created by 好采猫 on 15/12/10.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "weiXinLoginModel.h"

#define APP_ID @"wx2a1388283f78955d"

@interface weiXinData : NSObject<WXApiDelegate>

@property (strong, nonatomic) weiXinLoginModel *model;
@property (strong, nonatomic) FMDatabase *sqlBase;

@end
