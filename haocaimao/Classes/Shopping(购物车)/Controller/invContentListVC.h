//
//  invContentListVC.h
//  haocaimao
//
//  Created by 好采猫 on 15/9/17.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//  发票

#import <UIKit/UIKit.h>

@class invContentListVC;

@protocol InvContentListVCDelegate <NSObject>

- (void)setInvContent:(invContentListVC *)invContent dictData:(NSDictionary *)dict;

@end


@interface invContentListVC : UIViewController

@property (nonatomic, weak)id<InvContentListVCDelegate> delegate;

@end
