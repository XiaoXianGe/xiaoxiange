//
//  HCMTabBarViewController.m
//  好采猫
//
//  Created by 好采猫 on 15/8/4.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMTabBarViewController.h"

#import "SearchViewController.h"
#import "HCMShoppingTableViewController.h"
#import "HCMnavigationViewController.h"
#import "UserViewController.h"
#import "HomeNetwork.h"

#import "HCMHomeCollectionViewController.h"
#import "DealViewController.h"
#import "HCMTabBar.h"

// RGB颜色
// 随机色



@interface HCMTabBarViewController ()

@property(strong,nonatomic)NSString *numberBadgeValue;

@end

@implementation HCMTabBarViewController

-(HCMShoppingTableViewController *)shopping{
    if (!_shopping) {
        _shopping = [[HCMShoppingTableViewController alloc]init];
    }
    return _shopping;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    HCMHomeCollectionViewController *Home = [[HCMHomeCollectionViewController alloc]initWithNibName:@"HCMHomeCollectionViewController" bundle:nil];
    [self addchildVc:Home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home"];
    
    SearchViewController *search = [[SearchViewController alloc]init];
    [self addchildVc:search title:@"分类搜索" image:@"tabbar_search" selectedImage:@"tabbar_search"];
    
    
    [self addchildVc:self.shopping title:@"购物车" image:@"tabbar_shopping" selectedImage:@"tabbar_shopping"];
    
    UserViewController *personal = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
    [self addchildVc:personal title:@"我" image:@"tabbar_user" selectedImage:@"tabbar_user"];
    
    [self setValue:[[HCMTabBar alloc]init] forKeyPath:@"tabBar"];
    
    
    //改变tabbar的高度
//    self.tabBar.y = self.view.height - 45;
//    self.tabBar.height = 45;
//    
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
//    backView.backgroundColor = HCMColor(56, 56, 56,1.0);
//    [self.tabBar insertSubview:backView atIndex:0];
//
    
}

-(void)addchildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    
    childVc.title = title;
    childVc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);

    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   // childVc.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 1, 0, -1);

    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
//    UITabBarItem *item = [UITabBarItem appearance];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    
    HCMnavigationViewController *nav = [[HCMnavigationViewController alloc]initWithRootViewController:childVc];
    nav.navigationBar.barTintColor = HCMColor(235, 3, 21,1.0);
    
    [self addChildViewController:nav];
    
   
}



@end
