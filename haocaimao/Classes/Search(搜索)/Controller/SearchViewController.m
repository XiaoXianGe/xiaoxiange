//
//  SearchViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/17.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "SearchViewController.h"

#import "HWSearchBar.h"
#import "SearchNetwork.h"
#import "HomeCategorySearch.h"
#import "searchView.h"

#import "MBProgressHUD+MJ.h"
#import "UIBarButtonItem+Extension.h"
#import "HCMSort_ViewController.h"

#import "SVProgressHUD.h"
#import "mainTableViewModel.h"
#import "secondCollectionViewModel.h"

@interface SearchViewController ()
@property (strong , nonatomic)NSMutableArray *mainCategoryArray;
@property (strong , nonatomic)NSMutableArray *SubCategoryArray;
@property(strong,nonatomic)HWSearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) searchView *searchView;
@property (strong, nonatomic) NSMutableArray *cateModel;
@property (strong, nonatomic)NSMutableArray *cateSubModel;
@property (strong, nonatomic)UIButton *TouchButton;

@property(strong,nonatomic)NSMutableDictionary *params;
@end

@implementation SearchViewController
static NSString *identifier = @"ID";

-(NSMutableDictionary *)params{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSearchBar];
    
    [self setupController];
    

}

-(void)setupSearchBar{
    self.searchBar = [HWSearchBar searchBar];
    self.searchBar.frame = CGRectMake(0, 0, 250, 30);
    [self.searchBar addTarget:self action:@selector(gotoTheSearch) forControlEvents:UIControlEventEditingDidEndOnExit];
    
}

-(void)setupController{
    
    self.navigationItem.titleView = self.searchBar;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [SVProgressHUD showWithStatus:@"加载中"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(gotoTheSearch) image:@"nav_search" highImage:@"nav_search"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:nil image:@"logo-icon" highImage:@"logo-icon"];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)keyboardWasShown:(NSNotification *)notification{
    
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, HCMScreenWidth, HCMScreenHeight - 64 - keyBoardFrame.size.height)];
    
    [btn addTarget:self action:@selector(TouchEvent) forControlEvents:UIControlEventTouchDown];
    
    btn.backgroundColor = [UIColor clearColor];
    
    self.TouchButton = btn;
    
    [self.view addSubview:self.TouchButton];
    
}

-(void)TouchEvent{
//    [self.view endEditing:YES];
    [self.TouchButton removeFromSuperview];
    [self.searchBar resignFirstResponder];
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.TouchButton removeFromSuperview];
    
}


- (void)searchSortView:(NSNotification *)notification{
    HCMSort_ViewController *HCMSortVC = [[HCMSort_ViewController alloc]initWithNibName:@"HCMSort_ViewController" bundle:nil];
    
    HCMSortVC.category_id = notification.userInfo[@"cateId3"];
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

- (void)loadSearchView{
    
    searchView *search = [[searchView alloc]initWithFrame:CGRectMake(0, 64, HCMScreenWidth, HCMScreenHeight) WithDataModel:self.mainCategoryArray WithTableViewModel:self.array];
    
    self.searchView = search;
    [self.view addSubview:search];
   
}


- (void)collectionModel:(NSNotification *)notification{
    
    NSString *cateId = notification.userInfo[@"indexOfTable"];
    [self loadData:cateId];
}



/** 子搜索请求 */
- (void)loadData:(NSString *)cateId{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cateId"]= cateId;
    self.params = params;
    [[SearchNetwork sharedManager]postCategorySubSearch:params successBlock:^(id responseSub) {
        
        if (self.params != params) return ;
        
        HCMLog(@"搜索是否重复发送请求");
        
        [self.cateModel removeAllObjects];
        [self.cateSubModel removeAllObjects];
        
            NSMutableArray *cateModel = [NSMutableArray array];
        
            NSMutableArray *cateSubModel = [NSMutableArray array];

        for (NSDictionary *dict in responseSub[@"data"][@"cateInfo2"]) {
            
            secondCollectionViewModel *model = [secondCollectionViewModel parsesecondCollectionViewModel:dict];
            model.cateBanner = responseSub[@"data"][@"cateBanner"];
            model.cateId = responseSub[@"data"][@"cateId"];
            [cateModel addObject:model];
            
            NSMutableArray *sub = [NSMutableArray array];
            for (NSDictionary *dic in model.cateInfo3) {
                secondCollectionViewModel *subModel = [secondCollectionViewModel parsesecondCollectionViewModel:dic];
                [sub addObject:subModel];
            }
            [cateSubModel addObject:sub];
        }
        self.searchView.collectionViewModel = cateSubModel;
        self.searchView.collectionHeaderModel = cateModel;
        [self.searchView reloadView];
        
        
    } failureBlock:^(NSString *error) {
        if (self.params != params) return ;
        [SVProgressHUD showInfoWithStatus:error];
        
    }];

}


-(void)gotoTheSearch{
    
    [self.searchBar resignFirstResponder];
    
    HCMSort_ViewController *passKeyWords = [[HCMSort_ViewController alloc]initWithNibName:@"HCMSort_ViewController" bundle:nil];
    
    passKeyWords.keyWords = self.searchBar.text;
    
    [self.navigationController pushViewController:passKeyWords animated:YES];
}


-(void)sendTheMainCategorySearchRequest{
    
    [[SearchNetwork sharedManager]postCategorySearch:nil successBlock:^(id responseBody) {
        
        NSMutableArray *mutabMainCategoryArray  = [NSMutableArray array];
        
        for (NSDictionary *dict in responseBody[@"data"]) {
            HomeCategorySearch *mainDict = [HomeCategorySearch categoryWithJson:dict];
            
            [mutabMainCategoryArray addObject:mainDict];
      
        }

        self.mainCategoryArray = mutabMainCategoryArray;
        self.array = [NSMutableArray array];
        
        [self loadData:@"132"];
         [SVProgressHUD dismiss];
        
        //加载左侧tableView 和 右侧collectionView
        [self loadSearchView];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:error];
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.TouchButton) {
        [self.TouchButton removeFromSuperview];

    }
    
    if (!self.mainCategoryArray) {
        [self sendTheMainCategorySearchRequest];
    }
    
    self.navigationController.navigationBarHidden = NO;
    
    [HCMNSNotificationCenter addObserver:self selector:@selector(searchSortView:) name:@"HCMSort_ViewController" object:nil];
    //注册键盘出现的通知
    [HCMNSNotificationCenter addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏的通知
    [HCMNSNotificationCenter addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
     [HCMNSNotificationCenter addObserver:self selector:@selector(collectionModel:) name:@"collectionModel" object:nil];

    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.TouchButton) {
        [self.TouchButton removeFromSuperview];
        
    }
    [HCMNSNotificationCenter removeObserver:self];
    [self.view endEditing:YES];
    
}

-(void)dealloc{
    [HCMNSNotificationCenter removeObserver:self];
}

/**
 *  secondCollectionViewshow
 */
@end
