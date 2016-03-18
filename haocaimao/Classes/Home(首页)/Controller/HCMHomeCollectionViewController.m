//
//  HCMHomeCollectionViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/10/11.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMHomeCollectionViewController.h"
#import "HCMHomeTopViewController.h"

#import "HCMSort_ViewController.h"
#import "HomeNetwork.h"
#import "HomeCategoryCellModel.h"
#import "DealViewController.h"

#import "CollectionViewCell.h"
#import "HCMSubCollectionViewController.h"
#import "HCMChooseViewController.h"

#import "MJRefresh.h"
#import "ViewController.h"
#import "PartnerViewController.h"
#import "HCMVipLoginViewController.h"

#import "HCMPartnerInfoModel.h"
#import "MJExtension.h"
#import "HCMPartnerCenterViewController.h"

@interface HCMHomeCollectionViewController ()<HCMHomeTopViewControllerDelegate>

@property (strong, nonatomic)HCMHomeTopViewController *homeTop;
@property (strong, nonatomic)NSMutableArray *receiveArray;
@property (strong, nonatomic)HWSearchBar *searchBar;
@property (strong, nonatomic)UICollectionReusableView *headerView;
@property (weak , nonatomic)UIButton *TouchButton;

@property (strong, nonatomic)UIView *diyNavView;

@property (strong, nonatomic)NSUserDefaults *defaults;
@property (assign) BOOL status;
@end

@implementation HCMHomeCollectionViewController

static NSString * const reuseIdentifier = @"Cell";



-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}


-(HCMHomeTopViewController *)homeTop{
    if (!_homeTop) {
        _homeTop = [[HCMHomeTopViewController alloc]init];
    }
    return _homeTop;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    
    //请求首页数据
    [self sendTheMsgToCategoryForCollection];

    //自定义导航栏
    [self setNavigationBar];
    
    //添加刷新事件
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    
    //数据生成32位字符串
    //NSLog(@"-----%@",[self ret32bitString]);
    
    //[self dosomeThing];
    
}

-(void)dosomeThing{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 32; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 65;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    NSLog(@"%@", string);
}

-(NSString *)ret32bitString{
    
    char data[32];
    
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}


//头部刷新
-(void)headerRereshing{
    
    [HCMNSNotificationCenter postNotificationName:@"RereshHearView" object:nil userInfo:@{@"collection":self}];
    
    //再次请求collection数据
    [self sendTheMsgToCategoryForCollection];
   
}

//自定义头部的导航栏
-(void)setNavigationBar{
    
    self.diyNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    self.diyNavView.backgroundColor = [UIColor colorWithHue:222 saturation:32 brightness:32 alpha:0.2];
    
    UIButton *logoBtn = [[UIButton alloc]initWithFrame:CGRectMake(2, 22, 40, 25)];
    [logoBtn setBackgroundImage:[UIImage imageNamed:@"logo-icon"] forState:UIControlStateNormal];
    [logoBtn addTarget:self action:@selector(clickLogo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnSearch = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 45  , 22, 40, 25)];
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(gotoTheSearch) forControlEvents:UIControlEventTouchUpInside];
    
    self.searchBar = [HWSearchBar searchBar];
    self.searchBar.frame = CGRectMake(48, 22, self.view.frame.size.width - 100, 25);
    [self.searchBar addTarget:self action:@selector(gotoTheSearch) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.view addSubview:self.diyNavView];
    [self.view addSubview:logoBtn];
    [self.view addSubview:btnSearch];
    [self.view addSubview:self.searchBar];
}


