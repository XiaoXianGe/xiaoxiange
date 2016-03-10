//
//  CollectionViewCell.h
//  haocaimao
//
//  Created by 好采猫 on 15/10/14.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCategoryCellModel.h"





@interface CollectionViewCell : UICollectionViewCell

@property(strong,nonatomic)HomeCategoryCellModel *categoryModel;

@property(strong,nonatomic)NSString *goods_id;

@end
