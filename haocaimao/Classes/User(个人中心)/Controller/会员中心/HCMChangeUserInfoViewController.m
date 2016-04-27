//
//  HCMChangeUserInfoViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/24.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMChangeUserInfoViewController.h"
#import "AddressNerworking.h"


@interface HCMChangeUserInfoViewController ()

@property(nonatomic,strong)NSUserDefaults *defaults;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *sexArray;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phoneNUm;

@property(nonatomic,copy)NSString *sex;

@end

@implementation HCMChangeUserInfoViewController

-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改信息";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];

}

- (void)clickBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)changeTheSex:(UIButton *)sender {
    
    for (UIButton *btn in self.sexArray) {
        btn.selected = NO;
    }
    sender.selected = !sender.selected;
    self.sex = [NSString stringWithFormat:@"%lu",(long)sender.tag];
    
}

- (IBAction)clickOK {
    
    if (!self.sex) {
        [SVProgressHUD showInfoWithStatus:@"请选择性别"];
        return;
    }
    
   
    // 创建警告框实例
    //  3.设置self为alertView的代理方
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"是否立刻提交" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改",nil];
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
    
    if ([title isEqualToString:@"取消"]) {
        
    } else{
        
        //发送修改密码请求
        [self netWorking];
    }
}

-(void)netWorking{
    
    NSString *sid = [self.defaults objectForKey:@"sid"];
    NSString *uid = [self.defaults objectForKey:@"uid"];
    
    NSDictionary *dict = @{@"session":@{@"uid":uid,@"sid":sid},@"sex":self.sex,@"email":self.email.text,@"mobile_phone":self.phoneNUm.text};
    
    [[AddressNerworking sharedManager]postUserInfoURL:dict successBlock:^(id responseBody) {
        
        HCMLog(@"===========%@",responseBody);
        
        if (responseBody[@"status"][@"error_code"]) {
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
        
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:@"修改失败"];

    }];
    
}
@end
