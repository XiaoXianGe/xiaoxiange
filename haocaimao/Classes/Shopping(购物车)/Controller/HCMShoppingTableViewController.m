     //
//  HCMShoppingTableViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/14.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMShoppingTableViewController.h"
#import "HCMFlowCheckOrderTableViewController.h"
#import "HCMAddLocationTableViewController.h"

#import "HCMCartCell.h"
#import "CategoryGoods.h"
#import "CartGoodsModel.h"
#import "CartDoodsListModel.h"
#import "CartTotalListModel.h"
#import "CartListFrame.h"

#import "CartShopGoodModel.h"
#import "AddressNerworking.h"
#import "CartNetwork.h"

#import "HCMbuyView.h"
#import "HCMCartSection.h"
#import "FootPopView.h"

#import "DealViewController.h"
#import "AlartViewController.h"
#import "HCMFlowCheckOrderTableViewController.h"

@interface HCMShoppingTableViewController ()<HCMCartCellDelegate,UIAlertViewDelegate,ExpendableAlartViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;

@property (strong, nonatomic) IBOutlet UIView *deleteFootView;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTotal;
@property (strong, nonatomic) CartListFrame *frame;

@property (nonatomic, strong)NSMutableArray *cartListFrame;
@property (nonatomic, strong)CartTotalListModel *cartTotal;
@property (strong, nonatomic) HCMbuyView *buyView;
@property (strong, nonatomic) FootPopView *popView;

@property (strong, nonatomic) UICollectionView *fool;
@property (strong, nonatomic) NSMutableArray *allShopName;
@property (strong, nonatomic) NSMutableArray *sectionArr;
@property (weak, nonatomic) UIWindow *window;
@property (assign, nonatomic) CGPoint scrollViewPoint;

@property (nonatomic, strong)NSString *sid;
@property (nonatomic, strong)NSString *uid;
@property (assign, nonatomic) BOOL status;
@property (weak, nonatomic) UIButton *animaBtn;
@property (nonatomic, strong)NSUserDefaults *defaults;
@property(nonatomic,strong)NSString * deleteGoodsID;/** 记录删除商品的ID */
@end

@implementation HCMShoppingTableViewController
static NSString *ID = @"Cell";
    

-(NSUserDefaults *)defaults
{
    
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}//数据持久化

- (CartTotalListModel *)cartTotal
{
    
    if (!_cartTotal) {
        _cartTotal = [[CartTotalListModel alloc]init];
    }
    return _cartTotal;
}//数据

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    self.title = @"购物车";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"index-body-bg"]];
    
    [HCMNSNotificationCenter addObserver:self selector:@selector(pop:) name:@"pop" object:self.popView];
    [HCMNSNotificationCenter addObserver:self selector:@selector(buyClick:) name:@"clickCollectionView" object:nil];
    [HCMNSNotificationCenter addObserver:self selector:@selector(scrollAndUserInteraction) name:@"scrollAndUserInteraction" object:nil];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)buyClick:(NSNotification *)notification
{
    
    NSString *goods_id = [NSString stringWithFormat:@"%@", notification.userInfo[@"good_id"]];
    
    DealViewController *deal = [[DealViewController alloc]initWithNibName:@"DealViewController" bundle:nil];
    deal.goods_id = goods_id;
    [self.navigationController pushViewController:deal animated:YES];
    
}

- (void)pushGoods:(NSString *)goods_id
{
    
    DealViewController *vc = [[DealViewController alloc]initWithNibName:@"DealViewController" bundle:nil];
    vc.goods_id = goods_id;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)loadMoneyView
{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];

    self.window = window;
    
    self.footerView.frame = CGRectMake(0, HCMScreenHeight - 94, HCMScreenWidth, 45);
    self.deleteFootView.frame = CGRectMake(0, HCMScreenHeight - 94, HCMScreenWidth, 45);
    
    [window addSubview:self.deleteFootView];
    self.deleteFootView.hidden = YES;
    
    [window addSubview:self.footerView];
    self.footerView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.footerView.hidden = YES;
    self.deleteFootView.hidden = YES;
    [self.footerView removeFromSuperview];
    [self.deleteFootView removeFromSuperview];
    self.animaBtn.selected = NO;
    self.popView.fool.alpha = 1;
    [self.tableView.header endRefreshing];

}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    self.footerView.hidden = YES;
    self.deleteFootView.hidden = YES;
    
}

