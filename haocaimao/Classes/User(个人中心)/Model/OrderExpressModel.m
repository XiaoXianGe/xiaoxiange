//
//  OrderExpressModel.m
//  haocaimao
//
//  Created by 好采猫 on 16/6/7.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import "OrderExpressModel.h"

@implementation OrderExpressModel
// 正文字体
#define HCMCommentCellContentFont [UIFont systemFontOfSize:15]

-(void)setCellH:(CGFloat)cellH{
//    _cellH = cellH;
    
        CGFloat maxW = HCMScreenWidth - 20;
        
        CGSize contentSize = [_context sizeWithFont:HCMCommentCellContentFont withSize:CGSizeMake(maxW, MAXFLOAT)];
        
        _cellH = contentSize.height + 35;

    
}
@end
