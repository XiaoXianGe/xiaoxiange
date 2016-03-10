//
//  UIImage+Circle.h
//  MusicPlayer
//
//  Created by tarena on 15-6-16.
//  Copyright (c) 2015年 tarena. All rights reserved.
//
//将图片切成圆型返回
#import <UIKit/UIKit.h>

@interface UIImage (Circle)
/**
 * 根据指定图片的文件名获取一张圆型的图片对象,并加边框
 * @param name 图片文件名
 * @return 切好的圆型图片
 */
+ (UIImage *)circleImageWithImage:(UIImage *)image;

/**
 * 将一张图片变成指定的大小
 * @param image 原图片
 * @param size 指定的大小
 * @return 指定大小的图片
 */
+ (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size;
@end




