//
//  HCMSort_ViewController.m
//  haocaimao
//
//  Created by 李芷贤 on 15/9/14.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMSort_ViewController.h"
#import "HWSearchBar.h"
#import "UIBarButtonItem+Extension.h"
#import "HCMEnshrineCell.h"
#import "DealViewController.h"
#import "HomeNetwork.h"
#import "SearchNetwork.h"
#import "UserEnshrine.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "SortBrandFiltrate.h"
#import "BrandViewController.h"
#import "UIView+Extension.h"

@interface HCMSort_ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *sortClickView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property (weak, nonatomic) IBOutlet UIImageView *triangleIMG_ONE;
@property (weak, nonatomic) IBOutlet UIImageView *triangleIMG_TWO;
@property (weak, nonatomic) IBOutlet UIImageView *triangleIMG_THR;
@property (strong,nonatomic)NSMutableArray *receiveMutArray;
@property (strong,nonatomic)HWSearchBar *searchBar;
@property (strong,nonatomic) NSString *sortWay;
@property (assign,nonatomic) NSInteger total;
@property (assign,nonatomic) int page;
@property (assign,nonatomic) BOOL Mark;
@property (strong, nonatomic) UIImageView *noDataView;
@property (assign,nonatomic)BOOL isOver;

@end

static NSString * const reuseIdentifier = @"Cell";

@implementation HCMSort_ViewController

- (UIImageView *)noDataView{
    if (!_noDataView) {
        
        UIImageView * noDataView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"no-ConformToThe"]];
        noDataView.y = 130;
        noDataView.centerX = HCMScreenWidth/2;
        [self.view addSubview:noDataView];
        //[noDataView autoCenterInSuperview];
        _noDataView = noDataView;
    }
    return _noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.triangleIMG_ONE.hidden =NO;
    self.triangleIMG_TWO.hidden =YES;
    self.triangleIMG_THR.hidden =YES;
    
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    
    self.collectView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"index-body-bg"]];
    
    //自动调整滚动视图插图(自动调整scorllview高度)
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.collectView registerNib:[UINib nibWithNibName:@"HCMEnshrineCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    //防止数据不够不能拖动
    self.collectView.alwaysBounceVertical = YES;
    
    //搜索框
    self.searchBar = [HWSearchBar searchBar];
    [self.searchBar addTarget:self action:@selector(gotoTheSearch) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.searchBar.frame = CGRectMake(0, 0, 150, 30);
    self.navigationItem.titleView = self.searchBar;
    //self.passwordTextfield.returnKeyType = UIReturnKeyDone;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    UIBarButtonItem *barSearchBtn=[UIBarButtonItem itemWithTarget:self action:@selector(clickSearchBrand) image:@"nav_choose" highImage:@"nav_choose"];
    
    UIBarButtonItem *barMoreBtn=[UIBarButtonItem itemWithTarget:self action:@selector(gotoTheSearch) image:@"nav_search" highImage:@"nav_search"];
    
    NSArray *rightBtns=[NSArray arrayWithObjects:barSearchBtn,barMoreBtn, nil];
    
    self.navigationItem.rightBarButtonItems = rightBtns;
    
    self.sortClickView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 40);
    self.collectView.frame = CGRectMake(0, 104, self.sortClickView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 104);

    self.sortClickView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"item-grid-filter-bg"]];
    
    self.collectView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreGoods)];
    self.sortWay = @"is_hot";
    //第一次加载
    [self loadGoodsFrist];
    
    //监听牌子的筛选
    [HCMNSNotificationCenter addObserver:self selector:@selector(updataSearchVC) name:@"searchMessage" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)gotoTheSearch{
    
    [self.searchBar resignFirstResponder];
    
    [self.noDataView removeFromSuperview];
    
    self.category_id = nil;//self.brand_id = Nil;
    self.brand_id = 0;
    self.keyWords = self.searchBar.text;
    
    [self loadGoodsFrist];
    
    
}

-(void)updataSearchVC{
    [self loadGoodsFrist];
}

/**
 *  搜索牌子
 */

