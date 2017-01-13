//
//  HCMVipLoginViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/28.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMVipLoginViewController.h"
#import "HCMGetPasswordViewController.h"
#import "UserViewController.h"

#import "HCMValidationRegisteredVC.h"
#import "HCMUserNumberTableViewController.h"
#import "HCMVIPUserModel.h"

#import "weiXinData.h"
#import "AddressNerworking.h"
#import "MBProgressHUD+MJ.h"
#import "HCMWeChatViewController.h"


@interface HCMVipLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *memoryNumber;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) weiXinLoginModel *model;
@property (strong, nonatomic) weiXinData *data;
@property (strong, nonatomic) HCMUserNumberTableViewController *userNumber;

@property (nonatomic, strong)NSUserDefaults *defaults;

@end

@implementation HCMVipLoginViewController

- (HCMUserNumberTableViewController *)userNumber
{
    if (!_userNumber) {
        _userNumber = [[HCMUserNumberTableViewController alloc]init];
        CGRect frame = self.userName.frame;
        _userNumber.view.frame = CGRectMake(0, frame.size.height+frame.origin.y
                                     , HCMScreenWidth, 40);
        _userNumber.number = [NSMutableArray array];

        [self.view addSubview:_userNumber.tableView];
        
    }
    return _userNumber;
}

-(weiXinData *)data
{
    if (_data==nil) {
        _data = [[weiXinData alloc]init];
    }
   return _data;
}

-(NSUserDefaults *)defaults
{
    
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [HCMNSNotificationCenter addObserver:self selector:@selector(clickUser:) name:@"userNumber" object:nil];
    [HCMNSNotificationCenter addObserver:self selector:@selector(weChatLogin) name:@"weChatLogin" object:nil];
    [HCMNSNotificationCenter addObserver:self selector:@selector(weChatLoginNew) name:@"weChatLoginNew" object:nil];

    [HCMNSNotificationCenter addObserver:self selector:@selector(userNameEditorial) name:UITextFieldTextDidBeginEditingNotification object:self.userName];
    [HCMNSNotificationCenter addObserver:self selector:@selector(userNameChange) name:UITextFieldTextDidChangeNotification object:self.userName];
    [HCMNSNotificationCenter addObserver:self selector:@selector(passwordChange:) name:UITextFieldTextDidChangeNotification object:self.password];
        self.title = @"用户登录";
    self.userName.delegate = self;
    self.password.delegate = self;
    self.userName.clipsToBounds = YES;
    self.password.secureTextEntry = YES;
    self.loginBtn.enabled = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"nav-cancel" highImage:@"nav-cancel"];
    self.navigationController.navigationBarHidden = NO;

    
}

- (void)weChatLogin
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)passwordChange:(NSNotification *)notification
{
    self.loginBtn.enabled = ([((UITextField *)notification.object).text length]>=5)&& ([((UITextField *)notification.object).text length]<=18);
}

- (void)userNameEditorial
{
    [self deleteHCMTableView];

}

- (void)userNameChange
{
    [self deleteHCMTableView];

}

