//
//  CycleScrollView.h
//  PagedScrollView
//
//  Created by 李芷贤 on 15-8-8.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//
////广告栏 跳转 时间 分类

#import <UIKit/UIKit.h>

@interface CycleScrollView : UIView

@property (nonatomic , readonly) UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic , assign) NSInteger currentPageIndex;//当前页


//@property(nonatomic,assign)NSInteger index;
/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

/**
 数据源：获取总的page个数
 **/
@property (nonatomic , copy) NSInteger (^totalPagesCount)(void);
/**
 数据源：获取第pageIndex个位置的contentView
 **/
@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
/**
 当点击的时候，执行的block
 **/
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);

@end