- (void)setupNavi
{
    if (self.status) {
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickShop:) title:@"编辑" selectedTitle:@"完成"];
    }
}

- (void)clickShop:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.footerView.hidden = YES;
        self.deleteFootView.hidden = NO;
    }else{
        self.footerView.hidden = NO;
        self.deleteFootView.hidden = YES;
    }
    
}

//猜你喜欢
- (void)setupView
{
    FootPopView *popView = [[FootPopView alloc]init];
    [[CartNetwork sharedManager]postguessLike:nil successBlock:^(id responseBody) {
        NSArray *array = responseBody[@"data"];
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            CategoryGoods *goods = [CategoryGoods parsingDataOfDict:dic];
            [mutableArray addObject:goods];
        }
        popView.goods = mutableArray;

    } failureBlock:^(NSString *error) {
    }];
    self.popView = popView;
   
    
}

- (void)pop:(NSNotification *)notification
{
    self.animaBtn = notification.userInfo[@"popBtn"];
    [self.animaBtn addTarget:self action:@selector(animateBtn:) forControlEvents:UIControlEventTouchUpInside];

    self.fool = notification.userInfo[@"fool"];
    
}

- (void)animateBtn:(UIButton *)popBtn
{
    
    popBtn.selected = !popBtn.selected;
    
    [popBtn setImage:[UIImage imageNamed:@"item-info-popView"] forState:UIControlStateSelected];
    
    if (self.status) {
        //
        
        if (popBtn.selected) {
            
            [UIView animateWithDuration:0.5 animations:^{
                self.popView.frame = CGRectMake(0,  self.scrollViewPoint.y +HCMScreenHeight - 90 - 45, HCMScreenWidth, 230);
                self.popView.fool.alpha = 0;
            }];
            
        }else{
            
            [UIView animateWithDuration:0.5 animations:^{
                self.tableView.tableFooterView = self.popView;
                self.popView.fool.alpha = 1;

            } ];

        }

    }else{
        
        if (popBtn.selected) {
            
            [UIView animateWithDuration:0.5 animations:^{
                self.popView.frame = CGRectMake(0,  self.scrollViewPoint.y +HCMScreenHeight-90, HCMScreenWidth, 230);
                self.popView.fool.alpha = 0;
            }];
            
        }else{
            
            [UIView animateWithDuration:0.5 animations:^{
                self.tableView.tableFooterView = self.popView;
                self.popView.fool.alpha = 1;

            } ];
            
        }
        

    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.scrollViewPoint = scrollView.contentOffset;
}

- (void)loadBackgroundView
{
    HCMbuyView *buyView = [[HCMbuyView alloc]init];
    self.buyView = buyView;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    if (![self.defaults boolForKey:@"status"]){
        
        [self.cartListFrame removeAllObjects];
        [self.allShopName removeAllObjects];
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];

        [self setUPcontroller];

        return;
    }
    
    self.tableView.header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setUPcontroller];
        [self network];
        
    }];
    [self.tableView.header beginRefreshing];
    [self loadMoneyView];
}

-(void)setUPcontroller
{
    if (!self.status) {
        if (self.buyView ==nil) [self loadBackgroundView];
    }else{
        self.footerView.hidden = NO;
        self.deleteFootView.hidden = YES;
    }
    if (self.popView == nil) {
        [self setupView];
        self.tableView.tableFooterView = self.popView;
        
    }
}

