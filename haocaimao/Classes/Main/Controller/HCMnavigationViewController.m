//
//  HCMnavigationViewController.m
//  好采猫
//
//  Created by 好采猫 on 15/8/8.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//
// RGB颜色

#import "DealViewController.h"
#import "HCMnavigationViewController.h"

@interface HCMnavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation HCMnavigationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.interactivePopGestureRecognizer.delegate = self;
   
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    
    [super pushViewController:viewController animated:animated];
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
//    if (self.childViewControllers.count== 1) {
//        
//        HCMLog(@"...");
//        return NO;
//    }
    //手势返回
    return self.childViewControllers.count> 1;
}
@end
