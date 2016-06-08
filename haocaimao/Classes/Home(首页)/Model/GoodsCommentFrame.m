//
//  GoodsCommentFrame.m
//  haocaimao
//
//  Created by 李芷贤 on 15/9/10.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "GoodsCommentFrame.h"

#define HCMCommentCellBorderW 10

@implementation GoodsCommentFrame

-(void)setComment:(GoodsCommentModel *)comment{
    
    _comment = comment;
    
    //cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** 头像 */
    CGFloat iconX = HCMCommentCellBorderW;
    CGFloat iconY = HCMCommentCellBorderW;
    CGFloat iconWH = 18;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    
    /** 昵称 */
    CGFloat nameX = iconWH + HCMCommentCellBorderW +3;
    CGFloat nameY = HCMCommentCellBorderW;
    
    CGSize nameSize = [comment.Comment_author sizeWithFont:HCMCommentCellNameFont withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};

    /** 时间 */
    CGFloat timeX = cellW - 77;
    CGFloat timeY = HCMCommentCellBorderW;
    CGSize timeSize = [comment.Comment_create sizeWithFont:HCMCommentCellTimeFont withSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};

    /** 正文 */
    CGFloat contentX = HCMCommentCellBorderW;
    CGFloat contentY = 4*HCMCommentCellBorderW;
    CGFloat maxW = cellW - 2 * HCMCommentCellBorderW;
    CGSize contentSize = [comment.Comment_content sizeWithFont:HCMCommentCellContentFont withSize:CGSizeMake(maxW, MAXFLOAT)];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};

    /** 评论整体 */
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalW = cellW;
    CGFloat originalH = CGRectGetMaxY(self.contentLabelF) + HCMCommentCellBorderW;
    
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
    self.cellHeight = CGRectGetMaxY(self.originalViewF);

}










@end
