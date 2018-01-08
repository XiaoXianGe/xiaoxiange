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
#import "HCMSortTool.h"

@interface HCMSort_ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *sortClickView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property (weak, nonatomic) IBOutlet UIImageView *triangleIMG_ONE;
@property (weak, nonatomic) IBOutlet UIImageView *triangleIMG_TWO;
@property (weak, nonatomic) IBOutlet UIImageView *triangleIMG_THR;
//适配iPhonex 距离头部距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTOPHight;

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
    
    //初始化控制器
    [self setupViewController];
    
    //第一次加载
    [self loadGoodsFrist];
    
    //监听牌子的筛选
    [HCMNSNotificationCenter addObserver:self selector:@selector(updataSearchVC) name:@"searchMessage" object:nil];
    
}

//初始化控制器
-(void)setupViewController{
    
    _toTOPHight.constant = (HCMScreenHeight == 812.0 ? 88 : 64);
    
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
    
    CGFloat searchBarW = 0;
    if (HCMScreenWidth == 414.0) searchBarW = 240;
    if (HCMScreenWidth == 375.0) searchBarW = 210;
    if (HCMScreenWidth == 320.0) searchBarW = 150;
    
    self.searchBar.frame = CGRectMake(0, 0, searchBarW, 30);
    self.navigationItem.titleView = self.searchBar;
    //self.passwordTextfield.returnKeyType = UIReturnKeyDone;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBackHome) image:@"nav-back" highImage:@"nav-back"];
    
    UIBarButtonItem *barSearchBtn=[UIBarButtonItem itemWithTarget:self action:@selector(clickSearchBrand) image:@"nav_choose" highImage:@"nav_choose"];
    
    UIBarButtonItem *barMoreBtn=[UIBarButtonItem itemWithTarget:self action:@selector(gotoTheSearch) image:@"nav_search" highImage:@"nav_search"];
    
    NSArray *rightBtns=[NSArray arrayWithObjects:barSearchBtn,barMoreBtn, nil];
    
    self.navigationItem.rightBarButtonItems = rightBtns;
    
    self.sortClickView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"item-grid-filter-bg"]];
    
    self.collectView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreGoods)];
    self.sortWay = @"is_hot";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)gotoTheSearch{
    
    if (self.searchBar.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入搜索内容"];
        return;
    }
    
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
-(void)clickBackHome{
    
    [self.searchBar resignFirstResponder];
    
    [SVProgressHUD dismiss];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 *  封装请求
 */
-(void)loadGoods{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSDictionary *dict = [HCMSortTool sortWithDictBrand_id:_brand_id keyWords:_keyWords category_id:_category_id price_min:_price_min price_max:_price_max page:_page sortWay:_sortWay];
    
    HCMLog(@"----%@",dict);
    
    
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
    
    NSDictionary *dict = [HCMSortTool sortWithDictBrand_id:_brand_id keyWords:_keyWords category_id:_category_id price_min:_price_min price_max:_price_max page:_page sortWay:_sortWay];
    
    [[SearchNetwork sharedManager]postSubSearch:dict successBlock:^(id responseBody) {
        
        HCMLog(@"---搜索 第一次加载--%@",dict);
        
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
        HCMLog(@"----搜索 第一次加载 失败---%@",error);

        
    }];
    
    
}

/**
 *  加载更多
 */
-(void)loadMoreGoods{
    
    if (self.receiveMutArray.count < self.total) {
        
        self.page++;
        
        NSDictionary *dict =[HCMSortTool sortWithDictBrand_id:_brand_id keyWords:_keyWords category_id:_category_id price_min:_price_min price_max:_price_max page:_page sortWay:_sortWay];
        
        [[SearchNetwork sharedManager]postSubSearch:dict successBlock:^(id responseBody) {
            
            HCMLog(@"----搜索 加载更多 --%@",dict);
            
            
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

/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width =(HCMScreenWidth -30)/2;
    return CGSizeMake(width, 195*width/145);
}


/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);//上 左 下 右
}



-(void)dealloc{
    [HCMNSNotificationCenter removeObserver:self];
}
@end
