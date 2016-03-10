//
//  HCMUserEnshrineCollectionViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/29.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//  收藏

#import "HCMUserEnshrineCollectionViewController.h"
#import "DealViewController.h"

#import "HCMEnshrineCell.h"

#import "AddressNerworking.h"

@interface HCMUserEnshrineCollectionViewController ()<HCMEnshrineCellDelegete>

@property (strong, nonatomic)NSString *uid;
@property (strong, nonatomic)NSString *sid;

@property (assign, nonatomic)BOOL edit;

@property (strong, nonatomic)NSMutableArray *mutabArray;

@property (strong, nonatomic)NSUserDefaults *defaults;

@property (strong, nonatomic) UIImageView *noDataView;

@end

@implementation HCMUserEnshrineCollectionViewController

{
    int _initCount;
    int _page;
}

static NSString * const reuseIdentifier = @"Cell";

-(NSUserDefaults *)defaults{
    
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

-(NSMutableArray *)mutabArray{
    
    if (!_mutabArray) {
        _mutabArray = [NSMutableArray array];
    }
    return _mutabArray;
}

- (UIImageView *)noDataView{
    if (!_noDataView) {
        UIImageView * noDataView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"no-goods"]];
        [self.view addSubview:noDataView];
        noDataView.center = self.view.center;
        _noDataView = noDataView;
    }
    return _noDataView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.edit = YES;
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"index-body-bg"]];
    self.title = @"我的收藏";
   
    [self.collectionView registerNib:[UINib nibWithNibName:@"HCMEnshrineCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.alwaysBounceVertical = YES;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickCompile) image:@"nav-delete" highImage:@"nav-delete"];
    
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(theDropdownLoadMore)];
    
    
    [self.collectionView.header beginRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
}
// 上啦刷新
- (void)theDropdownLoadMore{
    
    [self.mutabArray removeAllObjects];
    
   // [self.collectionView addFooterWithTarget:self action:@selector(toLoadMoreData)];
    [self.collectionView reloadData];
    
    _page = 1;
    
    [self network];
}
// 网络请求
- (void)network{
        
    self.uid = [self.defaults objectForKey:@"uid"];
    self.sid = [self.defaults objectForKey:@"sid"];
    
    NSDictionary *dict = @{@"session":@{@"uid":self.uid,@"sid":self.sid},
                           @"pagination":@{@"count":@20,@"page":@(_page)}};
    
    [[AddressNerworking sharedManager]postCollectList:dict successBlock:^(id responseBody) {
        
        if (responseBody[@"status"][@"error_code"]) {
        
            [self.collectionView.header endRefreshing];
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
        
        [SVProgressHUD showSuccessWithStatus:nil];
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dictData in responseBody[@"data"]) {
            
            UserEnshrine *enshrine = [UserEnshrine parseEnshrineData:dictData];
            
            [array addObject:enshrine];
            
        }
        if (array.count == 20) {
            self.collectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(toLoadMoreThing)];
        }
        if (array.count < 20) {
            [self.collectionView.header endRefreshing];
        }
        _initCount = [responseBody[@"paginated"][@"total"] intValue];
        
        _page += 1;
        
        [self.mutabArray addObjectsFromArray:array];
        
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
        
        
        [self.collectionView reloadData];
        
    } failureBlock:^(NSString *error) {
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
        [SVProgressHUD showInfoWithStatus:@"网络错误"];
    }];
    
}
// 上拉刷新
- (void)toLoadMoreThing{
    
    if ([self.mutabArray count] == _initCount) {
        
        [SVProgressHUD showInfoWithStatus:@"没有更多数据"];
        [self.collectionView.footer endRefreshing];
        return;
    }
    
    [self network];
    
}

#pragma  mark -navigationControllerL&R
// 点击 删除
- (void)clickCompile{
    
    self.edit = !self.edit;
    
    if ([self.mutabArray count] == 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return;
    }

    if (self.edit) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickCompile) image:@"nav-delete" highImage:@"nav-delete"];
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickCompile) image:@"nav-complete" highImage:@"nav-complete"];
    }
    
    
    [self.collectionView reloadData];
    
}

- (void)clickBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    self.noDataView.hidden = ([self.mutabArray count] != 0);
    
    return [self.mutabArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HCMEnshrineCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.index_path = indexPath;
    
    cell.enshrine = self.mutabArray[indexPath.row];
    
    cell.cilckDlete.hidden = self.edit;
    
    return cell;
}

#pragma mark <HCMEnshrineCellDelegete>
// 点击了删除
-(void)clickDeleteCell:(HCMEnshrineCell *)enshrineCell{
        
    [SVProgressHUD show];
    
    NSDictionary *dict = @{@"session":@{@"sid":self.sid,@"uid":self.uid},
                           @"rec_id":enshrineCell.rem_ID};
    
    [[AddressNerworking sharedManager]postCollectDelete:dict successBlock:^(id responseBody) {
        
        
        if (responseBody[@"status"][@"error_code"]) {
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:nil];
        [self.mutabArray removeObjectAtIndex:enshrineCell.index_path.row];
        [self.collectionView reloadData];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:@"网络有问题"];
        
    }];
    
}

// 点击了收藏
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UserEnshrine *enshrine = self.mutabArray[indexPath.row];
    
    DealViewController *dealVC = [[DealViewController alloc]initWithNibName:@"DealViewController" bundle:nil];
    
    dealVC.goods_id = enshrine.goods_id;
    
    [self.navigationController pushViewController:dealVC animated:YES];
    
}

@end
