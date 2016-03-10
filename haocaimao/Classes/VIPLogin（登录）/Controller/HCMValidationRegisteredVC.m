//
//  HCMValidationRegisteredVC.m
//  haocaimao
//
//  Created by 好采猫 on 15/10/19.
//  Copyright © 2015年 haocaimao. All rights reserved.
//
//  短信验证

#import "HCMValidationRegisteredVC.h"
#import "HCMVipRegisteredTableViewController.h"

#import "AddressNerworking.h"

@interface HCMValidationRegisteredVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *validationRText;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic) NSString *validation;
@property (strong, nonatomic) UILabel *timerLbael;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation HCMValidationRegisteredVC

{
    int _count;
}

static NSString *const url = @"http://www.haocaimao.com/ecmobile/?url=user/regmsm";

// 倒计时label
- (UILabel *)timerLbael{
    if (!_timerLbael) {
        _timerLbael = [[UILabel alloc]initWithFrame:self.sendBtn.frame];
        [_timerLbael setFont:[UIFont systemFontOfSize:16]];
        [_timerLbael setTextColor:[UIColor whiteColor]];
        [_timerLbael setTextAlignment:NSTextAlignmentCenter];
    }
    return _timerLbael;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"短信验证";
    
    self.sendBtn.reversesTitleShadowWhenHighlighted = YES;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"nav-cancel" highImage:@"nav-cancel"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.phoneText];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(validationRTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.validationRText];
}

// 输入监听 手机号码必须为11位数
- (void)phoneTextDidChange:(NSNotification *)notification{
    
    self.sendBtn.enabled = (11 == [((UITextField *)notification.object).text length]);
    
}
// 输入监听 验证号码必须6位数
- (void)validationRTextDidChange:(NSNotification *)notification{
    
    self.confirmBtn.enabled = (6 == [((UITextField *)notification.object).text length]);
}

- (void)back{
    
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 点击发送验证码
- (IBAction)clickSendMsg:(UIButton *)sender {
    
    NSDictionary *dict = @{@"mobile":self.phoneText.text};
    
    [SVProgressHUD show];
    sender.enabled = NO;
    [[AddressNerworking sharedManager]postUserRegmsm:dict url:url successBlock:^(NSDictionary *responseBody) {
        
        if (responseBody[@"status"][@"error_code"]) {
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            sender.enabled = YES;
            return ;
        }
        
    [SVProgressHUD showSuccessWithStatus:nil];
        
    self.validation = responseBody[@"data"][@"code"];
    self.validationRText.enabled = YES;
    //[sender setTitle:nil forState:UIControlStateNormal];
        
        [self.sendBtn setTitle:@"" forState:UIControlStateNormal];
       
    self.timerLbael.text = @"60秒后重发";
        self.timerLbael.textColor = [UIColor blackColor];
    [self.view addSubview:self.timerLbael];
    _count = 60;
     self.sendBtn.hidden = YES;
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(sendMsging:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    } failureBlock:^(NSString *error) {
        sender.enabled = YES;
        [SVProgressHUD showInfoWithStatus:@"网络错误"];
    }];
    
}

// 开启定时器 过期后 字体改变
- (void)sendMsging:(NSTimer *)timer{
    _count--;
    
    NSString *string = [NSString stringWithFormat:@"重发(%ds)",_count];
    self.timerLbael.text = string;
    if (_count == 0) {
        [self.timerLbael removeFromSuperview];
        self.sendBtn.hidden = NO;
        [self.sendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        self.sendBtn.enabled = YES;
        [timer invalidate];
    }
    
}

// 点击 确认验证码
- (IBAction)clickConfirmMsg:(UIButton *)sender {
    
    if ([self.validation isEqualToString:self.validationRText.text]) {
       
        self.validationRText.text = nil;
        self.validationRText.enabled = NO;
        self.sendBtn.enabled = NO;
        [self.sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.confirmBtn.enabled = NO;
        [self.timer invalidate];
        
        HCMVipRegisteredTableViewController *VipRTV = [[HCMVipRegisteredTableViewController  alloc]initWithNibName:@"HCMVipRegisteredTableViewController" bundle:nil];
        VipRTV.userPhone = self.phoneText.text;
        
        [self.navigationController pushViewController:VipRTV animated:YES];
        
         self.phoneText.text = nil;
    }else{
        [SVProgressHUD showInfoWithStatus:@"验证码有误"];
    }
    
   
}

// 取消所以监听事件 主要是2个输入框的监听
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
