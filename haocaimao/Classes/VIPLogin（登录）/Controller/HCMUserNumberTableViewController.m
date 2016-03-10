//
//  HCMUserNumberTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/15.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMUserNumberTableViewController.h"

@interface HCMUserNumberTableViewController ()
@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation HCMUserNumberTableViewController
- (NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
   return _defaults;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"qwe"];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
       return self.number.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"qwe" forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qwe"];
            }
    cell.textLabel.text = self.number[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"log_in_user_name_icon"];

       return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [HCMNSNotificationCenter postNotificationName:@"userNumber" object:nil userInfo:@{@"indexNumber":cell.textLabel.text}];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.number removeObjectAtIndex:indexPath.row];
    [self.defaults removeObjectForKey:[NSString stringWithFormat:@"userNumber%lu",(long)indexPath.row]];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
    
}

@end
