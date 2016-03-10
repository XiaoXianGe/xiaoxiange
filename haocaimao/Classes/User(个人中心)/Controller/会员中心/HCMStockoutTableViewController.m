//
//  HCMStockoutTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/13.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMStockoutTableViewController.h"
#import "HCMStockoutInfoTableViewCell.h"
#import "TouchEventForTableView.h"
#import "AddressNerworking.h"

#import "OutOfGoodsModel.h"

@interface HCMStockoutTableViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *infoForStockoutVC;

@property(strong,nonatomic)NSUserDefaults *defaults;

@property (weak, nonatomic) IBOutlet UITextField *inputName;
@property (weak, nonatomic) IBOutlet UITextView *inputInfo;
@property (weak, nonatomic) IBOutlet UILabel *goodNumber;

@property(strong,nonatomic)NSMutableArray *outOfGoodsArray;

@end

@implementation HCMStockoutTableViewController

static NSString *const reuseIdentifier = @"Cell";

-(NSMutableArray *)outOfGoodsArray{
    if (!_outOfGoodsArray) {
        _outOfGoodsArray = [NSMutableArray array];
    }
    return _outOfGoodsArray;
}

-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    TouchEventForTableView *tableView = [[TouchEventForTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64-80) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    self.tableView =tableView;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.infoForStockoutVC.height = 235;
    self.tableView.tableHeaderView = self.infoForStockoutVC;

    [self.tableView registerNib:[UINib nibWithNibName:@"HCMStockoutInfoTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    self.title = @"缺货申请";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    [self sendTheOutGoodsList];
    
    
}

- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendTheOutGoodsList{
    /*
     缺货登记接口：user/booking
     需要参数：
     uid，sid，
     goodsName,goodsNumber,goodsDesc
     */
    
    //http://www.haocaimao.com/ecmobile/?url=user/booking
    
    NSString *sid = [self.defaults objectForKey:@"sid"];
    NSString *uid = [self.defaults objectForKey:@"uid"];
    
    NSDictionary *dict = @{@"session":@{@"uid":uid,@"sid":sid}};
    
    [[AddressNerworking sharedManager]postBookOutGoods:dict successBlock:^(id responseBody) {
        
        if (responseBody[@"status"][@"error_code"]) {
           [ SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }

        NSMutableArray *outOfGoodsArray = [NSMutableArray array];
        for (NSDictionary *dict in responseBody[@"data"]) {
            OutOfGoodsModel *goods = [OutOfGoodsModel objectWithKeyValues:dict];
            [outOfGoodsArray addObject:goods];
        }
        
        self.outOfGoodsArray = [outOfGoodsArray copy];
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:error];
    }];
    
}

//提交更多缺货商品
- (IBAction)addMoreOutGoodsBtn {
    
    [self.tableView endEditing:YES];
    
    
    if (self.inputName.text.length < 2) {
        [SVProgressHUD showInfoWithStatus:@"请填写商品名称/编码"];
        return;
    }
    if (self.inputInfo.text.length < 2) {
        [SVProgressHUD showInfoWithStatus:@"请填写商品备注"];
        return;
    }
    
    // 创建警告框实例
    //  3.设置self为alertView的代理方
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否立刻提交" message:@"请确认填写的缺货商品信息。" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES",nil];
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
        
        NSString *sid = [self.defaults objectForKey:@"sid"];
        NSString *uid = [self.defaults objectForKey:@"uid"];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"session"] = @{@"uid":uid,@"sid":sid};
        dict[@"goodsName"] = self.inputName.text;
        dict[@"goodsNumber"] = self.goodNumber.text;
        dict[@"goodsDesc"] = self.inputInfo.text;
        
        [[AddressNerworking sharedManager]postBookOutGoods:dict successBlock:^(id responseBody) {
            
            if (responseBody[@"status"][@"error_code"]) {
                [ SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
                return ;
            }
            
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            
            [self.tableView reloadData];

        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:error];
        }];
        
    }
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //接收网络cell的个数
    return [self.outOfGoodsArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HCMStockoutInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    OutOfGoodsModel *model = self.outOfGoodsArray[indexPath.row];
    
    cell.goodName.text = model.goodsName;
    cell.goodDesc.text = model.goodsDesc;
    cell.goodNumber.text = model.goodsNumber;
    
   
    if ([model.status isEqualToString:@"0"]) {
        
        UIImageView *imageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yudingzhong"]];
        
        imageView.frame = CGRectMake(270, 12, 50, 50);
        
        [cell addSubview:imageView];
        
    }
    
    return cell;
        
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
//加
- (IBAction)addGoodNum {
    
    NSInteger i = [self.goodNumber.text integerValue];
    i++;
    self.goodNumber.text = [NSString stringWithFormat:@"%ld",(long)i];
    
}
//减
- (IBAction)subGoodNum {
    
    NSInteger i = [self.goodNumber.text integerValue];
    if(i > 1){
        i--;
        self.goodNumber.text = [NSString stringWithFormat:@"%ld",(long)i];
    }
    
}


@end
