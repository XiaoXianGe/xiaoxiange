//
//  HCMHomeCollectionViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/10/11.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMHomeTopViewController.h"
#import "HCMHomeCollectionViewController.h"

#import "HomeNetwork.h"
#import "DealViewController.h"
#import "HomeCategoryCellModel.h"
#import "HCMSort_ViewController.h"

#import "CollectionViewCell.h"
#import "HCMChooseViewController.h"
#import "HCMSubCollectionViewController.h"

#import "MJRefresh.h"
#import "ViewController.h"
#import "PartnerViewController.h"
#import "HCMVipLoginViewController.h"

#import "MJExtension.h"
#import "UIButton+WebCache.h"
#import "HCMPartnerInfoModel.h"
#import "HCMPartnerCenterViewController.h"

#import "AddressNerworking.h"
#import "HCMMesageViewController.h"


@interface HCMHomeCollectionViewController ()<HCMHomeTopViewControllerDelegate>

@property (strong, nonatomic)HCMHomeTopViewController *homeTop;
@property (strong, nonatomic)NSMutableArray *receiveArray;
@property (strong, nonatomic)HWSearchBar *searchBar;

@property (strong, nonatomic)UICollectionReusableView *headerView;
@property (weak , nonatomic)UIButton *TouchButton;

@property (strong, nonatomic)UIView *diyNavView;
@property (strong, nonatomic)NSUserDefaults *defaults;
/** messageLogoBtn */
@property(nonatomic,strong)UIButton * messageLogoBtn;
@property (assign) BOOL status;

/** 记录消息是否有新消息字符串 用于滚动 */
@property(nonatomic,copy)NSString * messageMark;


@end

@implementation HCMHomeCollectionViewController

#define HCM320ViewH 1525
#define HCM375ViewH 1725
#define HCM414ViewH 1875

static NSString * const reuseIdentifier = @"Cell";






-(NSUserDefaults *)defaults
{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

-(HCMHomeTopViewController *)homeTop
{
    if (!_homeTop) {
        _homeTop = [[HCMHomeTopViewController alloc]init];
    }
    return _homeTop;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化控制器
    [self setupController];
   
    //请求首页数据
    [self sendTheMsgToCategoryForCollection];

    //自定义导航栏
    [self setNavigationBar];
    
    //添加刷新事件
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    //监听网络
    [self netWorkStatus];

}

//初始化控制器
-(void)setupController
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    
    [self addLogoAtTitleView];
    
}

-(void)addLogoAtTitleView{
    UIView * titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.frame = CGRectMake(5, 0, 60, 45);
    
    UIImage *image = [UIImage imageNamed:@"logo"];
    UIImageView *iamgeview = [[UIImageView alloc]initWithImage:image];
    iamgeview.frame = titleView.frame;
    [titleView addSubview:iamgeview];
    
    self.navigationItem.titleView = titleView;
}

//头部刷新
-(void)headerRereshing
{
    [HCMNSNotificationCenter postNotificationName:@"RereshHearView" object:nil userInfo:@{@"collection":self}];
    
    //再次请求collection数据
    [self sendTheMsgToCategoryForCollection];
   
}

//自定义头部的导航栏
-(void)setNavigationBar
{
    int diyNavViewHight =0;
    int allLogoY = 0;
    diyNavViewHight =  (HCMScreenHeight == 812.0) ? 76 : 50;
    allLogoY = (HCMScreenHeight == 812.0) ? 38 : 50;
    
    self.diyNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HCMScreenWidth, diyNavViewHight*HCMScreenWidth/320)];
//    self.diyNavView.backgroundColor = [UIColor colorWithHue:222 saturation:32 brightness:32 alpha:0.2];
    self.diyNavView.backgroundColor = HCMColor(222, 32, 32, 0.2);
    CGFloat changeH = self.diyNavView.height/allLogoY;
    
    UIButton *logoBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 22*changeH - 4, 40*HCMScreenWidth/320, 25*HCMScreenWidth/320 + 6)];
    [logoBtn setBackgroundImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [logoBtn addTarget:self action:@selector(clickLogo) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - (33 *HCMScreenWidth/320) , 20*changeH, 26*HCMScreenWidth/320, 27*HCMScreenWidth/320)];
    [msgBtn setBackgroundImage:[UIImage imageNamed:@"homeNoMsg"] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(goToMessageVC) forControlEvents:UIControlEventTouchUpInside];
    self.messageLogoBtn = msgBtn;
    
    self.searchBar = [HWSearchBar searchBar];
    
    self.searchBar.frame = CGRectMake(48*HCMScreenWidth/320, 22*changeH, HCMScreenWidth - 2*msgBtn.width-40, 25*HCMScreenWidth/320);
    [self.searchBar addTarget:self action:@selector(gotoTheSearch) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.view addSubview:self.diyNavView];
    [self.view addSubview:logoBtn];
    [self.view addSubview:msgBtn];
    [self.view addSubview:self.searchBar];
}

-(void)goToMessageVC
{
    
    if (!_status) return;
    
    self.navigationController.navigationBarHidden = NO;
    
    HCMMesageViewController *msgVC = [[HCMMesageViewController alloc]init];
    
    [self.navigationController pushViewController:msgVC animated:YES];
}

