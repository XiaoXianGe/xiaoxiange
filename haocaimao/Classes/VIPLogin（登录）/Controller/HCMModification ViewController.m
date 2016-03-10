//
//  HCMModification ViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/17.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMModification ViewController.h"
#import "HCMNewPasswordController.h"
@interface HCMModification_ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *SMSText;
@property (weak, nonatomic) IBOutlet UIButton *goBtn;
@property (weak, nonatomic) IBOutlet UIButton *againBtn;
@property (assign, nonatomic) NSInteger time;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation HCMModification_ViewController
- (NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];

    }
   return _defaults;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _time = 60;
    NSString *str = [self.defaults objectForKey:@"inserMobile"];
    NSRange range = NSMakeRange(3, 4);
    NSString *number = [str stringByReplacingCharactersInRange:range withString:@"xxxx"];
    self.phoneNumber.text =[NSString stringWithFormat:@"已向您的手机:%@发送验证码", number];
    
    [self setupNavi];
    if (_time>=0) {
        
    }
   self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(againTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
   
}
- (void)setupNavi{
    self.title = @"找回密码";
    UIBarButtonItem *leftBtn = [UIBarButtonItem itemWithTarget:self action:@selector(goBack) image:@"nav-back" highImage:@"nav-back"];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
}
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)againTime{
    if (_time>=0) {
        self.timeLabel.text = [NSString stringWithFormat:@"(%lu)后重新获取",(long)_time];
    self.againBtn.enabled = NO;
        _time--;

    }else{
        [self.timer invalidate];
        [self.timeLabel removeFromSuperview];
        [self.againBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        self.againBtn.enabled = YES;
        
        
    }
    
}
- (IBAction)againSMS:(UIButton *)sender {
    [HCMNSNotificationCenter postNotificationName:@"againSMS" object:nil];
}

- (IBAction)goNewPassword:(UIButton *)sender {
   
    NSString *sms = [self.defaults objectForKey:@"inserSMS"];
    if ([sms isEqualToString:self.SMSText.text]) {
        HCMNewPasswordController *newPassword = [[HCMNewPasswordController alloc]initWithNibName:@"HCMNewPasswordController" bundle:nil];
        [self.navigationController pushViewController:newPassword animated:YES];
        
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"验证码错误"];
    }
}

@end
