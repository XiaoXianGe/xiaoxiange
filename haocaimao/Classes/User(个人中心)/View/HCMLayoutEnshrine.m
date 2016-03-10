//
//  HCMLayoutEnshrine.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/1.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMLayoutEnshrine.h"

@implementation HCMLayoutEnshrine

- (id)init{
    self = [super init];
    if (self) {
        //配置参数
        //由于继承自flowLayout,所以才有以下属性，
        //如果继承自UICollectionViewLayout，则没有如下属性
        
        self.itemSize = CGSizeMake(145, 195);
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
        //分区间的内边距
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        // 滚动方向
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}
@end
