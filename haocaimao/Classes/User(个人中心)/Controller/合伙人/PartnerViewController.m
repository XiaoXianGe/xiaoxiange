//
//  PartnerViewController.m
//  haocaimao
//
//  Created by 好采猫 on 16/1/27.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import "PartnerViewController.h"
#import "HomeNetwork.h"

@interface PartnerViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *SexArray;
@property (strong, nonatomic) IBOutlet UIView *VView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (strong, nonatomic) IBOutlet UIView *successView;


@property(nonatomic,strong)UIScrollView *scrollView;
@property(assign,nonatomic)BOOL MarkSex;

@property(strong,nonatomic)NSUserDefaults *defaults;

@property(assign,nonatomic)BOOL status;

@end

@implementation PartnerViewController

-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.email) {
        self.emailTextField.text = self.email;
    }
    if (self.mobilePhone) {
        self.numberTextField.text = self.mobilePhone;
    }
    if (self.sex) {
        
        UIButton *btn = self.SexArray[self.sex];
        btn.selected = YES;
        self.MarkSex = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化控制器
    [self setupController];
    
    //创建scrollView
    [self setUpScrollView];
    
    //监听键盘弹出
    [self addKeyboardEvent];
    
    //为scrollView添加点击事件
    [self setUpTouchTap];
    
    
}

/**
 * 初始化控制器
 */
-(void)setupController{
    self.title = @"个人资料";
    
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
          @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

/**
 * 添加手势
 */
-(void)setUpTouchTap{
    
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


/**
 * 提交资料
 */
- (IBAction)CommitBtn {
    
    [self.view endEditing:YES];
    
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
        [SVProgressHUD showInfoWithStatus:@"请完整填写资料"];
        return;
    }
    
    self.status = [self.defaults boolForKey:@"status"];
    
    if (self.status) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        NSString *sid = [self.defaults objectForKey:@"sid"];
        NSString *uid = [self.defaults objectForKey:@"uid"];
        
        params[@"session"]= @{@"sid":sid,@"uid":uid};
        params[@"realName"] = self.nameTextField.text;
        params[@"mobilePhone"] =self.numberTextField.text;
        params[@"email"] = self.emailTextField.text;
        params[@"sex"] = [NSString stringWithFormat:@"%ld",(long)self.sex];
        
        HCMLog(@"%@",params);
                
        [[HomeNetwork sharedManager]postPartnerApplyURL:params successBlock:^(id responseBody) {
            
            NSLog(@"%@",responseBody);
            if (responseBody[@"status"][@"error_desc"]) {
                [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
                return ;
            }
            
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            
            self.successView.frame = CGRectMake(0, 0, HCMScreenWidth, HCMScreenHeight);
            [self.VView addSubview:self.successView];
            
        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:@"申请失败"];
            
        }];

    }
    
    
}

/**
 * 点击successView分享button
 */
- (IBAction)gotoShare {
    
    
    HCMLog(@"分享。、。");
    
}



/**
 * 监听键盘弹出
 */
-(void)addKeyboardEvent{
    
    [HCMNSNotificationCenter addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [HCMNSNotificationCenter addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardHide:(NSNotification *)notification{
    // 设定scrollView的可滚动区域的大小
    self.scrollView.contentSize = CGSizeMake(320, 0);
    [self.scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
}

-(void)keyboardShow:(NSNotification *)notification{
    // 设定scrollView的可滚动区域的大小
    self.scrollView.contentSize = CGSizeMake(320, 670);
    [self.scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
}

//性别三按钮
- (IBAction)changeSex:(UIButton *)button {
    
    for (int i = 0; i < self.SexArray.count; i++) {
        UIButton *btn =  self.SexArray[i];
        btn.selected = NO;
        btn.tag = i;
    }
    button.selected = YES;
    self.sex = button.tag;
}

//创建scrollView
-(void)setUpScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    self.scrollView = scrollView;
    
    // 设定scrollView的可显示区域窗口的大小
    scrollView.frame = self.view.frame;
    
    // 设定scrollView的可滚动区域的大小
    scrollView.contentSize = CGSizeMake(320, 0);
    scrollView.showsVerticalScrollIndicator = NO;

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
