//
//  HCMVipRegisteredTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/28.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMVipRegisteredTableViewController.h"

#import "HCMVipLoginViewController.h"

#import "AddressNerworking.h"

@interface HCMVipRegisteredTableViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *passwordCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *userNameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *passwordsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *phoneCell;

@property (weak, nonatomic) IBOutlet UILabel *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passwords;
@property (weak, nonatomic) IBOutlet UITextField *email;

@property (strong, nonatomic)NSUserDefaults *defaults;

@end

@implementation HCMVipRegisteredTableViewController

-(NSUserDefaults *)defaults{
    
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"免费注册";
    
    self.phoneText.text = self.userPhone;
    self.tabBarController.tabBar.hidden = YES;
    
    self.password.delegate = self;
    self.passwords.delegate = self;
    self.userName.delegate = self;
    self.email.delegate =self;
    
     self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickRegister) image:@"nav-register" highImage:@"nav-register"];
    
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"nav-cancel" highImage:@"nav-cancel"];
    
}

// 点击了注册  各种判断 有值 才可以注册
- (void)clickRegister{
    
    if ([self.userName.text length] < 6) {
        [SVProgressHUD showInfoWithStatus:@"帐号不能小于6个字节"];
        return;
    }
    
    if (![self.email.text hasSuffix:@".com"]) {
        [SVProgressHUD showInfoWithStatus:@"邮箱格式不正确"];
        return;
    }
    
    if ([self.password.text length] < 6) {
        [SVProgressHUD showInfoWithStatus:@"密码不能小于6个字节"];
        return;
    }
    
    if ([self.passwords.text length] < 6) {
        [SVProgressHUD showInfoWithStatus:@"密码不能小于6个字节"];
        return;
    }
    
    if (![self.password.text isEqualToString:self.passwords.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次密码不同"];
        return;
    }
    
    NSDictionary *dict = @{@"email":self.email.text,@"password":self.password.text,@"name":self.userName.text,@"mobile_phone":self.userPhone,@"field":@[]};
    
    [SVProgressHUD show];
    
    [[AddressNerworking sharedManager]postUserSignup:dict successBlock:^(id responseBody) {
        
        if (responseBody[@"status"][@"error_code"]) {
            
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            
            return ;
            
        }else{
            
             NSDictionary *dict  = @{@"name":self.userName.text,@"password":self.password.text};
            
            NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie*cookie in [cookieJar cookies]) {
                [cookieJar deleteCookie:cookie];
            }
            
            [[AddressNerworking sharedManager]postUserLogoin:dict successBlock:^(id responseBody) {
                
            [self.defaults setObject:responseBody[@"data"][@"session"][@"uid"] forKey:@"uid"];
            [self.defaults setObject:responseBody[@"data"][@"session"][@"sid"] forKey:@"sid"];
            [self.defaults setObject:self.userName.text forKey:@"userName"];
            [self.defaults setBool:YES forKey:@"status"];
            [self.defaults synchronize];
                
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
                
            } failureBlock:^(NSString *error) {
            
            }];
        }
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:@"网络错误"];
    }];
    
}

- (void)back{
    
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return self.userNameCell;
        case 1:
            return self.phoneCell;
        case 2:
            return self.emailCell;
        case 3:
            return self.passwordCell;
        case 4:
            return self.passwordsCell;
        default:
            return nil;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {  // 这个方法是UITextFieldDelegate协议里面的
    [theTextField resignFirstResponder]; //这句代码可以隐藏 键盘
    
    return YES;
}
@end