-(void)gotoTheSearch{
    
    [self.searchBar resignFirstResponder];
    
    HCMSort_ViewController *passKeyWords = [[HCMSort_ViewController alloc]initWithNibName:@"HCMSort_ViewController" bundle:nil];
    
    passKeyWords.keyWords = self.searchBar.text;
    
    [self.navigationController pushViewController:passKeyWords animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [SVProgressHUD dismiss];
    
    self.tabBarController.tabBar.hidden = NO;
    self.collectionView.delegate = self;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBarHidden = YES;
    
    //注册键盘出现的通知
    [HCMNSNotificationCenter addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏的通知
    [HCMNSNotificationCenter addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
   
    
}



-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.collectionView.delegate = nil;
    [HCMNSNotificationCenter removeObserver:self];

}

-(void)clickSearchBrand{
    
    [self.searchBar resignFirstResponder];
    
    HCMSort_ViewController *passKeyWords = [[HCMSort_ViewController alloc]initWithNibName:@"HCMSort_ViewController" bundle:nil];
    
    passKeyWords.keyWords = self.searchBar.text;
    
    [self.navigationController pushViewController:passKeyWords animated:YES];

}

-(void)clickLogo{
   [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
//    ViewController *vc = [[ViewController alloc]init];
//    vc.goods_id = @"318";
//    [self.navigationController pushViewController:vc animated:YES];
//    [SVProgressHUD show];

}

//发送请求数据
-(void)sendTheMsgToCategoryForCollection{
    
    [[HomeNetwork sharedManager]postHomeCategoryGoods:nil successBlock:^(id responseBody) {
        
        //13个数组
        NSArray *dataArr = responseBody[@"data"];
        
        NSMutableArray *categoryMutArray = [NSMutableArray new];
        NSMutableArray *goodArr = [NSMutableArray array];
       
        //遍历13个数组
        for (NSDictionary *categoryDic in dataArr) {
            [goodArr addObject:categoryDic[@"goods"]];
        }
        for (NSArray *arr in goodArr) {
            for (NSDictionary *dict in arr) {
                HomeCategoryCellModel *category = [HomeCategoryCellModel collectionGoodsWithCategoryJSON:dict];
                [categoryMutArray addObject:category];
            }
        }
        self.receiveArray = [categoryMutArray copy];
        
        [self.collectionView reloadData];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:error];
        
    }];
    
     [self.collectionView.header endRefreshing];
    
}

//拖动视图,隐藏键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
    
    CGFloat alphaValue = scrollView.contentOffset.y;
    if (scrollView.contentOffset.y > 15 && scrollView.contentOffset.y <= 150) {
        
        self.diyNavView.backgroundColor = [UIColor colorWithHue:222 saturation:32 brightness:32 alpha:alphaValue / 15 * 0.1 * 0.8];
        
    }else if(scrollView.contentOffset.y <= 15 ){
        
        self.diyNavView.backgroundColor = [UIColor colorWithHue:222 saturation:32 brightness:32 alpha:0.1];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.receiveArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.categoryModel = self.receiveArray[indexPath.row];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeCategoryCellModel *sort = self.receiveArray[indexPath.row];
    
    [self pusuDealView:sort.goods_id];
    
}
- (void)pusuDealView:(NSString *)goods_id{
    DealViewController *dealVc = [[DealViewController alloc]initWithNibName:@"DealViewController" bundle:nil];
    
    dealVc.goods_id = goods_id;
    
    [self.navigationController pushViewController:dealVc animated:YES];
}
//为collection插入头视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableview = self.headerView;
    }
    
    self.homeTop.view.frame = CGRectMake(0, -20, self.view.frame.size.width, 1495);
    self.homeTop.delegate = self;
    self.homeTop.view.clipsToBounds = YES;
    [reusableview addSubview:self.homeTop.view];
    
    return reusableview;

}


#pragma mark --- 协议
-(void)touchClickPrassCategory:(HCMHomeTopViewController *)mothed tag:(NSString *)tag number:(NSInteger)number{
    
    [self.searchBar resignFirstResponder];
    
    HCMSort_ViewController *SortVC = [[HCMSort_ViewController alloc]initWithNibName:@"HCMSort_ViewController" bundle:nil];
    
    if ( number < 39) {
         SortVC.category_id = tag;
    }else {
        SortVC.brand_id = [tag integerValue];
    }
    
    [self.navigationController pushViewController:SortVC animated:YES];
    
}


