//
//  HCMUserInfoViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/24.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMUserInfoViewController.h"
#import "AddressNerworking.h"
#import "HCMChangeUserInfoViewController.h"

@interface HCMUserInfoViewController ()

@property(nonatomic,strong)NSUserDefaults *defaults;



@property (weak, nonatomic) IBOutlet UILabel *sex;

@property (weak, nonatomic) IBOutlet UILabel *Email;

@property (weak, nonatomic) IBOutlet UILabel *mobile_phone;

@end

@implementation HCMUserInfoViewController

-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults =  [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"个人信息";
    
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self netWorking];
    
}


- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)netWorking{
    
    NSString *uid = [self.defaults objectForKey:@"uid"];
    NSString *sid = [self.defaults objectForKey:@"sid"];
    
    NSDictionary *dict = @{@"session":@{@"uid":uid,@"sid":sid}};
    
    [[AddressNerworking sharedManager]postUserInfoURL:dict successBlock:^(id responseBody) {
        
        [SVProgressHUD showSuccessWithStatus:nil];
        
        self.sex.text = [self whatAreYouIs:responseBody[@"data"][@"sex"]];
        self.Email.text = responseBody[@"data"][@"email"];
        self.mobile_phone.text = responseBody[@"data"][@"mobile_phone"];
                
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:@"加载失败"];
    }];
    
}

-(NSString *)whatAreYouIs:(NSString *)sex{
    NSString *Sex = [[NSString alloc]init];
    if ([sex isEqualToString:@"0"]) {
        Sex = @"匿名";
    }else if([sex isEqualToString:@"1"]){
        Sex = @"男";
    }else if([sex isEqualToString:@"2"]){
        Sex = @"女";
    }
    return Sex;
}

- (IBAction)changeTheInfo {
    
    HCMChangeUserInfoViewController  *vc = [[HCMChangeUserInfoViewController alloc]initWithNibName:@"HCMChangeUserInfoViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
