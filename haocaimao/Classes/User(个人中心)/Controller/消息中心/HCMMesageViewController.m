//
//  HCMMesageViewController.m
//  haocaimao
//
//  Created by 好采猫 on 16/7/12.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import "HCMMesageViewController.h"
#import "AddressNerworking.h"
#import "messageTools.h"
#import "HCMDealMsgTableViewController.h"


@interface HCMMesageViewController ()

@property (strong, nonatomic)NSUserDefaults *defaults;
@property (assign, nonatomic)BOOL status;

@property (weak, nonatomic) IBOutlet UILabel *toAllTitle;//活动消息标题
@property (weak, nonatomic) IBOutlet UILabel *toManagerTitle;//合伙人标题
@property (weak, nonatomic) IBOutlet UILabel *toCustomIdTitle;//私信标题

@property (weak, nonatomic) IBOutlet UIImageView *toAllIcon;
@property (weak, nonatomic) IBOutlet UIImageView *toManagerIcon;
@property (weak, nonatomic) IBOutlet UIImageView *toCustomIdIocn;

@property (weak, nonatomic) IBOutlet UILabel *toAllContent;
@property (weak, nonatomic) IBOutlet UILabel *toManagerContent;
@property (weak, nonatomic) IBOutlet UILabel *toCustomContent;

@property (weak, nonatomic) IBOutlet UILabel *toAllYearMonthDay;
@property (weak, nonatomic) IBOutlet UILabel *toManagerYearMonthDay;
@property (weak, nonatomic) IBOutlet UILabel *toCustomYearMonthDay;

@property (weak, nonatomic) IBOutlet UILabel *toAllHourMinuteSecond;
@property (weak, nonatomic) IBOutlet UILabel *toManagerHourMinuteSecond;
@property (weak, nonatomic) IBOutlet UILabel *toCustomHourMinuteSecond;

@property (weak, nonatomic) IBOutlet UIButton *toAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *toManagerBtn;
@property (weak, nonatomic) IBOutlet UIButton *toCustomBtn;


/** 模型 */
@property(nonatomic,strong)messageTools * msgModel;


@end

@implementation HCMMesageViewController

-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"消息中心";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    [SVProgressHUD show];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self NetWorking];
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)NetWorking
{
    self.status = [self.defaults boolForKey:@"status"];

//    HCMLog(@"%d",self.status);
    if (self.status) {
        NSString * sid = [self.defaults objectForKey:@"sid"];
        NSString * uid = [self.defaults objectForKey:@"uid"];
        
        //后台定义actionId == 1 ； 为获取未读总数 + 分类列表
        NSString * actionId = @"1";
        
        NSDictionary *postDict = [NSDictionary dictionary];
        
        postDict = @{
                     @"session":@{@"sid":sid,@"uid":uid},
                     @"actionId":actionId
                     };
        
        [[AddressNerworking sharedManager] postMessageURL:postDict successBlock:^(id responseBody) {
            
            NSLog(@"$%@",responseBody);
            
            self.msgModel = [messageTools MessageWithData:responseBody];
            
            [self beginFuckingData];
            
            [SVProgressHUD dismiss];
            
        } failureBlock:^(NSString *error) {
            [SVProgressHUD showInfoWithStatus:@"请求失败"];
        }];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"请重新登录"];
        return;
    }
}

-(void)beginFuckingData
{
    self.toAllTitle.text = self.msgModel.toAllTitle;
    self.toAllContent.text = self.msgModel.toAllContent;
    self.toAllIcon.hidden = self.msgModel.toAllIcon;
    self.toAllYearMonthDay.text = self.msgModel.toAllYearMonthDay;
    self.toAllHourMinuteSecond.text = self.msgModel.toAllHourMinuteSecond;
    
    self.toManagerTitle.text = self.msgModel.toManagerTitle;
    self.toManagerContent.text = self.msgModel.toManagerContent;
    self.toManagerIcon.hidden = self.msgModel.toManagerIcon;
    self.toManagerYearMonthDay.text = self.msgModel.toManagerYearMonthDay;
    self.toManagerHourMinuteSecond.text = self.msgModel.toManagerHourMinuteSecond;
    
    self.toCustomIdTitle.text = self.msgModel.toCustomIdTitle;
    self.toCustomContent.text = self.msgModel.toCustomContent;
    self.toCustomIdIocn.hidden = self.msgModel.toCustomIdIocn;
    self.toCustomYearMonthDay.text = self.msgModel.toCustomYearMonthDay;
    self.toCustomHourMinuteSecond.text = self.msgModel.toCustomHourMinuteSecond;
    
    [self btnHidden];
}

-(void)btnHidden
{
    if ([self.toAllContent.text isEqualToString:@"暂无消息"]){
        self.toAllBtn.hidden = YES;
    }
    if ([self.toManagerContent.text isEqualToString:@"暂无消息"]) {
        self.toManagerBtn.hidden = YES;
    }
    if ([self.toCustomContent.text isEqualToString:@"暂无消息"]) {
        self.toCustomBtn.hidden = YES;
    }
}

- (IBAction)touchToALLBtn:(UIButton *)sender
{
    HCMDealMsgTableViewController *vc = [[HCMDealMsgTableViewController alloc]init];
    
    if (sender.tag == 0) {
        vc.messCate = @"toALL";
    }else if (sender.tag == 1){
        vc.messCate = @"toManager";
    }else{
        vc.messCate = @"toCustomId";
    }

    [self.navigationController pushViewController:vc animated:YES];
}


@end
