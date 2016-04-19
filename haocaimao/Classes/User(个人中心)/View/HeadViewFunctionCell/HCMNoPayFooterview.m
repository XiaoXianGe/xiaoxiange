//
//  HCMNoPayFooterview.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/9.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMNoPayFooterview.h"

@interface HCMNoPayFooterview ()
@property (weak, nonatomic) IBOutlet UIImageView *footerView;

@end

@implementation HCMNoPayFooterview


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.footerView.frame = CGRectMake(0, 0, HCMScreenWidth, 44);
    
}

@end
