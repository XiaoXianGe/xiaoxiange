//
//  HCMWeChatViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/21.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMWeChatViewController.h"
#import "AddressNerworking.h"
#import "UserViewController.h"
#import "weiXinLoginModel.h"

@interface HCMWeChatViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nUserName;
@property (weak, nonatomic) IBOutlet UITextField *nPassword;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (strong, nonatomic) weiXinLoginModel *model;

@end

@implementation HCMWeChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    
}
- (void)setupNavi{
    self.title = @"用户注册";
    UIBarButtonItem *leftBtn = [UIBarButtonItem itemWithTarget:self action:@selector(goBack) image:@"nav-back" highImage:@"nav-back"];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [HCMNSNotificationCenter addObserver:self selector:@selector(nUserNameChange:) name:UITextFieldTextDidEndEditingNotification object:self.nUserName];
    [HCMNSNotificationCenter addObserver:self selector:@selector(nPasswordChange:) name:UITextFieldTextDidChangeNotification object:self.nPassword];
    }
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)nUserNameChange:(NSNotification *)notification{
    BOOL user = ([((UITextField *)notification.object).text length]>=3)&&([((UITextField *)notification.object).text length]<=12)?YES:NO;
    if (user) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"usernameCheck"] = self.nUserName.text;
        [[AddressNerworking sharedManager]postweiXinUserLogoin:dic successBlock:^(id responseBody) {
          
        
            BOOL b = [responseBody[@"data"][@"exist"] boolValue];
            if (!b) {
                [self.selectedBtn setTitle:@"用户名已被注册" forState:UIControlStateNormal];
            }else{
                [self.selectedBtn setTitle:@"用户名可用" forState:UIControlStateNormal];
            }
            
        } failureBlock:^(NSString *error) {
            [SVProgressHUD showInfoWithStatus:error];
        }];
    }
    else{
        
    }
}
- (void)nPasswordChange:(NSNotification *)notification{
    BOOL password = [((UITextField *)notification.object).text length]>=5&&[((UITextField *)notification.object).text length]<=18?YES:NO;
    if (password==NO) {
        
        self.postBtn.enabled = NO;
    }
    else{
        self.postBtn.enabled = YES;
    }
}
- (IBAction)pose:(UIButton *)sender {
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    
    dic[@"username"] = self.nUserName.text;
    dic[@"password"] = self.nPassword.text;
    dic[@"unionid"] = [defaults objectForKey:@"unionid"];
    
    [[AddressNerworking sharedManager]postweiXinUserLogoin:dic successBlock:^(id responseBody) {
    
    if (responseBody[@"status"][@"error_desc"]) {
        [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
        return;
    }
    
    
    if ([responseBody[@"data"][@"userStatus"] isEqualToString:@"oldUser"] ) {
        
        
        [defaults setObject:responseBody[@"data"][@"userid"] forKey:@"uid"];
        [defaults setObject:responseBody[@"data"][@"sessionId"] forKey:@"sid"];
        [defaults setBool:[responseBody[@"status"][@"succeed"] boolValue] forKey:@"status"];
        [defaults synchronize];
        
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[UserViewController class]]) {
                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                [self.navigationController popToViewController:viewController animated:YES];
                }
            }
        
        }

    } failureBlock:^(NSString *error) {
    
}];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [HCMNSNotificationCenter removeObserver:self];
}

@end
