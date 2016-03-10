//
//  HCMNewPasswordController.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/18.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMNewPasswordController.h"
#import "AddressNerworking.h"
#import "HCMVipLoginViewController.h"
@interface HCMNewPasswordController ()
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UITextField *PasswordText;

@end

@implementation HCMNewPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupTextField];
}
- (void)setupNavi{
    self.title = @"找回密码";
    UIBarButtonItem *leftBtn = [UIBarButtonItem itemWithTarget:self action:@selector(goBack) image:@"nav-back" highImage:@"nav-back"];
    self.navigationItem.leftBarButtonItem = leftBtn;
     [HCMNSNotificationCenter addObserver:self selector:@selector(newPasswordTextChange:) name:UITextFieldTextDidChangeNotification object:self.PasswordText];
    
}
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupTextField{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"padlock_open"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"padlock_off"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(lookPassword:) forControlEvents:UIControlEventTouchUpInside];
    self.PasswordText.rightViewMode = UITextFieldViewModeAlways;
    self.PasswordText.rightView = btn;
}
- (void)lookPassword:(UIButton *)boolBtn{
  BOOL selectedTextField =  boolBtn.selected = !boolBtn.selected;
    self.PasswordText.secureTextEntry = selectedTextField;
    
}
- (void)newPasswordTextChange:(NSNotification *)notification{
    self.okBtn.enabled = [((UITextField *)notification.object).text length]>=6&&[((UITextField *)notification.object).text length]<=20?YES:NO;
    if (self.okBtn.enabled == YES) {
        [self.okBtn setBackgroundColor:[UIColor redColor]];
    }else{
        [self.okBtn setBackgroundColor:[UIColor grayColor]];

    }
}
- (IBAction)ok:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
   dic[@"mobile"] = [defaults objectForKey:@"inserMobile"];
    dic[@"new_password"] = self.PasswordText.text;
    [[AddressNerworking sharedManager]postinserNewPassword:dic successBlock:^(id responseBody) {
        if (responseBody) {
            
            for (UIViewController *login in self.navigationController.viewControllers) {
                if ([login isKindOfClass:[HCMVipLoginViewController class]]) {
                     [self.navigationController popToViewController:login animated:YES];
                }
            }
            [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
           
        }
        
    } failureBlock:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:error];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
