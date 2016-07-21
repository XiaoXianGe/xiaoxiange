//
//  HCMCommentCell.m
//  haocaimao
//
//  Created by 李芷贤 on 15/9/10.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMCommentCell.h"
#import "GoodsCommentModel.h"

#import "GoodsCommentFrame.h"

@interface HCMCommentCell()

/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 评论 */
@property (nonatomic, weak) UIView *originalView;
/** 昵称 */
@property (nonatomic , weak) UILabel *nameLabel;
/** 时间 */
//@property (nonatomic , weak) UILabel *timeLabel;
/** 正文 */
@property (nonatomic , weak) UILabel *contentLabel;

@end

@implementation HCMCommentCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"Comment";
    HCMCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HCMCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        /** 评论 */
        UIView *originalView = [[UIView alloc] init];
        [self.contentView addSubview:originalView];
        self.originalView = originalView;
        
        /** 头像 */
        UIImageView *iconView = [[UIImageView alloc] init];
        [originalView addSubview:iconView];
        self.iconView = iconView;
        
        
        /** 昵称 */
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = HCMCommentCellNameFont;
        [originalView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        /** 时间 */
//        UILabel *timeLabel = [[UILabel alloc] init];
//        timeLabel.font = HCMCommentCellTimeFont;
//        [originalView addSubview:timeLabel];
//        self.timeLabel = timeLabel;
        
        /** 正文 */
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = HCMCommentCellContentFont;
        contentLabel.numberOfLines = 0;
        [originalView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
//        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [self.contentView.superview setTranslatesAutoresizingMaskIntoConstraints:NO];
        
    }
    return self;
}

-(void)setCommentFrame:(GoodsCommentFrame *)CommentFrame{
    
    _CommentFrame = CommentFrame;
    
    /**评论*/
    self.originalView.frame = CommentFrame.originalViewF;
    
    self.iconView.frame = CommentFrame.iconViewF;
    [self.iconView setImage:[UIImage imageNamed:@"log-in-user-name-icon"]];
    
    /**昵称*/
    self.nameLabel.text = CommentFrame.comment.Comment_author;
    self.nameLabel.frame = CommentFrame.nameLabelF;
    
    /**时间*/
//    self.timeLabel.text = [CommentFrame.comment.Comment_create substringToIndex:10];
//    self.timeLabel.frame = CommentFrame.timeLabelF;
    
   //NSString *b = [a substringToIndex:4];
    /**正问*/
    self.contentLabel.text = CommentFrame.comment.Comment_content;
    self.contentLabel.frame = CommentFrame.contentLabelF;
    
}



@end
