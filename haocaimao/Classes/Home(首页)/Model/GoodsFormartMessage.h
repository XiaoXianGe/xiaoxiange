//
//  GoodsFormartMessage.h
//  haocaimao
//
//  Created by 好采猫 on 15/10/28.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

#define format_ID id

@interface GoodsFormartMessage : NSObject

//规格value
@property(nonatomic,copy)NSString *label;
@property(nonatomic,copy)NSString *format_price;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *format_ID;

@end