- (void)network
{
    
    self.uid = [self.defaults objectForKey:@"uid"];
    self.sid = [self.defaults objectForKey:@"sid"];
    if (self.uid&&self.sid) {
    
    NSDictionary *dict = @{@"session":@{@"sid":self.sid,@"uid":self.uid}};
    
    [[CartNetwork sharedManager]postCartList:dict successBlock:^(id responseBody) {
        
        if (responseBody[@"status"][@"error_code"]) {
        
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
            return ;
            
        }
                
        NSMutableArray *arrays = [NSMutableArray array];
        NSMutableArray *shopName = [NSMutableArray array];
        CartGoodsModel *goodsModel = [CartGoodsModel parseCartGoodsDict:responseBody[@"data"]];
        
        for (NSDictionary *dicts in goodsModel.sup_goods_list) {
            CartShopGoodModel *shopGood = [CartShopGoodModel parseCartShopGoodDict:dicts];
            [shopName addObject:dicts[@"shop_name"]];

            NSMutableArray *shop = [NSMutableArray array];
            for (NSDictionary *goodsDic in shopGood.goods_list) {
            CartDoodsListModel *cartGoods = [CartDoodsListModel parseCartDoodsListDict:goodsDic];

            CartListFrame *cartListFrame = [[CartListFrame alloc]init];
            cartListFrame.listModel = cartGoods;
                self.frame = cartListFrame;
                [shop addObject:cartListFrame];
            }
            [arrays addObject:shop];
            
        }
        
        self.cartTotal = [CartTotalListModel parseCartTotalListDict:responseBody[@"data"][@"total"]];
        self.cartListFrame = arrays;
        self.totalLabel.text = self.cartTotal.goods_price;
        self.goodsNum.text = [NSString stringWithFormat:@"已选%@种",self.cartTotal.real_goods_count];
        self.allShopName = shopName;
           // self.tableView.tableFooterView = self.footerView;
        [SVProgressHUD dismiss];
        
        [self.tableView.header endRefreshing];
        self.tableView.tableFooterView = self.popView;
        [self.tableView reloadData];
        
    } failureBlock:^(NSString *error) {
        
        [self.tableView.header endRefreshing];
        [SVProgressHUD showInfoWithStatus:@"网络有问题"];
    }];}
     [self.tableView.header endRefreshing];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    BOOL status =  ([self.cartListFrame count] != 0);
    self.status = status;
    if (status) {
        return self.allShopName.count;
 
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   
    if (self.status) {
        
        [self setupNavi];
        
        self.footerView.hidden = NO;
        
        return [self.cartListFrame[section]count] ;
        
    }
    else{
        [self.footerView removeFromSuperview];
        return 1;
    }
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.status) {
        HCMCartCell *cell = [HCMCartCell cellWithTableView:tableView];
        
               cell.delegate = self;
        cell.cartGoods = self.cartListFrame[indexPath.section][indexPath.row];
        UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cellBtn.tag = [cell.cartGoods.listModel.goods_id integerValue];
        [cellBtn addTarget:self action:@selector(popBackView:) forControlEvents:UIControlEventTouchUpInside];
        cellBtn.frame = CGRectMake(40, 0, HCMScreenWidth -40 ,cell.cartGoods.cellHeightF-50);
        [cell.contentView addSubview:cellBtn];
        cellBtn.userInteractionEnabled = YES;
        
        return cell;

    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    
        }
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:self.buyView];
        return cell;

    }
    
}

- (void)popBackView:(UIButton *)btn
{

    [self pushGoods:[NSString stringWithFormat:@"%lu",(long)btn.tag]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.status) {
        CartListFrame *frame = self.cartListFrame[indexPath.section][indexPath.row];
        return frame.cellHeightF;
    }else{
        return HCMScreenHeight/2 - 80;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.status) {
        HCMCartSection *sectionView = [[HCMCartSection alloc]init];
        
        sectionView.listFrame = self.cartListFrame[0][section];
        return sectionView;
       

    }
    return nil;
   }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.status) {
        return 40;
    }
    return 0;
}

