//
//  HCMHelpTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/7.
//  Copyright © 2015年 haocaimao. All rights reserved.
//  帮助

#import "HCMHelpTableViewController.h"
#import "UserClassitfTableViewController.h"

#import "UserModel.h"

@interface HCMHelpTableViewController ()

@property(strong,nonatomic)NSArray *helpArray;
@property (strong, nonatomic)UserClassitfTableViewController *userClassVC;

@end

@implementation HCMHelpTableViewController

-(NSArray *)helpArray{
    if (!_helpArray) {
        UserModel *model = [UserModel parseUserData];
        _helpArray =  model.userData;
    }
    return _helpArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帮助";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"nav-back" highImage:@"nav-back"];
    
    self.tableView.tableFooterView = [UIView new];
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.helpArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.helpArray[indexPath.section];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.userClassVC = [[UserClassitfTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    self.userClassVC.className = self.helpArray[indexPath.section];
    
    [self.navigationController pushViewController:self.userClassVC animated:YES];
}
@end
