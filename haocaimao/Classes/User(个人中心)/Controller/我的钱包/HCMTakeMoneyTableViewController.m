//
//  HCMTakeMoneyTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/22.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMTakeMoneyTableViewController.h"
#import "AddressNerworking.h"
#import "HCMTakeOutMoneyTableViewCell.h"

#import "TouchEventForTableView.h"
#import "TakeOutMoneyModel.h"

@interface HCMTakeMoneyTableViewController ()
@property (strong, nonatomic) IBOutlet UIView *heartView;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankTextField;
@property(strong,nonatomic)NSUserDefaults *defaults;
@property(strong,nonatomic)NSMutableArray *takeOutMoneyArray;
@end

static NSString *const reuseIdentifier = @"Cell";

@implementation HCMTakeMoneyTableViewController

-(NSMutableArray *)outOfGoodsArray{
    if (!_takeOutMoneyArray) {
        _takeOutMoneyArray = [NSMutableArray array];
    }
    return _takeOutMoneyArray;
}

-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TouchEventForTableView *tableView = [[TouchEventForTableView alloc] initWithFrame:CGRectMake(0,0, self.view.width, self.view.height) style:UITableViewStylePlain];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    self.title = @"余额提现";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    [tableView registerNib:[UINib nibWithNibName:@"HCMTakeOutMoneyTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    self.heartView.height = 190;
    tableView.tableHeaderView = self.heartView;
    
    tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView =tableView;
    
    [self netWorking];
    
}
//请求提现的申请列表
-(void)netWorking{
    
    //user/withdraw_list
    NSString *sid = [self.defaults objectForKey:@"sid"];
    NSString *uid = [self.defaults objectForKey:@"uid"];
    
    NSDictionary *dict = @{@"session":@{@"uid":uid,@"sid":sid}};
    [[AddressNerworking sharedManager]postLookTakeMoneyOut:dict successBlock:^(id responseBody) {
        
        NSMutableArray *takeMoneyArray = [NSMutableArray array];
        for (NSDictionary *dict in responseBody[@"data"]) {
            TakeOutMoneyModel *money = [TakeOutMoneyModel objectWithKeyValues:dict];
            [takeMoneyArray addObject:money];
        }
        
        self.takeOutMoneyArray = [takeMoneyArray copy];
        
        [self.tableView reloadData];
        
        [SVProgressHUD showSuccessWithStatus:nil];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:@"网络有问题"];
        
    }];
    
}



- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

//提交申请
- (IBAction)clickOK {
    [self.tableView endEditing:YES];
    
    if (self.moneyTextField.text.length < 1) {
        [SVProgressHUD showInfoWithStatus:@"请填写金额"];
        return;
    }
    if (self.bankTextField.text.length < 1) {
        [SVProgressHUD showInfoWithStatus:@"请填写银行帐号"];
        return;
    }
    
    // 创建警告框实例
    //  3.设置self为alertView的代理方
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否立刻提交" message:@"请确认填写的信息。" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES",nil];
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
    
    if ([title isEqualToString:@"Cancel"]) {
        
        [self.tableView endEditing:YES];
        
    } else{
        
        [self.tableView endEditing:YES];
        
        NSString *sid = [self.defaults objectForKey:@"sid"];
        NSString *uid = [self.defaults objectForKey:@"uid"];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[@"session"] = @{@"uid":uid,@"sid":sid};
        dict[@"amount"] = self.moneyTextField.text;
        dict[@"user_note"] = self.bankTextField.text;
        
        [[AddressNerworking sharedManager]postTakeMoneyOut:dict successBlock:^(id responseBody) {
            
            if (responseBody[@"data"][@"status"]) {
                [SVProgressHUD showInfoWithStatus:responseBody[@"data"][@"lang"]];
                
                return ;
            }
            [self.tableView reloadData];
            
            
        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:error];
            
        }];
        
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tableView endEditing:YES];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    //接收网络cell的个数
    return [self.takeOutMoneyArray count];

    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HCMTakeOutMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    TakeOutMoneyModel *model = self.takeOutMoneyArray[indexPath.row];
    
    cell.amount.text = model.amount;
    cell.add_time.text = model.add_time;
    
    cell.pay_status.text = model.pay_status;
    cell.user_note.text = model.user_note;
    
    cell.type.text = model.type;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
@end
