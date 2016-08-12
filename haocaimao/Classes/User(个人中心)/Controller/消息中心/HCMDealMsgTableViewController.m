//
//  HCMDealMsgTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 16/7/15.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import "HCMDealMsgTableViewController.h"
#import "HCMDealMsgTableViewCell.h"
#import "AddressNerworking.h"
#import "MJExtension.h"
#import "dealMsgModel.h"

@interface HCMDealMsgTableViewController ()

@property (strong, nonatomic)NSUserDefaults *defaults;

@property (assign, nonatomic)BOOL status;

/** webView */
@property(nonatomic,strong)UIWebView * webView;
/** bgView */
@property(nonatomic,weak)UIView * bgView;
/** btnClose */
@property(nonatomic,weak)UIButton * btnClose;
/** bgBtn */
@property(nonatomic,weak)UIButton * bgBtn;



/** 接收数据的数组 */
@property(nonatomic,strong)NSMutableArray * mutArray;

@end

@implementation HCMDealMsgTableViewController
-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息详情";
    
    self.tableView.backgroundColor = HCMColor(233, 233, 233, 1.0);
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBackto) image:@"nav-back" highImage:@"nav-back"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HCMDealMsgTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self Netwroking];
    
}

-(void)Netwroking
{
    self.status = [self.defaults boolForKey:@"status"];
    
    if (self.status) {
        NSString * sid = [self.defaults objectForKey:@"sid"];
        NSString * uid = [self.defaults objectForKey:@"uid"];
        
        //后台定义actionId == 2 ； 分类详情
        NSString * actionId = @"2";
//        NSString * messCate = @"toManager";
        NSDictionary *postDict = [NSDictionary dictionary];
        
        postDict = @{
                     @"session":@{@"sid":sid,@"uid":uid},
                     @"actionId":actionId,
                     @"messCate":_messCate
                     };
        
        [[AddressNerworking sharedManager] postMessageURL:postDict successBlock:^(id responseBody) {
            
            HCMLog(@"通知列表信息----%@",responseBody);
            
           self.mutArray = [dealMsgModel objectArrayWithKeyValuesArray:responseBody[@"data"]];
            
            [self.tableView reloadData];
            
        } failureBlock:^(NSString *error) {
            [SVProgressHUD showInfoWithStatus:@"请求失败"];
        }];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"请重新登录"];
        return;
    }

}

-(void)clickBackto
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mutArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCMDealMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    dealMsgModel *model = self.mutArray[indexPath.row];
    
    cell.title.text = model.title;
    cell.sentTime.text = model.sentTime;
    if ([model.readed isEqualToString:@"1"]) {
        
        [cell.pictureView setImage:[UIImage imageNamed:@"haveReaded"]];
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD show];
    
    dealMsgModel *model = self.mutArray[indexPath.row];
    
    self.status = [self.defaults boolForKey:@"status"];
    
    if (self.status) {
        NSString * sid = [self.defaults objectForKey:@"sid"];
        NSString * uid = [self.defaults objectForKey:@"uid"];
        
        //后台定义actionId == 3 ； 消息详情->写入阅读时间
        NSString * actionId = @"3";
        NSDictionary *postDict = [NSDictionary dictionary];
        
        postDict = @{
                     @"session":@{@"sid":sid,@"uid":uid},
                     @"actionId":actionId,
                     @"messageId":model.messageId
                     };
        
        [[AddressNerworking sharedManager] postMessageURL:postDict successBlock:^(id responseBody) {

            NSString *message = responseBody[@"data"][0][@"message"];
            NSString *title = responseBody[@"data"][0][@"title"];
            NSString *sentTime = responseBody[@"data"][0][@"sentTime"];
            
            [self loadWebViewWithHtmlStr:message title:title time:sentTime];
            
            [SVProgressHUD dismiss];
            
        } failureBlock:^(NSString *error) {
            [SVProgressHUD showInfoWithStatus:@"请求失败"];
        }];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"请重新登录"];
        return;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(void)loadWebViewWithHtmlStr:(NSString *)htmlStr title:(NSString *)title time:(NSString *)time
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(38, 38, HCMScreenWidth - 76, HCMScreenHeight - 176)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    self.bgView = bgView;
    [self.tableView addSubview:bgView];
    
    
    UIButton *bgBtn = [[UIButton alloc]init];
    bgBtn.frame = CGRectMake(0, 0, HCMScreenWidth, HCMScreenHeight);
    [bgBtn addTarget:self action:@selector(touchUpWebViewHidden:) forControlEvents:UIControlEventTouchUpInside];
    [bgBtn setBackgroundColor:HCMColor(222, 222, 222, 0.8)];
    self.bgBtn = bgBtn;
    [self.tableView addSubview:bgBtn];
    
    UIWebView *webVeiw = [[UIWebView alloc]initWithFrame:CGRectMake(40, 40, HCMScreenWidth - 80, HCMScreenHeight-180)];
    webVeiw.backgroundColor = [UIColor lightGrayColor];
    
    NSString *htmlStrs = [NSString stringWithFormat:@"<center><b>%@</b><br/><span style=\"font-size:12px;\">%@</span></center><hr/>%@",title,time,htmlStr];
    [webVeiw loadHTMLString:htmlStrs baseURL:nil];
    self.webView = webVeiw;
    [self.tableView addSubview:webVeiw];
    
    
    UIButton *btnClose = [[UIButton alloc]init];
    btnClose.frame = CGRectMake(HCMScreenWidth - 55, 30, 28, 28);
    [btnClose addTarget:self action:@selector(touchUpWebViewHidden:) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    self.btnClose = btnClose;
    [self.tableView addSubview:btnClose];

    
}

-(void)touchUpWebViewHidden:(UIButton*)btn{
    
    [self.webView removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self.bgBtn removeFromSuperview];
    [self.btnClose removeFromSuperview];
    
    [self Netwroking];
}

#pragma mark --- 删除cell
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    dealMsgModel *model = self.mutArray[indexPath.row];
    [self.mutArray removeObjectAtIndex:indexPath.row];
//    [self.mutArray removeAllObjects];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    

    HCMLog(@"model.title %@",model.messageId);
    
    [self deleteMsg:model];
    
    [SVProgressHUD show];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)deleteMsg:(dealMsgModel *)model{
    
    
    self.status = [self.defaults boolForKey:@"status"];
    
    if (self.status) {
        NSString * sid = [self.defaults objectForKey:@"sid"];
        NSString * uid = [self.defaults objectForKey:@"uid"];

        //后台定义actionId == 0 ； 删除消息（+参数：messageId）
        NSString * actionId = @"0";
        NSDictionary *postDict = [NSDictionary dictionary];
        
        postDict = @{
                     @"session":@{@"sid":sid,@"uid":uid},
                     @"actionId":actionId,
                     @"messageId":model.messageId
                     };
        HCMLog(@"model.title %@",model.messageId);
        [[AddressNerworking sharedManager] postMessageURL:postDict successBlock:^(id responseBody) {
            HCMLog(@" 删除消息 %@",responseBody);

            [SVProgressHUD showInfoWithStatus:@"删除成功"];
            
        } failureBlock:^(NSString *error) {
            [SVProgressHUD showInfoWithStatus:@"请求失败"];
        }];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"请重新登录"];
        return;
    }

}
@end
