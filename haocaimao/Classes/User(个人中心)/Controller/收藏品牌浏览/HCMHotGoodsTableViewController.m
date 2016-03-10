//
//  HCMHotGoodsTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/24.
//  Copyright © 2015年 haocaimao. All rights reserved.
//  热销商品----关注的品牌

#import "HCMHotGoodsTableViewController.h"
#import "AddressNerworking.h"
#import "HCMSort_ViewController.h"
@interface HCMHotGoodsTableViewController ()
@property (strong, nonatomic) NSMutableArray *allAttention;

@end

@implementation HCMHotGoodsTableViewController
static NSString *reuseIdentifier = @"qwe";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self loadData];
   }
- (void)loadData{
[[AddressNerworking sharedManager]postattentionURL:nil successBlock:^(id responseBody) {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in responseBody[@"data"]) {
        [array addObject:dic];
    }
    
    self.allAttention = array;
    [self.tableView reloadData];
} failureBlock:^(NSString *error) {
    
}];
    
    
    
}
- (void)setupNavi{
    self.title = @"关注品牌";
    UIBarButtonItem *leftBtn = [UIBarButtonItem itemWithTarget:self action:@selector(goBack) image:@"nav-back" highImage:@"nav-back"];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:reuseIdentifier];
    
}
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allAttention.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
     NSDictionary *dic = self.allAttention[indexPath.section];
    if(cell==nil){
       
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"url"]] placeholderImage:[UIImage imageNamed:@"Placeholder_ Advertise"]];
    [cell.contentView addSubview:imageView];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *dic = self.allAttention[section];

    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    headerView.textLabel.text = dic[@"brand_name"];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.allAttention[indexPath.section];

        HCMSort_ViewController *HCMSortVC = [[HCMSort_ViewController alloc]initWithNibName:@"HCMSort_ViewController" bundle:nil];
        
    HCMSortVC.brand_id = [dic[@"brand_id"] integerValue];
        [self addAnimation];
        [self.navigationController pushViewController:HCMSortVC animated:YES];
    

}
-(void)addAnimation{
    CATransition *animation = [CATransition animation];
    animation.duration = 1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    //animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
}
@end
