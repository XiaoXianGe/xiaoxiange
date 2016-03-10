//
//  HCMChooseViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/10/15.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMChooseViewController.h"
#import "HCMSubCollectionViewController.h"
@interface HCMChooseViewController ()

@end

@implementation HCMChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"使用场景";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

-(void)clickBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)chooseScene:(UIButton *)sender {
    
    int tag = sender.tag%90;
    NSArray *arr = @[@"21",@"28",@"27",@"25",@"24",@"26",@"22",@"23",@"20"];
    HCMSubCollectionViewController *vc = [[HCMSubCollectionViewController alloc]initWithNibName:@"HCMSubCollectionViewController" bundle:nil];
    
    vc.urlStr = arr[tag];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


@end
