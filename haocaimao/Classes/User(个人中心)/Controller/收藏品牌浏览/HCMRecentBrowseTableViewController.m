//
//  HCMRecentBrowseTableViewController.m
//  haocaimao
//
//  Created by 李芷贤 on 15/11/12.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMRecentBrowseTableViewController.h"
#import "HCMRecentBrowseTableViewCell.h"

#import "AddressNerworking.h"
#import "MJExtension.h"

#import "LookHistoryModel.h"
#import "DealViewController.h"
#import "UIButton+WebCache.h"

@interface HCMRecentBrowseTableViewController ()
@property (strong, nonatomic)NSArray *historyTimeArr;
@property (strong, nonatomic)NSArray *historyArr;
@property (strong, nonatomic)NSArray *HistoryrecommendID;

@property (strong, nonatomic)NSUserDefaults *defaults;
@property (assign, nonatomic)BOOL status;
@end

@implementation HCMRecentBrowseTableViewController
-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"浏览记录";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HCMRecentBrowseTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    [SVProgressHUD showWithStatus:@"加载中"];
    
    [self networking];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
}

-(void)networking{
     self.status = [self.defaults boolForKey:@"status"];
    if (self.status) {
        
        NSString *sid = [self.defaults objectForKey:@"sid"];
        NSString *uid = [self.defaults objectForKey:@"uid"];
        
        NSDictionary *dict = @{@"session":@{@"sid":sid,@"uid":uid}};
        
        [[AddressNerworking sharedManager]lookHistory:dict successBlock:^(id responseBody) {
            
            if (responseBody[@"status"][@"error_code"]) {
                [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
                return ;
            }
       
            NSMutableArray *mutabHistoryTime = [NSMutableArray array];
            NSMutableArray *mutabHistoryArray = [NSMutableArray array];
            
            for (NSDictionary *dict  in responseBody[@"data"]) {
                [mutabHistoryTime addObject:dict[@"time"]];
                
                NSMutableArray *mutabHistoryArr = [NSMutableArray array];
                for (NSDictionary *dict2 in dict[@"history"]) {
                    
                    LookHistoryModel *history = [LookHistoryModel objectWithKeyValues:dict2];
                    [mutabHistoryArr addObject:history];
                    
                }
                [mutabHistoryArray addObject:mutabHistoryArr];
            }
            
            self.historyArr = [mutabHistoryArray copy];
            self.historyTimeArr = [mutabHistoryTime copy];
            
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:@"网络有问题"];
            
        }];
    }

}

- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.historyTimeArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.historyArr[section];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCMRecentBrowseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSArray *array = self.historyArr[indexPath.section];
    LookHistoryModel *history = array[indexPath.row];
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:history.goodsThumb]];
    cell.name.text = history.goodsName;
    cell.price.text = [NSString stringWithFormat:@"%@元",history.goodsPrice];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
       NSArray *arr = (NSArray *)history.recommendInfo;
    
        if (arr.count != 0) {
            
            NSMutableArray *thumbArr = [NSMutableArray array];
            NSMutableArray *IDArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                [thumbArr addObject:dic[@"recommendThumb"]];
                [IDArr addObject:dic[@"recommendId"]];
            }
            
            [self setRecomendBtnImage:cell.recommendBtn1 recommendBtn2:cell.recommendBtn2 recommendBtn3:cell.recommendBtn3 recommendBtn4:cell.recommendBtn4 thumbArray:thumbArr IDArr:IDArr cell:cell];
            
        }else{
            [cell.recommendBtn1 setHidden:YES];
            [cell.recommendBtn2 setHidden:YES];
            [cell.recommendBtn3 setHidden:YES];
            [cell.recommendBtn4 setHidden:YES];

        }

    return cell;
}
//设置 相关推荐 按钮相关推荐的内容 是否隐藏
-(void)setRecomendBtnImage:(UIButton *)recommendBtn1 recommendBtn2:(UIButton *)recommendBtn2 recommendBtn3:(UIButton *)recommendBtn3 recommendBtn4:(UIButton *)recommendBtn4 thumbArray:(NSArray *)thumbArr IDArr:(NSArray *)IDArr cell:(HCMRecentBrowseTableViewCell *)cell{
    
    
    if (thumbArr.count==1) {
        cell.recommendBtn1.tag = [IDArr[0] intValue];
        
        [cell.recommendBtn1 sd_setBackgroundImageWithURL:[NSURL URLWithString:thumbArr[0]] forState:UIControlStateNormal];
        [cell.recommendBtn2 setHidden:YES];
        [cell.recommendBtn3 setHidden:YES];
        [cell.recommendBtn4 setHidden:YES];
        
    }
    if (thumbArr.count==2) {
        cell.recommendBtn1.tag = [IDArr[0] intValue];
        cell.recommendBtn2.tag = [IDArr[1] intValue];
        [cell.recommendBtn1 sd_setBackgroundImageWithURL:[NSURL URLWithString:thumbArr[0]] forState:UIControlStateNormal];
        [cell.recommendBtn2 sd_setBackgroundImageWithURL:[NSURL URLWithString:thumbArr[1]] forState:UIControlStateNormal];
        
        [cell.recommendBtn3 setHidden:YES];
        [cell.recommendBtn4 setHidden:YES];
    }
    if (thumbArr.count==3) {
        cell.recommendBtn1.tag = [IDArr[0] intValue];
        cell.recommendBtn2.tag = [IDArr[1] intValue];
        cell.recommendBtn3.tag = [IDArr[2] intValue];
        [cell.recommendBtn1 sd_setBackgroundImageWithURL:[NSURL URLWithString:thumbArr[0]] forState:UIControlStateNormal];
        [cell.recommendBtn2 sd_setBackgroundImageWithURL:[NSURL URLWithString:thumbArr[1]] forState:UIControlStateNormal];
        [cell.recommendBtn3 sd_setBackgroundImageWithURL:[NSURL URLWithString:thumbArr[2]] forState:UIControlStateNormal];
        [cell.recommendBtn4 setHidden:YES];
    }
    if (thumbArr.count==4) {
        cell.recommendBtn1.tag = [IDArr[0] intValue];
        cell.recommendBtn2.tag = [IDArr[1] intValue];
        cell.recommendBtn3.tag = [IDArr[2] intValue];
        cell.recommendBtn4.tag = [IDArr[3] intValue];
        
        [cell.recommendBtn1 sd_setBackgroundImageWithURL:[NSURL URLWithString:thumbArr[0]] forState:UIControlStateNormal];
        [cell.recommendBtn2 sd_setBackgroundImageWithURL:[NSURL URLWithString:thumbArr[1]] forState:UIControlStateNormal];
        [cell.recommendBtn3 sd_setBackgroundImageWithURL:[NSURL URLWithString:thumbArr[2]] forState:UIControlStateNormal];
        [cell.recommendBtn4 sd_setBackgroundImageWithURL:[NSURL URLWithString:thumbArr[3]] forState:UIControlStateNormal];
        
        [cell.recommendBtn1 addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        [cell.recommendBtn2 addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        [cell.recommendBtn3 addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        [cell.recommendBtn4 addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)test:(UIButton *)sender {
    
    DealViewController *vc = [[DealViewController alloc]initWithNibName:@"DealViewController" bundle:nil];
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    vc.goods_id = str;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DealViewController *vc = [[DealViewController alloc]initWithNibName:@"DealViewController" bundle:nil];
    NSArray *array = self.historyArr[indexPath.section];
    LookHistoryModel *history = array[indexPath.row];
    vc.goods_id = history.goodsId;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight;
    if (HCMScreenWidth == 320.0) {
        cellHeight = 117;
    }else if(HCMScreenWidth == 375.0){
        cellHeight = 137;
    }else if(HCMScreenWidth == 414.0){
        cellHeight = 150;
    }else{
        return 150;
    }
    
    return cellHeight;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 320, 20)];
    label.text = self.historyTimeArr[section];
    return label.text;
}


@end
