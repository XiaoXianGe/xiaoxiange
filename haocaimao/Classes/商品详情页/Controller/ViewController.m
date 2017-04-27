//
//  ViewController.m
//  ScrollPageDown_Demo
//
//  Created by 好采猫 on 15/7/16.
//  Copyright (c) 2015年 LJH. All rights reserved.
/*
 类似淘宝商品详情查看翻页效果的实现
 基本思路：
 1、设置一个 UIScrollView 作为视图底层，并且设置分页为两页
 2、然后在第一个分页上添加一个 UITableView 并且设置表格能够上提加载（上拉操作即为让视图滚动到下一页）
 3、 在第二个分页上添加一个 UIWebView 并且设置能有下拉刷新操作（下拉操作即为让视图滚动到上一页）
*/

#import "ViewController.h"
#import "MJRefresh.h"
#import "UINavigationBar+Background.h"
#import "UIView+Extension.h"
#import "AFNetworking.h"

#import "HCMDealCell.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "HCMDealNumberCell.h"
#import "SDCycleScrollView.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>

@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UIWebView *webView;
@property (nonatomic) CGFloat halfHeight;
@property(strong ,nonatomic) HCMDealModel *dealModel;


@end

static NSString * const HCMDealCellID = @"Deal";
static NSString * const HCMDealNumberCellID = @"Number";

@implementation ViewController


-(HCMDealModel *)dealModel
{
    if (!_dealModel) {
        _dealModel = [[HCMDealModel alloc]init];
    }
    return _dealModel;
}

- (void)viewDidLoad
{
  
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"正在加载中"];
    
    //初始化控制器
    [self setupDealView];
    
    /** 为tableView和webView加刷新刷新控件 */
    [self setupMJRefreshFortableViewAndWebView];
    
    //网络请求
    [self NetWorking];
    
    //添加尾视图
    [self addFooterView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar cnReset];
}
/**
 * 初始化控制器
 */
-(void)setupDealView
{
    
    self.navigationItem.title = @"商品详情";
    
    self.navigationController.navigationBarHidden = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    //nav变透明
    [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor clearColor]];
    
    _halfHeight = (HCMScreenHeight) * 0.5 - 64;
    //控件添加到视图上
    /**
     *  设置一个 UIscrollViewiew 作为视图底层，并且设置分页为两页
     *  然后在第一个分页上添加一个 UITableView 并且设置表格能够上提加载（上拉操作即为让视图滚动到下一页）
     在第二个分页上添加一个 UIWebView 并且设置能有下拉刷新操作（下拉操作即为让视图滚动到上一页）
     */
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tableView];
    [self.scrollView addSubview:self.webView];
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(test) image:@"nav-back" highImage:@"nav-back"];
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(test) image:@"item-info-header-share-icon-1" highImage:@"item-info-header-share-icon-1"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HCMDealCell class]) bundle:nil] forCellReuseIdentifier:HCMDealCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HCMDealNumberCell class]) bundle:nil] forCellReuseIdentifier:HCMDealNumberCellID];
    
}


/**
 * 添加尾视图
 */
-(void)addFooterView
{
    UIView *view = [[UIView alloc]init];
    view.x = 0;
    view.y = 0;
    view.width = HCMScreenWidth;
    view.height = 30;
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"查看商品详情";
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 0, HCMScreenWidth, 30);
    [view addSubview:label];
    _tableView.tableFooterView = view;
}

/**
 * 网络请求
 */
-(void)NetWorking
{
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"goods_id"] = self.goods_id;
    
    [[AFHTTPSessionManager manager]POST:@"http://www.haocaimao.com/ecmobile/?url=goods" parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        _dealModel= [HCMDealModel objectWithKeyValues:responseObject[@"data"]];

         NSLog(@"%@ -- %@",[self.dealModel.pictures class],self.dealModel.pictures);
        [self setupSDCycleScrollView];
        
        [SVProgressHUD dismiss];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 * 加载轮播图
 */
-(void)setupSDCycleScrollView
{
    
    NSArray * Array = (NSArray *)self.dealModel.pictures;
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSDictionary *dict  in Array) {
        NSString *str = dict[@"small"];
        [imageArray addObject:str];
    }
    
    //网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, HCMScreenWidth    , HCMScreenWidth) imageURLStringsGroup:imageArray]; // 模拟网络延时情景

    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.delegate = self;

    cycleScrollView.placeholderImage = [UIImage imageNamed:@"7E079BD74EF3"];

    self.tableView.tableHeaderView = cycleScrollView;

}

