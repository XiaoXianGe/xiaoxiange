//
//  invContentListVC.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/17.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//  发票

#import "invContentListVC.h"

@interface invContentListVC ()<UITextFieldDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/** 普通发票勾 */
@property (weak, nonatomic) IBOutlet UIImageView *invCommonImg;
/** 增值税发票勾 */
@property (weak, nonatomic) IBOutlet UIImageView *invAdded;
/** 明细勾 */
@property (weak, nonatomic) IBOutlet UIImageView *carefulImg;
/** 发票抬头textField */
@property (weak, nonatomic) IBOutlet UITextField *invTitel;
/** 单位名称 */
@property (weak, nonatomic) IBOutlet UITextField *EntityName;
/** 纳税人识别码 */
@property (weak, nonatomic) IBOutlet UITextField *taxpayerNumber;
/** 注册地址 */
@property (weak, nonatomic) IBOutlet UITextField *registeredAddress;
/** 注册电话 */
@property (weak, nonatomic) IBOutlet UITextField *registeredNumber;
/** 开户银行 */
@property (weak, nonatomic) IBOutlet UITextField *bank;
/** 银行账号 */
@property (weak, nonatomic) IBOutlet UITextField *bankNumber;

/** 增值税发票内容填写View */
@property (weak, nonatomic) IBOutlet UIView *INVView;

/** 明细填写View */
@property (weak, nonatomic) IBOutlet UIView *careFulView;
/** 发票抬头View */
@property (weak, nonatomic) IBOutlet UIView *INVHeart;

/** 单位名称 */
@property (weak, nonatomic) IBOutlet UITextField *inv_name;
/** 纳税人识别码 */
@property (weak, nonatomic) IBOutlet UITextField *inv_verify;
/** 注册地址 */
@property (weak, nonatomic) IBOutlet UITextField *inv_address;
/** 注册电话 */
@property (weak, nonatomic) IBOutlet UITextField *inv_tel;
/** 注册银行 */
@property (weak, nonatomic) IBOutlet UITextField *inv_bank;
/** 银行帐号 */
@property (weak, nonatomic) IBOutlet UITextField *inv_bankuser;




@end

@implementation invContentListVC
// 选择发票 种类
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"发票";
    
    self.invTitel.delegate = self;
    self.scrollView.delegate = self;
    [self setUpScrollView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickSave) image:@"nav-complete" highImage:@"nav-complete"];
    
}

-(void)setUpScrollView{
    
    _scrollView.frame = CGRectMake(0, 0, 320, 600);
    _scrollView.contentSize = CGSizeMake(320, 666);
    //_scrollView.bounces = NO; // 去除弹簧效果
    //_scrollView.showsHorizontalScrollIndicator = NO;
    //scrollView.delegate = self;
    
}

//发票选项
- (void)clickSave{
    
    if (self.invCommonImg.hidden && self.invAdded.hidden) {
        [SVProgressHUD showInfoWithStatus:@"请选择发票类型"];
        return;
    }
    
    NSDictionary *dict = [NSDictionary dictionary];
    
    if (self.invAdded.hidden) {//普通发票 的情况
         HCMLog(@"普通发票");
        if (self.invTitel.text.length > 0 ) {
            
            NSString *inv_type = @"普通发票";
            NSString *inv_payee = self.invTitel.text;
            NSString *inv_content = @"明细";
            dict = @{@"inv_type":inv_type,@"inv_content":inv_content,@"inv_payee":inv_payee};
        }else{
            [SVProgressHUD showInfoWithStatus:@"请填写抬头信息"];
            return;
        }
       
       
    }else{   // 增值税发票 的情况
        HCMLog(@"增值税发票");
        
        if (self.inv_name.text.length != 0 && self.inv_verify.text.length != 0 && self.inv_address.text.length != 0 && self.inv_tel.text.length != 0 && self.inv_bank.text.length != 0 && self.inv_bankuser.text.length != 0) {
            
            NSString *inv_type = @"增值税发票";
            NSString *inv_content = @"明细";
            NSString *inv_name = self.inv_name.text;
            NSString *inv_verify = self.inv_verify.text;
            NSString *inv_address = self.inv_address.text;
            NSString *inv_tel = self.inv_tel.text;
            NSString *inv_bank = self.inv_bank.text;
            NSString *inv_bankuser = self.inv_bankuser.text;
            
            dict = @{@"inv_type":inv_type,@"inv_content":inv_content,@"inv_name":inv_name,@"inv_verify":inv_verify,@"inv_address":inv_address,@"inv_tel":inv_tel,@"inv_bank":inv_bank,@"inv_bankuser":inv_bankuser};
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"请完整填写发票信息"];
            return;
        }
        
        
        
    }
    
    //NSString *inv_type = self.invCommonImg.hidden ? @"1" : @"0";
    //NSString *inv_content = self.invCommonImg.hidden ? @"0" : @"明细";
   // NSString *inv_payee = self.invTitel.text;
    
    //NSDictionary *dict = @{@"inv_type":inv_type,@"inv_content":inv_content,@"inv_payee":inv_payee};
    
    [self.delegate setInvContent:self dictData:dict];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)clickBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)clickInvCommonBtn:(UIButton *)sender {
 
    if (self.invCommonImg.hidden) {
        
        self.invCommonImg.hidden = NO;
        self.carefulImg.hidden = NO;
        self.invAdded.hidden = YES;
        [self INVViewHidden];
        
    }else{
        
        self.invCommonImg.hidden = YES;
        self.carefulImg.hidden = YES;
    }
    
}
- (IBAction)clickInvAddedBtn:(UIButton *)sender {
    
    if (self.invAdded.hidden) {
        
        self.invAdded.hidden = NO;
        self.carefulImg.hidden = NO;
        self.invCommonImg.hidden = YES;
        [self INVViewAppear];
        
    }else{
        
        self.invAdded.hidden = YES;
        self.carefulImg.hidden = YES;
        [self INVViewHidden];
    }
}
- (IBAction)clickCarefuBtn:(UIButton *)sender {
    
//    self.carefulImg.hidden = sender.selected;
//    
//    sender.selected = !sender.selected;
}

-(void)INVViewHidden{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.INVView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.INVHeart.alpha = 1;
             self.careFulView.frame = CGRectMake(0, 155, 320, 90);
        }];
        
    }];
    
}

-(void)INVViewAppear{
    [UIView animateWithDuration:0.5 animations:^{
         self.INVHeart.alpha= 0;
          self.careFulView.frame = CGRectMake(0, 316, 320, 90);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
             self.INVView.alpha = 1;
           
        }];
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    // 这个方法是UITextFieldDelegate协议里面的
    
    [theTextField resignFirstResponder]; //这句代码可以隐藏 键盘
    
    return YES;
}
@end