- (void)clickUser:(NSNotification *)notification
{
    self.userName.text = notification.userInfo[@"indexNumber"];
    [self deleteHCMTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    if ([self.defaults objectForKey:@"userNumber0"]||[self.defaults objectForKey:@"userNumber1"]||[self.defaults objectForKey:@"userNumber2"]) {
        self.memoryNumber.hidden = NO;
    }else{
        self.memoryNumber.hidden = YES;
    }
    
    [SVProgressHUD dismiss];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    
}

/**
 *  用户登录
 */
- (IBAction)userLogin:(UIButton *)sender {
    
    if (![self.userName.text length] && ![self.password.text length]) {
        
        [MBProgressHUD showError:@"帐号密码不能为空"];
        
    }else{
        
        [self.view endEditing:YES];
        [MBProgressHUD showMessage:@"正在登录"];
        
        //随机生成32位字符串
//        NSString *IPStr = [self ret32bitString];
        
        NSMutableDictionary *mutabDict = [NSMutableDictionary dictionary];
        mutabDict[@"name"] = self.userName.text;
        mutabDict[@"password"] = self.password.text;
//      mutabDict[@"APPIP"] = IPStr;
        
        [[AddressNerworking sharedManager] postUserLogoin:mutabDict successBlock:^(id responseBody) {
        [MBProgressHUD hideHUD];
            
            HCMLog(@"%@",responseBody);
            
            if (responseBody[@"status"][@"error_code"]) {
                
                [MBProgressHUD showError:responseBody[@"status"][@"error_desc"]];
            
                return ;
                
            }else{
                
                NSString *str = [self.defaults objectForKey:@"userNumber0"];
                NSString *str2 = [self.defaults objectForKey:@"userNumber1"];
                NSString *str3 = [self.defaults objectForKey:@"userNumber3"];
                
                if (str==nil || (str2!=nil&&str3!=nil)) {
                    [self.defaults setObject:self.userName.text forKey:@"userNumber0"];
                }
                else if((str2==nil&&![self.userName.text isEqualToString:[self.defaults objectForKey:@"userNumber0"]]) || (str!=nil&&str3!=nil)){
                    [self.defaults setObject:self.userName.text forKey:@"userNumber1"];
                    
                }else if((str3==nil&&![self.userName.text isEqualToString:[self.defaults objectForKey:@"userNumber0"]]&&![self.userName.text isEqualToString:[self.defaults objectForKey:@"userNumber1"]]) || (str2!=nil&&str!=nil)){
                    [self.defaults setObject:self.userName.text forKey:@"userNumber3"];
                    
                }
                [self.defaults synchronize];
                
               [SVProgressHUD showSuccessWithStatus:nil];
                
                NSString *uid = responseBody[@"data"][@"session"][@"uid"];
                NSString *sid = responseBody[@"data"][@"session"][@"sid"];
                
                [self.defaults setObject:uid forKey:@"uid"];
                [self.defaults setObject:sid forKey:@"sid"];
                
                [self.defaults setObject:self.userName.text forKey:@"userName"];
                [self.defaults setObject:responseBody[@"data"][@"user"][@"realName"] forKey:@"realName"];
                
                [self.defaults setBool:YES forKey:@"status"];
                [self.defaults synchronize];
                    
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
                    
            }
            
        } failureBlock:^(NSString *error) {
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络有问题"];
            
        }];
    }
}

///**
// *  随机生成32位字符串
// */
//-(NSString *)ret32bitString{
//    
//    char data[32];
//    
//    for (int x=0;x<10;data[x++] = (char)('A' + (arc4random_uniform(26))));
//    
//    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
//}

/**
 *  返回
 */
- (void)back{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  注册新用户
 *
 */
- (IBAction)registeringNewUser:(UIButton *)sender
{
    
     HCMValidationRegisteredVC  *VRVC = [[HCMValidationRegisteredVC alloc]initWithNibName:@"HCMValidationRegisteredVC" bundle:nil];
    [self.navigationController pushViewController:VRVC animated:YES];
    
}

- (IBAction)userNumber:(UIButton *)sender
{
   BOOL number = sender.selected = !sender.selected;
    if (number) {
        [self addUserNumber];
        
        [self addChildViewController:self.userNumber];
    }else{
        [self deleteHCMTableView];
    }

}

- (void)addUserNumber
{
    if ([self.defaults objectForKey:@"userNumber0"]!=nil) {
        [self.userNumber.number addObject:[self.defaults objectForKey:@"userNumber0"]];

    }
    
    if ([self.defaults objectForKey:@"userNumber1"]!=nil) {
        [self.userNumber.number addObject:[self.defaults objectForKey:@"userNumber1"]];
        
    }if ([self.defaults objectForKey:@"userNumber2"]!=nil) {
        [self.userNumber.number addObject:[self.defaults objectForKey:@"userNumber2"]];
        
    }
    [self.userNumber.tableView reloadData];
    

}

- (void)deleteHCMTableView
{
    [self.userNumber.view removeFromSuperview];
    self.userNumber = nil;
    self.memoryNumber.selected = NO;
}

- (IBAction)passwordLook:(UIButton *)sender
{
    self.password.secureTextEntry = YES;

     BOOL lock = sender.selected = !sender.selected;
    if (lock) {
        self.password.secureTextEntry = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{  // 这个方法是UITextFieldDelegate协议里面的
    [theTextField resignFirstResponder]; //这句代码可以隐藏 键盘
    return YES;
}

- (IBAction)getPassword:(UIButton *)sender
{
    HCMGetPasswordViewController *getPassword = [[HCMGetPasswordViewController alloc]initWithNibName:@"HCMGetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:getPassword animated:YES];
}

//微信登录按钮
- (IBAction)weixin:(id)sender
{

    [self sendAuthReq];

}
//微信授权登陆
- (void)sendAuthReq
{
   
    SendAuthReq *req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_base,snsapi_userinfo";
    req.state = @"HCM";
    [WXApi sendAuthReq:req viewController:self delegate:self.data];
}//发送授权请求


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self deleteHCMTableView];
    [self.view endEditing:YES];
}

//询价推出的vipView，左上角的按钮
- (IBAction)ViPLoginPresentAndDismiss
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)weChatLoginNew
{
    
    HCMWeChatViewController *weChat = [[HCMWeChatViewController alloc]initWithNibName:@"HCMWeChatViewController" bundle:nil];
    [self.navigationController pushViewController:weChat animated:YES];
    
}

-(void)dealloc
{
    [HCMNSNotificationCenter removeObserver:self];
}
@end
