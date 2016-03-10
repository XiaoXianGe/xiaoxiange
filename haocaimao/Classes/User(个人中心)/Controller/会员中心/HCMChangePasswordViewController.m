//
//  HCMChangePasswordViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/13.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMChangePasswordViewController.h"
#import "AddressNerworking.h"
#import "HCMVipLoginViewController.h"



@interface HCMChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;
@property (weak, nonatomic) IBOutlet UITextField *setPassWord;
@property (weak, nonatomic) IBOutlet UITextField *setPassWord2;

@property (strong, nonatomic)NSUserDefaults *defaults;


@end

@implementation HCMChangePasswordViewController
-(NSUserDefaults *)defaults{
    
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    self.oldPassWord.secureTextEntry = YES;
    self.setPassWord.secureTextEntry = YES;
    self.setPassWord2.secureTextEntry = YES;

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

//确定修改
- (IBAction)ChangeThePassword {
    
    [self.oldPassWord resignFirstResponder];
    [self.setPassWord resignFirstResponder];
    [self.setPassWord2 resignFirstResponder];
    
    if ([self.oldPassWord.text length] < 6||[self.setPassWord.text length] < 6||[self.setPassWord2.text length] < 6) {
        [SVProgressHUD showInfoWithStatus:@"密码不能小于6个字节"];
        return;
    }
   
    if(![self.setPassWord.text isEqualToString:self.setPassWord2.text]){
        [SVProgressHUD showInfoWithStatus:@"输入两次密码不同"];
        return;
    }
    
    // 创建警告框实例
    //  3.设置self为alertView的代理方
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"是否立刻提交" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES",nil];
    //设置alertview的样式
    // alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    // 显示警告框
    [alert show];
    
    
}


//第一个参数：代表委托方自己
//第二个参数：委托方发给代理方的一些重要信息
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //根据点击的按钮的index，获取这个按钮的标题
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Cancel"]) {
        
    } else{
        
        //发送修改密码请求
        [self sendChangeThePasswordRequset];
    }
}


-(void)sendChangeThePasswordRequset{
    
    NSString *sid = [self.defaults objectForKey:@"sid"];
    NSString *uid = [self.defaults objectForKey:@"uid"];
    
    NSDictionary *dict = @{@"session":@{@"uid":uid,@"sid":sid},@"oldPassword":self.oldPassWord.text,@"newPassword":self.setPassWord.text};
    
    [[AddressNerworking sharedManager]postChangePassWord:dict successBlock:^(id responseBody) {
        
        if (responseBody[@"status"][@"error_code"]) {
            
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
        
        [self clearUser];
        
        
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:error];
        
    }];
    
}



-(void)clearUser{
    
    [self.defaults setBool:NO forKey:@"status"];
    [self.defaults setObject:nil forKey:@"userName"];
    [self.defaults removeObjectForKey:@"sid"];
    [self.defaults removeObjectForKey:@"uid"];
    [self.defaults synchronize];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLoginOut" object:nil userInfo:nil];
    
    NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie*cookie in [cookieJar cookies]) {
        [cookieJar deleteCookie:cookie];
    }
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    //animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    HCMVipLoginViewController *vipLogin = [[HCMVipLoginViewController alloc]initWithNibName:@"HCMVipLoginViewController" bundle:nil];
        
    [self.navigationController pushViewController:vipLogin animated:YES];
}

@end
