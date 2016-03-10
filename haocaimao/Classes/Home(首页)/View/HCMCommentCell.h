//
//  HCMCommentCell.h
//  haocaimao
//
//  Created by 李芷贤 on 15/9/10.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsCommentFrame;

@interface HCMCommentCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)GoodsCommentFrame *CommentFrame;

@end
