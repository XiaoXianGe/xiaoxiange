//
//  PartnerViewController.m
//  haocaimao
//
//  Created by 好采猫 on 16/1/27.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import "PartnerViewController.h"

@interface PartnerViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *SexArray;
@property (strong, nonatomic) IBOutlet UIView *VView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@property(nonatomic,strong)UIScrollView *scrollView;
@property(assign,nonatomic)BOOL MarkSex;
@end

@implementation PartnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请合伙人";
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    
    //创建scrollView
    [self setUpScrollView];
    
    //监听键盘弹出
    [self addKeyboardEvent];
    
    //为scrollView添加点击事件
    [self setUpTouchTap];
    
    
}

-(void)setUpTouchTap{
    //添加手势
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScrollView)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:recognizer];
}

- (void)touchScrollView
{
    [self.nameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.numberTextField resignFirstResponder];
}

//提交资料
- (IBAction)CommitBtn {
    
    //检查资料是否完整
    self.MarkSex = NO;
    for (UIButton *btn in self.SexArray) {
        if (btn.selected == YES) { self.MarkSex = YES; }
    }
    if (self.MarkSex == NO) {
        [SVProgressHUD showInfoWithStatus:@"请选择性别"];
        return;
    }
    
    if (self.nameTextField.text.length == 0 || self.emailTextField.text.length == 0 || self.numberTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请认真填写资料"];
    }
}

//监听键盘弹出
-(void)addKeyboardEvent{
    
    [HCMNSNotificationCenter addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [HCMNSNotificationCenter addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)keyboardHide:(NSNotification *)notification{
    [self.scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
}

-(void)keyboardShow:(NSNotification *)notification{
    [self.scrollView setContentOffset:CGPointMake(0, 50) animated:YES];
}


//性别三按钮
- (IBAction)changeSex:(UIButton *)sender {
    for (UIButton *btn  in self.SexArray) {
        btn.selected = NO;
    }
    sender.selected = YES;
}

//创建scrollView
-(void)setUpScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    self.scrollView = scrollView;
    
    // 设定scrollView的可显示区域窗口的大小
    scrollView.frame = self.view.frame;
    
    // 设定scrollView的可滚动区域的大小
    scrollView.contentSize = CGSizeMake(320, 600);
    
    scrollView.delegate = self;
    [scrollView addSubview:self.VView];
    [self.view addSubview:scrollView];

}

- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    [HCMNSNotificationCenter removeObserver:self];
}

@end
