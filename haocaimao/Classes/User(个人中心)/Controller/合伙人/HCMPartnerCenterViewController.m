//
//  HCMPartnerCenterViewController.m
//  合伙人test
//
//  Created by 好采猫 on 16/3/9.
//  Copyright © 2016年 好采猫. All rights reserved.
//

#import "HCMPartnerCenterViewController.h"
#import "UIView+Extension.h"
#import "HCMPartnerCenterCell.h"
#import "HomeNetwork.h"
#import "PartnerIndexModel.h"
#import "PartnerIndex2Model.h"
#import "MJExtension.h"


#define CellHeight 40 


@interface HCMPartnerCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

/** 内容视图 */
@property (strong, nonatomic) IBOutlet UIView *VView;
/** 最底层的滚动 */
@property(nonatomic,strong)UIScrollView *scrollView;
/** 注册人数tableview*/
@property (weak, nonatomic) IBOutlet UITableView *ParnterNumberTableView;
/** 下单分成tableview*/
@property (weak, nonatomic) IBOutlet UITableView *orderNumberTableView;
/** 红色头部view*/
@property (weak, nonatomic) IBOutlet UIView *headRedVIew;
/** 绿色头部view*/
@property (weak, nonatomic) IBOutlet UIView *headGreenView;

@property(strong,nonatomic)PartnerIndexModel *partnerIndexModel;
@property(strong,nonatomic)NSMutableArray *indexArray;

@property(strong,nonatomic) NSUserDefaults *defaults;

@property(assign)BOOL status;


@end

@implementation HCMPartnerCenterViewController

-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建scrollView
    [self setUpScrollView];
    
    //初始化控制器
    [self setUpController];
    
    //发送网络请求
    [self NetWorking];
    
}

/**
 *  发送网络请求
 */
-(void)NetWorking{
    
    self.status = [self.defaults boolForKey:@"status"];
    
    if (self.status) {
        
        NSString *uid = [self.defaults objectForKey:@"uid"];
        NSString *sid = [self.defaults objectForKey:@"sid"];
        
        NSMutableDictionary *params =[NSMutableDictionary dictionary];
        params[@"session"] = @{@"uid":uid,@"sid":sid};
        
        [[HomeNetwork sharedManager]postPartnerIndexURL:params successBlock:^(id responseBody) {
            
            HCMLog(@"------%@",responseBody);
            self.partnerIndexModel= [PartnerIndexModel objectWithKeyValues:responseBody[@"data"]];
            
           self.indexArray = [PartnerIndex2Model objectArrayWithKeyValuesArray:responseBody[@"data"][@"index"]];
            
            [self.ParnterNumberTableView reloadData];
            [self.orderNumberTableView reloadData];
            
            
            
        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:@"加载失败"];
            
        }];
    }
}


/**
 *  初始化控制器
 */
-(void)setUpController{
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"我是合伙人";
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    self.orderNumberTableView.userInteractionEnabled = NO;
    self.ParnterNumberTableView.userInteractionEnabled = NO;
    
    [self.orderNumberTableView registerNib:[UINib nibWithNibName:@"HCMPartnerCenterCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.ParnterNumberTableView registerNib:[UINib nibWithNibName:@"HCMPartnerCenterCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

//创建scrollView
-(void)setUpScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    self.scrollView = scrollView;
    
    // 设定scrollView的可显示区域窗口的大小
    scrollView.frame = self.view.frame;
    
    // 设定scrollView的可滚动区域的大小
    scrollView.contentSize = CGSizeMake(320, 600);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    [scrollView addSubview:self.VView];
    
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSUInteger count1 = 1;
    
    if (tableView == self.ParnterNumberTableView) {
        self.ParnterNumberTableView.height = CellHeight * count1;
        return count1;
    }else{
        
        self.headGreenView.y = self.headRedVIew.y + self.headRedVIew.height + CellHeight * count1 + 15;
        
        self.orderNumberTableView.y = self.headGreenView.y + self.headGreenView.height;
        
        self.orderNumberTableView.height = CellHeight * self.indexArray.count;
        
        _scrollView.contentSize = CGSizeMake(320, self.orderNumberTableView.y + self.orderNumberTableView.height + 100);
        
        return self.indexArray.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCMPartnerCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = HCMColor(233, 233, 233, 1.0);
        
    }else{
        cell.backgroundColor = HCMColor(211, 211, 211, 1.0);
    }
    
    if (tableView == self.ParnterNumberTableView) {
     
        cell.Label_Left.text = self.partnerIndexModel.rank;
        cell.Label_Middle.text = self.partnerIndexModel.amount;
        cell.Label_Right.text = self.partnerIndexModel.proportion;
    }else{
        
        PartnerIndex2Model *model = self.indexArray[indexPath.row];
        cell.Label_Left.text = model.orderSN;
        cell.Label_Middle.text = model.commission;
        
        if ([model.status isEqualToString:@"1"]) {
             cell.Label_Right.text =@"已结算";
        }else{
            cell.Label_Right.text = @"未结算";
        }
        
    }
    return cell;
    
}

-(void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
}
@end
