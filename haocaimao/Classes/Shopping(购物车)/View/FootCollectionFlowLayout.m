//
//  FootCollectionFlowLayout.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/16.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "FootCollectionFlowLayout.h"

@implementation FootCollectionFlowLayout
- (instancetype)init{
   self = [super init];
    if (self) {
        
//        self.itemSize = CGSizeMake(105, 150);
        self.itemSize = CGSizeMake(125, 178);

        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
        self.sectionInset = UIEdgeInsetsMake(5, 7, 5, 7);
        //分区间的内边距
        
        // 滚动方向
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}
@end
