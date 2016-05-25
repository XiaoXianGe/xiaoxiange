//
//  HCMHomeTopViewController.h
//  haocaimao
//
//  Created by 好采猫 on 15/10/11.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCMHomeTopViewController;

@protocol HCMHomeTopViewControllerDelegate <NSObject>

-(void)touchClickPrassCategory:(HCMHomeTopViewController *)mothed tag:(NSString *)tag number:(NSInteger)number;

-(void)touchClickToScene:(HCMHomeTopViewController *)delegate url:(NSString *)url;

-(void)touchClickToBanner:(HCMHomeTopViewController *)delegate goodsID:(NSString *)goodsID;
-(void)touchClickToAdvertise:(HCMHomeTopViewController *)delegate goodsID:(NSString *)goodsID;
/** 申请成为合伙人 button */
-(void)gotoPartnerCenter:(HCMHomeTopViewController *)delegate;

-(void)touchGBTopLineView:(id)type title:(id)title;

@end

@interface HCMHomeTopViewController : UIViewController

@property(weak,nonatomic)id<HCMHomeTopViewControllerDelegate> delegate;

@end