-(void)clickSearchBrand{
    
    [self.searchBar resignFirstResponder];
    
    [SVProgressHUD dismiss];
    
    BrandViewController *BrandVC = [[BrandViewController alloc]initWithNibName:@"BrandViewController" bundle:nil];
    if (self.category_id!=nil) {
        
        BrandVC.category_id = self.category_id;
        
        [self.navigationController pushViewController:BrandVC animated:YES];
        
    }else{
        [self.navigationController pushViewController:BrandVC animated:YES];

    }
    
}
/**
 *  返回
 */
-(void)clickBack{
    
    [SVProgressHUD dismiss];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  判断是从哪里 跳进 排序VIew
 */
-(NSDictionary *)inputWayOfTheSort{
    
    NSDictionary *dict = [NSMutableDictionary dictionary];
    if (self.brand_id) {
    dict=@{@"filter":@{@"sort_by":self.sortWay,@"brand_id":@(self.brand_id)},@"pagination":@{@"count":@"20",@"page":@(self.page)}};
        
        
    }
    if (self.keyWords) {
        dict = @{@"filter":@{@"sort_by":self.sortWay,@"keywords":self.keyWords},@"pagination":@{@"count":@"20",@"page":@(self.page)}};
    }
    if (self.category_id) {
        dict = @{@"filter":@{@"sort_by":self.sortWay,@"category_id":self.category_id},@"pagination":@{@"count":@"20",@"page":@(self.page)}};
    }
    
    if (self.category_id && self.brand_id) {
        dict = @{@"filter":@{@"sort_by":self.sortWay,@"category_id":self.category_id,@"brand_id":@(self.brand_id)},@"pagination":@{@"count":@"20",@"page":@(self.page)}};

    }
    
    if (self.category_id && self.keyWords) {
        dict = @{@"filter":@{@"sort_by":self.sortWay,@"category_id":self.category_id,@"keywords":self.keyWords},@"pagination":@{@"count":@"20",@"page":@(self.page)}};
    }
    
    if (self.brand_id && self.keyWords) {
        dict = @{@"filter":@{@"sort_by":self.sortWay,@"brand_id":@(self.brand_id),@"keywords":self.keyWords},@"pagination":@{@"count":@"20",@"page":@(self.page)}};
    }
    
    if(self.brand_id && self.keyWords && self.category_id){
         dict =  @{@"filter":@{@"sort_by":self.sortWay,@"category_id":self.category_id,@"keywords":self.keyWords,@"brand_id":@(self.brand_id)},@"pagination":@{@"count":@"20",@"page":@(self.page)}};
        
    }
    if(self.category_id && self.brand_id && self.price_min && self.price_max){
        dict = @{@"filter":@{@"price_range":@{@"price_max":self.price_max,@"price_min":self.price_min},@"brand_id":@(self.brand_id),@"category_id":self.category_id,@"sort_by":self.sortWay},@"pagination":@{@"count":@"20",@"page":@(self.page)}};
    }
    
   
    return dict;
    
}

/**
 *  封装请求
 */
-(void)loadGoods{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSDictionary *dict = [self inputWayOfTheSort];
    [[SearchNetwork sharedManager]postSubSearch:dict successBlock:^(id responseBody) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dict in responseBody[@"data"]) {
            
            UserEnshrine *sort = [UserEnshrine parseEnshrineData:dict];
            
            [array addObject:sort];
        }
        
        self.receiveMutArray = array;
        
        [self.collectView reloadData];
        
        [SVProgressHUD dismiss];
        
        [self.collectView setContentOffset:CGPointMake(0, 0) animated:NO];
        
    } failureBlock:^(NSString *error) {
        
       [SVProgressHUD showInfoWithStatus:error];
        
    }];
}

/**
 *  第一次加载
 */