-(void)gotoTheSearch
{
    
    [self.searchBar resignFirstResponder];
    
    if (self.searchBar.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"内容不能为空"];
        return;
    }
    
    HCMSort_ViewController *passKeyWords = [[HCMSort_ViewController alloc]initWithNibName:@"HCMSort_ViewController" bundle:nil];
    
    passKeyWords.keyWords = self.searchBar.text;
    
    [self.navigationController pushViewController:passKeyWords animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [SVProgressHUD dismiss];
    
    self.tabBarController.tabBar.hidden = NO;
    

    
    self.collectionView.delegate = self;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self isMessage];

}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    self.collectionView.delegate = nil;
    [HCMNSNotificationCenter removeObserver:self];

}

-(void)clickSearchBrand
{
    
    [self.searchBar resignFirstResponder];
    
    HCMSort_ViewController *passKeyWords = [[HCMSort_ViewController alloc]initWithNibName:@"HCMSort_ViewController" bundle:nil];
    
    passKeyWords.keyWords = self.searchBar.text;
    
    [self.navigationController pushViewController:passKeyWords animated:YES];

}

//是否有消息
-(void)isMessage
{
    self.status = [self.defaults boolForKey:@"status"];
    
//        HCMLog(@"%d",self.status);
    if (self.status) {
        NSString * sid = [self.defaults objectForKey:@"sid"];
        NSString * uid = [self.defaults objectForKey:@"uid"];
        
        HCMLog(@"uid%@",uid);
        HCMLog(@"sid : %@",sid);
        
        //后台定义actionId == 1 ； 为获取未读总数 + 分类列表
        NSString * actionId = @"1";
        
        NSDictionary *postDict = [NSDictionary dictionary];
        
        postDict = @{
                     @"session":@{@"sid":sid,@"uid":uid},
                     @"actionId":actionId
                     };
        
        [[AddressNerworking sharedManager] postMessageURL:postDict successBlock:^(id responseBody) {
            
            if (![responseBody[@"data"][@"unReadTotal"] isEqual:@0]) {
                
//                HCMLog(@"首页-----%@",responseBody[@"data"][@"unReadTotal"]);
                
                if (self.collectionView.contentOffset.y > 150) {
                    [self.messageLogoBtn setBackgroundImage:[UIImage imageNamed:@"homeHaveMsg"] forState:UIControlStateNormal];
                }else{
                    [self.messageLogoBtn setBackgroundImage:[UIImage imageNamed:@"homeHaveMsg_red"] forState:UIControlStateNormal];
                }
                
                
                self.messageMark = @"homeHaveMsg_red";
                
            }else{
                [self.messageLogoBtn setBackgroundImage:[UIImage imageNamed:@"homeNoMsg"] forState:UIControlStateNormal];
                self.messageMark = @"homeNoMsg";
            }
            
        } failureBlock:^(NSString *error) {
            [SVProgressHUD showInfoWithStatus:@"请求失败"];
        }];
        
    }else{
//        [SVProgressHUD showInfoWithStatus:@"请重新登录"];
        return;
    }
}

-(void)clickLogo
{
    //适配iPhoneX 
    int TopHight = HCMScreenHeight == 812.0 ? -44 : 0;
   [self.collectionView setContentOffset:CGPointMake(0, TopHight) animated:YES];
//    ViewController *vc = [[ViewController alloc]init];
//    vc.goods_id = @"318";
//    [self.navigationController pushViewController:vc animated:YES];
//    [SVProgressHUD show];

}

//发送请求数据
-(void)sendTheMsgToCategoryForCollection
{
    
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
//    [self.view endEditing:YES];
    CGFloat alphaValue = scrollView.contentOffset.y;
    if (scrollView.contentOffset.y > 15 && scrollView.contentOffset.y <= 150) {
        
        self.diyNavView.backgroundColor = [UIColor colorWithHue:222 saturation:32 brightness:32 alpha:alphaValue / 15 * 0.1 * 0.8];
        
        if ([_messageMark isEqualToString:@"homeHaveMsg_red"]) {
            
            [self.messageLogoBtn setBackgroundImage:[UIImage imageNamed:_messageMark] forState:UIControlStateNormal];
        }
        
    }else if(scrollView.contentOffset.y <= 15 ){
        
//        self.diyNavView.backgroundColor = [UIColor colorWithHue:222 saturation:32 brightness:32 alpha:0.1];
        self.diyNavView.backgroundColor = HCMColor(222, 32, 32, 0.1);
    }
    
    if (scrollView.contentOffset.y > 150 && [_messageMark isEqualToString:@"homeHaveMsg_red"]) {
        [self.messageLogoBtn setBackgroundImage:[UIImage imageNamed:@"homeHaveMsg"] forState:UIControlStateNormal];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.receiveArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.categoryModel = self.receiveArray[indexPath.row];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeCategoryCellModel *sort = self.receiveArray[indexPath.row];
    
    [self pusuDealView:sort.goods_id];
    
}

- (void)pusuDealView:(NSString *)goods_id
{
    DealViewController *dealVc = [[DealViewController alloc]initWithNibName:@"DealViewController" bundle:nil];
    
    dealVc.goods_id = goods_id;
    
    [self.navigationController pushViewController:dealVc animated:YES];
}

/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width =(HCMScreenWidth -30)/2;
    return CGSizeMake(width, 200*width/145);
}

