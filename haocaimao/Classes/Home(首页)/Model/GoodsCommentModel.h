//
//  GoodsCommentModel.h
//  test
//
//  Created by 李芷贤 on 15/8/31.
//  Copyright (c) 2015年 itcast. All rights reserved.
//
/**
 *  商品 — — 评论 — — model
 *
 */

#import <Foundation/Foundation.h>

@interface GoodsCommentModel : NSObject

@property (copy , nonatomic) NSString *Comment_id;
@property (copy , nonatomic) NSString *Comment_author;
@property (copy , nonatomic) NSString *Comment_content;
@property (copy , nonatomic) NSString *Comment_create;
@property (copy , nonatomic) NSString *Comment_re_content;

+(id)goodsCommentWithJSON:(NSDictionary *)dic;

@end
