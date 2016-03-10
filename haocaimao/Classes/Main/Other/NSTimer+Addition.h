//
//  NSTimer+Addition.h
//  PagedScrollView
//
//  Created by 李芷贤 on 15-8-8.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//
//
//广告栏 跳转 时间 分类
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
