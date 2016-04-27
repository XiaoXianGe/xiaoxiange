//
//  HCMHongBaoTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/13.
//  Copyright © 2015年 haocaimao. All rights reserved.
//http://www.haocaimao.com/ecmobile/index.php?url=user/bonus
//http://www.haocaimao.com/ecmobile/index.php?url=user/add_bonus

#import "HCMHongBaoTableViewController.h"
#import "HCMHongBaoTableViewCell.h"
#import "AddressNerworking.h"
#import "TouchEventForTableView.h"

#import "HongBaoModel.h"

@interface HCMHongBaoTableViewController ()
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic)NSUserDefaults *defaults;
@property(assign,nonatomic)BOOL status;

@property(strong,nonatomic)NSMutableArray *hongbaoArray;
@property (weak, nonatomic) IBOutlet UITextField *addHongBaoNumber;

@end

@implementation HCMHongBaoTableViewController

static NSString *const reuseIdentifier = @"Cell";
-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

-(NSMutableArray *)hongbaoArray{
    if (!_hongbaoArray) {
        _hongbaoArray = [NSMutableArray array];
    }
    return _hongbaoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TouchEventForTableView *tableView = [[TouchEventForTableView alloc] initWithFrame:CGRectMake(0,0, self.view.width, self.view.height) style:UITableViewStylePlain];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    self.title = @"我的红包";
    
    [tableView registerNib:[UINib nibWithNibName:@"HCMHongBaoTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    self.footerView.height = 150;
    tableView.tableFooterView = self.footerView;
    
     self.tableView =tableView;
    
    [self networking];
    
  }


-(void)networking{
    
    self.status = [self.defaults boolForKey:@"status"];
    if (self.status) {
        NSString *sid = [self.defaults objectForKey:@"sid"];
        NSString *uid = [self.defaults objectForKey:@"uid"];
        
        NSDictionary *dict = @{@"session":@{@"sid":sid,@"uid":uid}};
    
        [[AddressNerworking sharedManager]postHongBao:dict successBlock:^(id responseBody) {
            
            if (responseBody[@"status"][@"error_code"]) {
                
                [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
                return ;
            }
            NSMutableArray *hongbaoArray = [NSMutableArray array];
            for (NSDictionary *dict in responseBody[@"data"]) {
                HongBaoModel *hongbao = [HongBaoModel objectWithKeyValues:dict];
                [hongbaoArray addObject:hongbao];
            }
            
            self.hongbaoArray = [hongbaoArray copy];
           
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];

            
        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:error];
            
        }];
        
        
        
        
    }
    
}

//添加更多红包
- (IBAction)addHongBao {
    
    if (self.addHongBaoNumber.text.length != 10) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的序列号"];
        return;

    }
    // 创建警告框实例
    //  3.设置self为alertView的代理方
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"是否立刻提交" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    //设置alertview的样式
    // alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    // 显示警告框
    [alert show];
    
    
}


//第一个参数：代表委托方自己
//第二个参数：委托方发给代理方的一些重要信息
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //根据点击的按钮的index，获取这个按钮的标题
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"取消"]) {
        [self.tableView endEditing:YES];
        
    } else{
        
        //发送添加红包请求
        [self sendAddHongbaoRequest];
    }
}

-(void)sendAddHongbaoRequest{
    
    self.status = [self.defaults boolForKey:@"status"];
    if (self.status) {
        NSString *sid = [self.defaults objectForKey:@"sid"];
        NSString *uid = [self.defaults objectForKey:@"uid"];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[@"session"] = @{@"uid":uid,@"sid":sid};
        dict[@"bonus_sn"] = self.addHongBaoNumber.text;
        
        
        [[AddressNerworking sharedManager]postAddHongBao:dict successBlock:^(id responseBody) {
            
            if (responseBody[@"status"][@"error_code"]) {
                
                [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
                return ;
            }
            if (responseBody[@"data"][@"status"]) {
                
                [SVProgressHUD showInfoWithStatus:responseBody[@"data"][@"lang"]];
            }
            
            [self networking];
            
        } failureBlock:^(NSString *error) {
            [SVProgressHUD showInfoWithStatus:error];
        }];
        
    }
    
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.hongbaoArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCMHongBaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    HongBaoModel *model = self.hongbaoArray[indexPath.row];
    
    cell.hongBaoPrice.text = [NSString stringWithFormat:@"￥%@元",model.type_money];
    
    cell.hongBaoStatus.text = model.status;
    
    cell.minBuyPrice.text = [NSString stringWithFormat:@"单笔购买商品满%@元可用",model.min_goods_amount];
    
    cell.hongBaoUseDate.text = [NSString stringWithFormat:@"有效期：%@-%@",model.use_startdate,model.use_enddate];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
}


@end
