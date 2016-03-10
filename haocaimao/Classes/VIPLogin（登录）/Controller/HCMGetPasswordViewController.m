//
//  HCMGetPasswordViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/17.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMGetPasswordViewController.h"
#import "HCMModification ViewController.h"
#import "AddressNerworking.h"
@interface HCMGetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *security;
@property (strong, nonatomic) NSArray *dataSecurity;
@property (strong, nonatomic) NSMutableString *securityStr;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *goNextBtn;
@property (weak, nonatomic) IBOutlet UIButton *securityBtn;
@property (assign, nonatomic) BOOL phoneSelected;


@end

@implementation HCMGetPasswordViewController
-(NSArray *)dataSecurity{
    if (_dataSecurity==nil) {
        _dataSecurity = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];

    }
    return _dataSecurity;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.selectBtn.selected = NO;
    self.goNextBtn.enabled = NO;
    self.securityBtn.enabled = NO;
}
- (void)setupNavi{
    self.title = @"找回密码";
    UIBarButtonItem *leftBtn = [UIBarButtonItem itemWithTarget:self action:@selector(goBack) image:@"nav-back" highImage:@"nav-back"];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [HCMNSNotificationCenter addObserver:self selector:@selector(securityChange) name:UITextFieldTextDidChangeNotification object:self.security];
    [HCMNSNotificationCenter addObserver:self selector:@selector(phoneNumberChange:) name:UITextFieldTextDidChangeNotification object:self.phoneNumber];
    [HCMNSNotificationCenter addObserver:self selector:@selector(againSMS) name:@"againSMS" object:nil];
}
- (void)securityChange{
    
    
    if ([self.securityStr compare:self.security.text options:NSCaseInsensitiveSearch]==NSOrderedSame&&self.securityStr!=nil&&self.phoneSelected) {
        self.selectBtn.selected = YES;
        self.goNextBtn.enabled = YES;
        [self.goNextBtn setBackgroundColor:[UIColor redColor]];

    }else{
        self.selectBtn.selected = NO;
       [self.goNextBtn setBackgroundColor:[UIColor grayColor]];
    }

}
- (void)phoneNumberChange:(NSNotification *)notification{
    self.phoneSelected = [((UITextField *)notification.object).text length]==11?YES:NO;
    self.securityBtn.enabled = self.phoneSelected;
    if (self.phoneSelected&&self.selectBtn.selected) {
        [self.goNextBtn setBackgroundColor:[UIColor redColor]];
    }
    if (!self.phoneSelected&&self.selectBtn.selected) {
        [self.goNextBtn setBackgroundColor:[UIColor grayColor]];

    }
}
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)acquireImage:(UIButton *)sender {
    [sender setBackgroundColor:HCMRandomColor];
    sender.layer.cornerRadius = 5.0;
    self.securityStr = [[NSMutableString alloc]initWithCapacity:4];
    int32_t count = (int)self.dataSecurity.count-1;
    for (int i = 0; i<4; i++) {
        NSInteger index = arc4random_uniform(count);
        NSString *tempStr = [self.dataSecurity objectAtIndex:index];
        self.securityStr = (NSMutableString*)[self.securityStr stringByAppendingString:tempStr];
    }
    [sender setTitle:self.securityStr forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:20];
    sender.titleLabel.textColor = HCMRandomColor;
}
- (IBAction)goAgain:(UIButton *)sender {
    [self loadSMS];
}
- (void)loadSMS{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *str = self.phoneNumber.text;
    dic[@"mobile"] = str;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:str forKey:@"inserMobile"];
    [[AddressNerworking sharedManager]postinserPasswordURL:dic successBlock:^(id responseBody) {
        
        
        if (responseBody[@"status"][@"error_code"]){
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];

        }else{
            [defaults setObject:responseBody[@"data"][@"code"] forKey:@"inserSMS"];
            HCMModification_ViewController*modification = [[HCMModification_ViewController alloc]initWithNibName:@"HCMModification ViewController" bundle:nil];
            [self.navigationController pushViewController:modification animated:YES];
            [defaults synchronize];
        }
       
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:error];
        
    }];

}
- (void)againSMS{
    [self loadSMS];
   }
- (void)dealloc{
    [HCMNSNotificationCenter removeObserver:self];
}
@end
