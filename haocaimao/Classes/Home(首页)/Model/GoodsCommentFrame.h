//
//  GoodsCommentFrame.h
//  haocaimao
//
//  Created by 李芷贤 on 15/9/10.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsCommentModel.h"

// 昵称字体
#define HCMCommentCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define HCMCommentCellTimeFont [UIFont systemFontOfSize:12]
// 正文字体
#define HCMCommentCellContentFont [UIFont systemFontOfSize:14]


@interface GoodsCommentFrame : NSObject

@property (nonatomic,strong)GoodsCommentModel *comment;

/** 原创微博整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
