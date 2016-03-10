//
//  UIImage+Circle.m
//  MusicPlayer
//
//  Created by tarena on 15-6-16.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "UIImage+Circle.h"

@implementation UIImage (Circle)

+ (UIImage *)circleImageWithImage:(UIImage *)sourceImage
{
    //1. 开启上下文
    CGFloat imageWidth = sourceImage.size.width;
    CGFloat imageHeigh = sourceImage.size.height;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHeigh), NO, 0);
    
    //2. 获取上下文
    UIGraphicsGetCurrentContext();
    
    //3. 画圆
    CGFloat radius = sourceImage.size.width < sourceImage.size.height ? sourceImage.size.width * 0.5 : sourceImage.size.height * 0.5;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(imageWidth * 0.5, imageHeigh * 0.5) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    [bezierPath stroke];
    //4. 使用BezierPath进行剪切
    [bezierPath addClip];
    
    //5. 画图
    [sourceImage drawInRect:CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height)];
    
    //6. 从内存中创建新图片对象
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //7. 结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end








