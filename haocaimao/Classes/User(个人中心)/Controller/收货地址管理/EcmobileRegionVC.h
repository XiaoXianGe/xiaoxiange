//
//  EcmobileRegionVC.h
//  adderleDemo
//
//  Created by 好采猫 on 15/10/13.
//  Copyright © 2015年 haocaimao. All rights reserved.
//  地址 三级 区域选在

#import <UIKit/UIKit.h>

@class EcmobileRegionVC;

@protocol EcmobileRegionViewControllerDelegate <NSObject>

-(void)EcmobileRegionDidChanged:(EcmobileRegionVC *)ecmobileRegionVC
                    withMessage:(NSString *)msg andID:(NSString *)msgID;

@end


@interface EcmobileRegionVC : UIViewController

@property(nonatomic,weak)id<EcmobileRegionViewControllerDelegate> delegate;

@end
