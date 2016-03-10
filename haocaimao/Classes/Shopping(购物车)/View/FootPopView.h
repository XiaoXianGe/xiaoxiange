//
//  FootPopView.h
//  haocaimao
//
//  Created by 好采猫 on 15/11/17.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FootCollectionView.h"


@interface FootPopView : UIView
@property (weak, nonatomic) FootCollectionView *fool;
@property (strong, nonatomic) NSMutableArray *goods;

-(void)showFoolView;
@end
