//
//  SceneCollectionViewCell.h
//  haocaimao
//
//  Created by 好采猫 on 15/10/15.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneCollectionViewCell : UICollectionViewCell

@property(strong,nonatomic)NSString *goods_id;
@property (weak, nonatomic) IBOutlet UIImageView *good_Image;
@property (weak, nonatomic) IBOutlet UILabel *good_Name;

@property (weak, nonatomic) IBOutlet UILabel *shop_price;


@end