-(void)touchClickToScene:(HCMHomeTopViewController *)delegate url:(NSString *)url{
    
    [self.searchBar resignFirstResponder];
    
    if ([url isEqualToString:@"29"]) {
        HCMChooseViewController *vc = [[HCMChooseViewController alloc]initWithNibName:@"HCMChooseViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        HCMSubCollectionViewController *subCOllVC = [[HCMSubCollectionViewController alloc]initWithNibName:@"HCMSubCollectionViewController" bundle:nil];
        
        subCOllVC.urlStr = url;
        
        [self.navigationController pushViewController:subCOllVC animated:YES];
    }
    
}

-(void)touchClickToBanner:(HCMHomeTopViewController *)delegate goodsID:(NSString *)goodsID{
    
    [self.searchBar resignFirstResponder];
    
    DealViewController *vc = [[DealViewController alloc]initWithNibName:@"DealViewController" bundle:nil];
    
    vc.goods_id = goodsID;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(void)touchClickToAdvertise:(HCMHomeTopViewController *)delegate goodsID:(NSString *)goodsID{
    
    [self.searchBar resignFirstResponder];
    
    DealViewController *vc = [[DealViewController alloc]initWithNibName:@"DealViewController" bundle:nil];
    
    vc.goods_id = goodsID;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)keyboardWasShown:(NSNotification *)notification{
    
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, HCMScreenWidth, HCMScreenHeight - 64 - keyBoardFrame.size.height)];
    [btn addTarget:self action:@selector(TouchEvent) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor clearColor];
    self.TouchButton = btn;
    [self.view addSubview:self.TouchButton];
    
}

//申请成为合伙人
-(void)gotoPartnerCenter:(HCMHomeTopViewController *)delegate{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
     self.status = [self.defaults boolForKey:@"status"];
    
    if (self.status) {
        NSString * sid = [self.defaults objectForKey:@"sid"];
        NSString * uid = [self.defaults objectForKey:@"uid"];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                
        params[@"session"] = @{@"sid":sid,@"uid":uid};

        [[HomeNetwork sharedManager]postPartnerFormURL:params successBlock:^(id responseBody) {
            HCMLog(@"%@",responseBody);
            
            if (responseBody[@"status"][@"error_desc"]) {
                [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
                
                [self userLogin];
                
                return ;
            }
            
            NSString *str = [NSString stringWithFormat:@"%@",responseBody[@"data"][@"salesPartnerStatus"]];
            
            if ([str isEqualToString:@"0"]) {
                //未注册和合伙人 跳到申请界面
                HCMLog(@"未注册和合伙人");

                HCMPartnerInfoModel *partnerModel = [HCMPartnerInfoModel objectWithKeyValues:responseBody[@"data"][@"userProfile"]];
                
                PartnerViewController *partner = [[PartnerViewController alloc]initWithNibName:@"PartnerViewController" bundle:nil];
                
                partner.email = partnerModel.email;
                partner.mobilePhone = partnerModel.mobilePhone;
                partner.sex = [partnerModel.sex integerValue];
                
                [self.navigationController pushViewController:partner animated:YES];
            }else{
                //已注册合伙人 显示合伙人收益信息
                HCMLog(@"已注册合伙人");
                HCMPartnerCenterViewController *vc =[[HCMPartnerCenterViewController alloc]init];
                
                [self.navigationController pushViewController:vc animated:YES];
            
            }
        } failureBlock:^(NSString *error) {
            HCMLog(@"合伙人失败");
            [SVProgressHUD showInfoWithStatus:@"请求失败"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        
        }];
        return;
        
    }else{
        
        //这里是非登录状态(!_self.status)
        [SVProgressHUD showInfoWithStatus:@"客官,请先登录~"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [self userLogin];
    }
    
}

/**
 * 用户登录
 */
-(void)userLogin{
    HCMVipLoginViewController *vipLoginVC = [[HCMVipLoginViewController alloc]init];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController pushViewController:vipLoginVC animated:YES];
}

-(void)TouchEvent{
    [self.TouchButton removeFromSuperview];
    [self.searchBar endEditing:YES];
}
-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.TouchButton removeFromSuperview];
    
}

-(void)dealloc{
    [HCMNSNotificationCenter removeObserver:self];
}

@end