/**
 * 点击事件
 */
-(void)touchUpIns
{
    NSLog(@"...");
}

#warning 测试数据
-(void)test
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

/**
 * 为tableView和webView加刷新刷新控件
 */
- (void)setupMJRefreshFortableViewAndWebView
{
    //设置UITableView 上拉加载
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉，执行对应的操作---改变底层滚动视图的滚动到对应位置
        //设置动画效果
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.scrollView.contentOffset = CGPointMake(0, HCMScreenHeight);
        } completion:^(BOOL finished) {
            //结束加载
            [self.tableView.footer endRefreshing];
            [SVProgressHUD show];
            NSMutableDictionary *parames = [NSMutableDictionary dictionary];
            parames[@"goods_id"] = self.goods_id;
            
            [[AFHTTPSessionManager manager]POST:@"http://www.haocaimao.com/ecmobile/?url=goods/desc" parameters:parames success:^(NSURLSessionDataTask *task, id responseObject) {
                
                
                NSString *webPath = responseObject[@"data"];
                
                [self.webView loadHTMLString:webPath baseURL:nil];
                
                
                
                [SVProgressHUD dismiss];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [SVProgressHUD dismiss];
            }];
            

            
        }];
    }];
    
    
    //设置UIWebView 有下拉操作
    
    self.webView.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
        //设置动画效果
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            //下拉执行对应的操作
           
            //[self.collectionView setContentOffset:CGPointMake(0, -20) animated:YES];
            
        } completion:^(BOOL finished) {
             [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
            //结束加载
            [self.webView.scrollView.header endRefreshing];\

        }];
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;//状态栏的背景色是黑色, 字体为白色
    
    [self scrollViewDidScroll:self.tableView];
     [self.navigationController.navigationBar setShadowImage:[UIImage new]];//用于去除导航栏的底线，也就是周围的边线
    //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor *color = HCMColor(233, 50, 50, 1.0);
    CGFloat offsetY = scrollView.contentOffset.y;
    if ( -300.0 <   offsetY && offsetY < 30.0 ) {
        
        CGFloat alpha = MIN(1,30/(HCMScreenWidth-100));

        [self.navigationController.navigationBar cnSetBackgroundColor:[color colorWithAlphaComponent:alpha]];
        
    } else if(30 <   offsetY  && offsetY < 100 ){
        
        CGFloat alpha = MIN(1,offsetY * 1.5/(HCMScreenWidth-100));
        
        [self.navigationController.navigationBar cnSetBackgroundColor:[color colorWithAlphaComponent:alpha]];
    }else{
        
         CGFloat alpha = 100.0/(HCMScreenWidth-100);
        [self.navigationController.navigationBar cnSetBackgroundColor:[color colorWithAlphaComponent:alpha]];
    }
}



#pragma mark -- CycScrollViewDelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    NSLog(@"轮播图第%ld张",(long)index);
    
    
    
    
    
}

#pragma mark -- UITableView DataSource && Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//返回表格分区行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//定制单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        HCMDealCell *cell = [tableView dequeueReusableCellWithIdentifier:HCMDealCellID];
        
        
       cell.HCMDealModel = self.dealModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
   
    }else{
        
        HCMDealNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:HCMDealNumberCellID];
        
        cell.dealModel = self.dealModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
   // return nil;
}



#pragma mark ---- get

-(UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, HCMScreenWidth, HCMScreenHeight)];
        _scrollView.contentSize = CGSizeMake(HCMScreenWidth, HCMScreenHeight * 2);
        //设置分页效果
        _scrollView.pagingEnabled = YES;
        //禁用滚动
        _scrollView.scrollEnabled = NO;
        _scrollView.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
    }
    return _scrollView;
}

-(UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, HCMScreenWidth, HCMScreenHeight) style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        _tableView.backgroundColor = [UIColor clearColor];
        //_tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(UIWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, HCMScreenHeight, HCMScreenWidth, HCMScreenHeight- 44)];
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if ( indexPath.section == 0) {
         return 90;
    }else{
        return self.dealModel.CellHeight;
    }
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
