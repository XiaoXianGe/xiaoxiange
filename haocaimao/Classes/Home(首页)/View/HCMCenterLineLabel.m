//
//  HCMCenterLineLabel.m
//  haocaimao
//
//  Created by 李芷贤 on 15/9/5.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMCenterLineLabel.h"

@implementation HCMCenterLineLabel

-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    //画矩形
    UIRectFill(CGRectMake(0, rect.size.height * 0.36, rect.size.width, 1));
    
    
   
    /*
    //画线
     CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor redColor] setStroke];
    
    //设置起点
    CGContextMoveToPoint(ctx, 0 , rect.size.height * 0.4);
    //连线到另一个点
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height *0.4);
    //渲染
    CGContextStrokePath(ctx);
    */
}

@end
