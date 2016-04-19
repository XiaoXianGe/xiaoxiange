//
//  HCMNoPayHeadview.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/10.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMNoPayHeadview.h"

@interface HCMNoPayHeadview ()

@property (weak, nonatomic) IBOutlet UIImageView *testView;

@end

@implementation HCMNoPayHeadview

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.testView.frame = CGRectMake(0, 0, HCMScreenWidth, 44);
    
}



@end