// 点击了支付
- (IBAction)clickPay:(UIButton *)sender
{

    NSDictionary *mutabDitc = @{@"session":@{@"sid":self.sid,@"uid":self.uid}};
    
    [[AddressNerworking sharedManager]postaddresslist:mutabDitc successBlock:^(id responseBody) {
        
        
        if (responseBody[@"status"][@"error_code"]) {
            
           [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
    
        if ([responseBody[@"data"] count] >= 1) {
            
            HCMFlowCheckOrderTableViewController *FlowCheckOrderVC = [[HCMFlowCheckOrderTableViewController alloc]initWithNibName:@"HCMFlowCheckOrderTableViewController" bundle:nil];
            
            FlowCheckOrderVC.total = self.cartTotal.goods_price;
    
            [self.navigationController pushViewController:FlowCheckOrderVC animated:YES];
            
        }else{
            
            [SVProgressHUD showInfoWithStatus:@"请填写收货地址"];
            
            HCMAddLocationTableViewController *addLocationVC = [[HCMAddLocationTableViewController alloc]initWithNibName:@"HCMAddLocationTableViewController" bundle:nil];
            
            [self.navigationController pushViewController:addLocationVC animated:YES];
            
        }
        
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:@"网络链接失败"];
        
    }];
    
}

#pragma mark - HCMCartCellDelegate
// 点击编辑数量，cell的代理方法
- (void)clickEditGoodsNumberCell:(HCMCartCell *)cell redID:(NSString *)redID number:(int)number
{
    
    NSString *goodsNumber = [NSString stringWithFormat:@"%d",number];
    
    NSDictionary *dict = @{@"new_number":goodsNumber,@"rec_id":redID,
                           @"session":@{@"sid":self.sid,@"uid":self.uid}};
    [SVProgressHUD show];
    
    [[CartNetwork sharedManager]postCartUpData:dict successBlock:^(id responseBody) {
        
        if (responseBody[@"status"][@"error_code"]) {
            
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
        
        [self network];
        
    } failureBlock:^(NSString *error) {
         [SVProgressHUD showInfoWithStatus:@"网络链接失败"];
    }];
    
}

// 点击了删除，cell代理方法
- (void)clickDeleteGoodsCell:(HCMCartCell *)cell redID:(NSString *)redID
{
    
    _deleteGoodsID = redID;

    AlartViewController *aAlartViewController = [[AlartViewController alloc] init];
    aAlartViewController.expendAbleAlartViewDelegate = self;
    __weak UIViewController *weakVC = self;
    [aAlartViewController showView:weakVC];
    
    self.tableView.scrollEnabled = NO;
    self.footerView.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem = nil;
}

//点击删除店铺
- (void)clickDeleteShopGoodsCell:(HCMCartCell *)cell seller_id:(NSString *)seller_id
{
    self.navigationItem.rightBarButtonItem = nil;
    NSDictionary *dict = @{@"session":@{@"sid":self.sid,@"uid":self.uid},
                           @"seller_id":seller_id};

    [SVProgressHUD show];
    
    [[CartNetwork sharedManager]postCartShopDelete:dict successBlock:^(id responseBody){
        
        if (responseBody[@"status"][@"error_code"]) {
            
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
        [self network];
        
    } failureBlock:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:@"网络链接失败"];
    }];

}

- (void)dealloc
{
    [HCMNSNotificationCenter removeObserver:self];
    
}

- (IBAction)allDeleteBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"session":@{@"sid":self.sid,@"uid":self.uid}};
    [SVProgressHUD show];
    
    [[CartNetwork sharedManager]postDeleteCartList:dict successBlock:^(id responseBody) {
        
        if (responseBody[@"status"][@"error_code"]) {
            
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }

        [self network];
        
    } failureBlock:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:@"网络链接失败"];
    }];
    

    self.deleteFootView.hidden = YES;
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    
}

#pragma mark --- ExpendableAlartViewDelegate
- (void)positiveButtonAction
{
    
    
    [HCMNSNotificationCenter postNotificationName:@"scrollAndUserInteraction" object:nil];
    
    NSDictionary *dict = @{@"session":@{@"sid":self.sid,@"uid":self.uid},
                           @"rec_id":_deleteGoodsID};
    
//    [SVProgressHUD show];
    
    [[CartNetwork sharedManager]postCartDelete:dict successBlock:^(id responseBody) {
        
        if (responseBody[@"status"][@"error_code"]) {
            
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
        
        [self network];
        
    } failureBlock:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:@"网络链接失败"];
    }];

    
}

- (void)negativeButtonAction
{
    [HCMNSNotificationCenter postNotificationName:@"scrollAndUserInteraction" object:nil];
     HCMLog(@"放弃");
}

- (void)closeButtonAction
{
    [HCMNSNotificationCenter postNotificationName:@"scrollAndUserInteraction" object:nil];
    HCMLog(@"关闭");
}

-(void)scrollAndUserInteraction
{
    HCMLog(@"我在疯狂测试");
    
    self.tableView.scrollEnabled = YES;
    self.footerView.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickShop:) title:@"编辑" selectedTitle:@"完成"];
}


@end
