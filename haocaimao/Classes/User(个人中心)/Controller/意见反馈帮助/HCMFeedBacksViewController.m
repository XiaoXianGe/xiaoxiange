//
//  HCMFeedBacksViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/12.
//  Copyright © 2015年 haocaimao. All rights reserved.
//  提意见

#import "HCMFeedBacksViewController.h"
#import "AddressNerworking.h"
#import "SGPopSelectView.h"

@interface HCMFeedBacksViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) NSArray *selections;
@property (nonatomic, strong) SGPopSelectView *popView;
@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (assign, nonatomic) NSInteger count;

@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation HCMFeedBacksViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提意见";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    [self setUpPopView];
    
}


-(void)setUpPopView{
    
    self.selections = @[@"留言",@"投诉",@"售后",@"求购"];
    self.popView = [[SGPopSelectView alloc] init];
    self.popView.selections = self.selections;
    __weak typeof(self) weakSelf = self;
    self.popView.selectedHandle = ^(NSInteger selectedIndex){
        _count = selectedIndex;
        weakSelf.chooseLabel.text = weakSelf.selections[selectedIndex];
    };
    
}

- (IBAction)titleTextFieldBegin {
    [self.popView hide:YES];
}

- (IBAction)UITextFieldBegin:(UITextField *)sender {
    [self.popView hide:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    [self.popView hide:YES];
}

- (IBAction)chooseFeedBack:(UIButton *)sender {
    [self.textField resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    CGPoint p = CGPointMake(HCMScreenWidth-100, 170);
    [self.popView showFromView:self.view atPoint:p animated:YES];
    
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)clickOK {
    if ([self.textField.text length]>=10) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"马上提交" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"提交", nil];
        
        [alert show];
        
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"反馈内容不少于10个字"];
    }
   
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        [self pushFeedBacks];
    }
    
    
}

//提交反馈的意见
-(void)pushFeedBacks{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (_count == 2||_count==3) {
        ++_count;
    }
    NSDictionary *dic = @{@"session":@{@"uid":[defaults objectForKey:@"uid"]
                                       ,@"sid":[defaults objectForKey:@"sid"]},@"msg_type":[NSString stringWithFormat:@"%lu",(long)_count],@"msg_title":self.titleTextField.text,@"msg_content":self.textField.text
                          };
    [[AddressNerworking sharedManager]postServiceOut:dic successBlock:^(id responseBody) {
        [SVProgressHUD showSuccessWithStatus:@"感谢您的反馈"];
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:error];
    }];
    

}



@end
