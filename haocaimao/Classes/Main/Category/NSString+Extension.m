//
//  NSString+Extension.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/17.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font withSize:(CGSize)size {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = font;
   
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
}
@end
