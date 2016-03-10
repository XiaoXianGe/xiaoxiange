//
//  HCMDealModel.m
//  ScrollPageDown_Demo
//
//  Created by 好采猫 on 16/3/2.
//  Copyright © 2016年 LJH. All rights reserved.
//

#import "HCMDealModel.h"

@interface HCMDealModel()

@property(nonatomic)CGFloat changeHeight;
@property(nonatomic)CGFloat cellHeights;

@end

@implementation HCMDealModel

-(CGFloat)CellHeight{
    
    CGFloat newH = 10;
    self.changeHeight = 0;
    self.cellHeights = 0;
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 0;//用来控制button距离父视图的高
    
    for (NSDictionary *dict in (NSArray *)self.specification) {
        
        if (self.changeHeight) {
            self.changeHeight += 28;
            h = self.changeHeight;
        }
        
        
        for (NSDictionary *dict1 in dict[@"value"]) {
            
            //根据计算文字的大小
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
            CGFloat length = [dict1[@"label"] boundingRectWithSize:CGSizeMake(HCMScreenWidth - 20, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10 + w, h + newH + 20  , length+8, 20);
            if (self.cellHeights< button.frame.origin.y) {
                self.cellHeights = button.frame.origin.y;
            }
            self.cellHeights = self.cellHeights< button.frame.origin.y ?(self.cellHeights = button.frame.origin.y):self.cellHeights;

            if(10 + w + length + 10 > HCMScreenWidth){//当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
                w = 0; //换行时将w置为0
                h = h + button.frame.size.height + 8;
                button.frame = CGRectMake(10 + w, h + newH +20 , length+8, 20);//重设button的frame
               
                self.cellHeights = self.cellHeights< button.frame.origin.y ?(self.cellHeights = button.frame.origin.y):self.cellHeights;
            }
            
            w = button.frame.size.width + button.frame.origin.x;
            self.changeHeight = h + newH + 15 ;
        }
        w = 0;
        
    }
    
    
    if (self.cellHeights) {
         return self.cellHeights + 100 +20;
    }else{
        return 100;
    }
    
   
}


@end
