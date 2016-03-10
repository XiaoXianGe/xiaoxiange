//
//  UserClassitfTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/26.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//  主页的6个 关于  会员服务 于 售后服务的 web 页面展示

#import "UserClassitfTableViewController.h"
#import "UserModel.h"

#import "HCMWebViewController.h"
@interface UserClassitfTableViewController ()

@property (nonatomic, strong)NSArray *classArray;

@property (nonatomic, strong)HCMWebViewController *webViewVC;

@end

@implementation UserClassitfTableViewController


static NSString * const reuseIdentifier = @"MyCell";

-(NSArray *)classArray{
    if (!_classArray) {
          UserModel *model = [UserModel parseUserClassifyData:self.className];
        _classArray = model.userClassifyData;
    }
    return _classArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = self.className;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.classArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.classArray[indexPath.section];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.webViewVC = [[HCMWebViewController alloc]initWithNibName:@"HCMWebViewController" bundle:nil];
    self.webViewVC.titleName = self.classArray[indexPath.section];
    
    [self.navigationController pushViewController:self.webViewVC animated:YES];
}

@end
