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
            
//            HCMLog(@"%@",responseBody);
            
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
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD show];
    
    dealMsgModel *model = self.mutArray[indexPath.row];
    
    HCMLog(@"%@",model.messageId);
    
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
            HCMLog(@"responseBodyresponseBody%@",responseBody);
            HCMLog(@"responseBodyresponseBody%@",responseBody[@"data"][0][@"message"]);
            
            [self loadWebViewWithHtmlStr:responseBody[@"data"][0][@"message"] title:responseBody[@"data"][0][@"title"] time:responseBody[@"data"][0][@"sentTime"]];
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
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(0, 0, HCMScreenWidth, HCMScreenHeight);
    [btn addTarget:self action:@selector(touchUpWebViewHidden:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView addSubview:btn];
    
    UIWebView *webVeiw = [[UIWebView alloc]initWithFrame:CGRectMake(40, 70, HCMScreenWidth - 80, HCMScreenHeight-220)];
    webVeiw.backgroundColor = [UIColor lightGrayColor];
    
    NSString *htmlStrs = [NSString stringWithFormat:@"<center><b>%@</b><br/><span style=\"font-size:12px;\">%@</span></center><hr/>%@",title,time,htmlStr];
    
    [webVeiw loadHTMLString:htmlStrs baseURL:nil];
    
    self.webView = webVeiw;
    [self.tableView addSubview:webVeiw];
   
}

-(void)touchUpWebViewHidden:(UIButton*)btn{
    
    [self.webView removeFromSuperview];
    
    [btn removeFromSuperview];
}



@end