-(void)loadGoodsFrist{
    
    self.noDataView.hidden = YES;
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
    self.page = 1;
    
    NSDictionary *dict = [self inputWayOfTheSort];
    
    [[SearchNetwork sharedManager]postSubSearch:dict successBlock:^(id responseBody) {
        
        //筛选商品的总数
        self.total = [responseBody[@"paginated"][@"total"] integerValue];
                
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dict in responseBody[@"data"]) {
            
            UserEnshrine *sort = [UserEnshrine parseEnshrineData:dict];
            
            [array addObject:sort];
        }
        
        self.isOver = NO;
        
        if (array.count < 20 ) {
            [self.collectView.footer noticeNoMoreData];
            [SVProgressHUD showSuccessWithStatus:@"已全部加载"];
        }
        
        self.receiveMutArray = array;
        [self.collectView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.collectView reloadData];
        
        if (self.receiveMutArray.count == 0) {
            self.noDataView.hidden = NO;
        }
        
        [SVProgressHUD dismiss];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:error];
        
    }];
    
    
}

/**
 *  加载更多
 */
-(void)loadMoreGoods{
    
    if (self.receiveMutArray.count < self.total) {
        
        self.page++;
        
        NSDictionary *dict = [self inputWayOfTheSort];
        
        [[SearchNetwork sharedManager]postSubSearch:dict successBlock:^(id responseBody) {
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (NSDictionary *dict in responseBody[@"data"]) {
                
                UserEnshrine *sort = [UserEnshrine parseEnshrineData:dict];
                
                [array addObject:sort];
            }
            
            if (self.isOver == YES)  {
                [self.collectView.footer noticeNoMoreData];
                return;
            }
            
            if (array.count < 20) {
                [self.collectView.footer noticeNoMoreData];
                self.isOver = YES;
            }
            
            [self.receiveMutArray addObjectsFromArray:array];
            
            [self.collectView reloadData];
            [self.collectView.footer endRefreshing];
            
        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:error];
            
        }];
    }else{
        
        [self.collectView.footer noticeNoMoreData];
        
        [SVProgressHUD showSuccessWithStatus:@"已全部加载"];
    }
}

/**
 *  拖动隐藏键盘
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

#pragma mark --- <人气排行,价格最低,价格最高>

/**
 *  人气排行
 */
- (IBAction)popularitySort:(UIButton *)sender {

    self.triangleIMG_ONE.hidden =NO;
    self.triangleIMG_TWO.hidden =YES;
    self.triangleIMG_THR.hidden =YES;
    
    self.page = 1;
    self.sortWay = @"is_hot";
    [self loadGoods];
    
    if (self.total == 0) {
        
        [SVProgressHUD showSuccessWithStatus:@"商品没上架"];
        
        self.noDataView.hidden = NO;
    }
    
}

/**
 *  价格最低
 */
- (IBAction)minPriceSort:(UIButton *)sender {

    self.triangleIMG_ONE.hidden =YES;
    self.triangleIMG_TWO.hidden =NO;
    self.triangleIMG_THR.hidden =YES;
    
    self.page = 1;
    self.sortWay = @"price_asc";
    [self loadGoods];
    
    if (self.total == 0) {
        
        [SVProgressHUD showSuccessWithStatus:@"商品没上架"];
        
        self.noDataView.hidden = NO;
    }
}

/**
 *  价格最高
 */
- (IBAction)maxPriceSort:(UIButton *)sender {

    self.triangleIMG_ONE.hidden =YES;
    self.triangleIMG_TWO.hidden =YES;
    self.triangleIMG_THR.hidden =NO;
    
    self.page = 1;
    self.sortWay = @"price_desc";
    
    [self loadGoods];
    
    if (self.total == 0) {
        
        [SVProgressHUD showSuccessWithStatus:@"商品没上架"];
        
        self.noDataView.hidden = NO;
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.receiveMutArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HCMEnshrineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor lightGrayColor];
    
    cell.index_path = indexPath;
    
    cell.enshrine = self.receiveMutArray[indexPath.row];
    
    cell.cilckDlete.hidden = YES;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UserEnshrine *sort = self.receiveMutArray[indexPath.row];
    
    DealViewController *dealVc = [[DealViewController alloc]initWithNibName:@"DealViewController" bundle:nil];
    
    [self.searchBar resignFirstResponder];
    
    dealVc.goods_id = sort.goods_id;
    
    [self.navigationController pushViewController:dealVc animated:YES];
    
}

-(void)dealloc{
    [HCMNSNotificationCenter removeObserver:self];
}
@end