/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);//上 左 下 右
}

//为collection插入头视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableview = self.headerView;
    }
    
    if (HCMScreenWidth == 414.0) {
        //6p
        self.homeTop.view.frame = CGRectMake(0, -20, self.view.frame.size.width, HCM414ViewH + 30);
        
    }else if(HCMScreenWidth == 375.0){
        //6
        self.homeTop.view.frame = CGRectMake(0, -20, self.view.frame.size.width, HCM375ViewH + 30);
        
    }else{
        //5
        self.homeTop.view.frame = CGRectMake(0, -20, self.view.frame.size.width, HCM320ViewH + 30);
        
    }
    
    self.homeTop.delegate = self;
    self.homeTop.view.clipsToBounds = YES;
    [reusableview addSubview:self.homeTop.view];
    
    return reusableview;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    CGFloat cellH = 0;
    
    if (HCMScreenWidth == 414.0) {
        //6p
        cellH = HCM414ViewH;
        
    }else if(HCMScreenWidth == 375.0){
        //6
        cellH = HCM375ViewH;
        
    }else if(HCMScreenWidth == 320.0){
        //5
        cellH = HCM320ViewH;
        
    }
    return CGSizeMake(HCMScreenWidth, cellH);
}

#pragma mark --- 协议
-(void)touchGBTopLineView:(id)type title:(id)title
{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
    UIViewController *vc = [[UIViewController alloc]init];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0, HCMScreenWidth,HCMScreenHeight)];

//    NSString *url = @"http://www.haocaimao.com/culture.html";

    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.haocaimao.com/culture.html"]]];
    
    vc.title = @"企业简介";
    vc.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];

    [vc.view addSubview:webView];

    [self.navigationController pushViewController:vc animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
}

-(void)clickBack
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchClickPrassCategory:(HCMHomeTopViewController *)mothed tag:(NSString *)tag number:(NSInteger)number
{
    
    [self.searchBar resignFirstResponder];
    
    HCMSort_ViewController *SortVC = [[HCMSort_ViewController alloc]initWithNibName:@"HCMSort_ViewController" bundle:nil];
    
    if ( number < 39) {
         SortVC.category_id = tag;
    }else {
        SortVC.brand_id = [tag integerValue];
    }
    
    [self.navigationController pushViewController:SortVC animated:YES];
    
}

-(void)touchClickToScene:(HCMHomeTopViewController *)delegate url:(NSString *)url
{
    
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

-(void)touchClickToBanner:(HCMHomeTopViewController *)delegate goodsID:(NSString *)goodsID
{
    
    [self.searchBar resignFirstResponder];
    
    if ([goodsID isEqualToString:@"69"]) {
        
        HCMSubCollectionViewController *subCOllVC = [[HCMSubCollectionViewController alloc]initWithNibName:@"HCMSubCollectionViewController" bundle:nil];
        
        subCOllVC.urlStr = @"24";
        
        [self.navigationController pushViewController:subCOllVC animated:YES];
        return;
    }
    
    DealViewController *vc = [[DealViewController alloc]initWithNibName:@"DealViewController" bundle:nil];
    
    vc.goods_id = goodsID;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(void)touchClickToAdvertise:(HCMHomeTopViewController *)delegate goodsID:(NSString *)goodsID
{
    
    [self.searchBar resignFirstResponder];
    
    DealViewController *vc = [[DealViewController alloc]initWithNibName:@"DealViewController" bundle:nil];
    
    vc.goods_id = goodsID;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 * 申请成为合伙人
 */
-(void)gotoPartnerCenter:(HCMHomeTopViewController *)delegate
{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
     self.status = [self.defaults boolForKey:@"status"];
    
    if (self.status) {
        
        NSString * sid = [self.defaults objectForKey:@"sid"];
        NSString * uid = [self.defaults objectForKey:@"uid"];
        HCMLog(@"sid : %@",sid);
        
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
-(void)userLogin
{
    HCMVipLoginViewController *vipLoginVC = [[HCMVipLoginViewController alloc]init];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController pushViewController:vipLoginVC animated:YES];
}

//监听网络
-(void)netWorkStatus{
    
    AFNetworkReachabilityManager *statusManager = [AFNetworkReachabilityManager sharedManager];
    [statusManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
                [SVProgressHUD showInfoWithStatus:@"网络中断"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"3G 或者 WIFI");
                [self.collectionView.header beginRefreshing];
                
                //通知加载tabbar中间咨询按钮
                [HCMNSNotificationCenter postNotificationName:@"loadTabbarAdvisoryIcon" object:nil];
                break;
                
            default:
                break;
        }
    }];
    //3.开始监听
    [statusManager startMonitoring];
}


-(void)dealloc
{
    [HCMNSNotificationCenter removeObserver:self];
}

@end
