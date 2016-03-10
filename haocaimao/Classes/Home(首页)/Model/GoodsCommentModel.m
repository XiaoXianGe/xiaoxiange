//
//  GoodsCommentModel.m
//  test
//
//  Created by 李芷贤 on 15/8/31.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "GoodsCommentModel.h"

@implementation GoodsCommentModel

+(id)goodsCommentWithJSON:(NSDictionary *)dic{
    return [[self alloc]initWithGoodsCommentDic:dic];
}

-(id)initWithGoodsCommentDic:(NSDictionary *)dic{
    
    self = [super init];
    
    if (self) {
        
        self.Comment_id = dic[@"id"];
        self.Comment_author = dic[@"author"];
        self.Comment_content = dic[@"content"];
        self.Comment_create = dic[@"create"];
        self.Comment_re_content = dic[@"re_content"];

    }
    return self;
}

@end
