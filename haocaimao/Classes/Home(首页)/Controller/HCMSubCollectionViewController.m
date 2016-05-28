//
//  HCMSubCollectionViewController.m
//  haocaimao
//
//  Created by 李芷贤 on 15/10/14.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMSubCollectionViewController.h"
#import "RegionNetworking.h"
#import "CategoryGoods.h"
#import "SceneCollectionViewCell.h"
#import "DealViewController.h"



@interface HCMSubCollectionViewController ()

@property (copy, nonatomic)NSString *topic_img_str;
@property (strong, nonatomic)NSArray *categoryNames;
@property (strong, nonatomic)NSArray *categoryGoogs;

@end

@implementation HCMSubCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const url = @"http://www.haocaimao.com/mobile/index.php?c=topic&a=appTopicIndex&id=";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
     self.tabBarController.tabBar.hidden = YES;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderViewXXX"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SceneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self network];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}


-(void)clickBack{
    
    [SVProgressHUD dismiss];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)network{
    
    NSString *newURL = [NSString stringWithFormat:@"%@%@",url,self.urlStr];
    
    [[RegionNetworking sharedManager]getRegionUrl:nil url:newURL successBlock:^(id responseBody) {
        
        
        
        NSMutableArray *mutabCategoryNames = [NSMutableArray array];
        NSMutableArray *mutabGoodsIndexs = [NSMutableArray array];
        
        for (NSDictionary *dict in responseBody[@"topicInfo"]) {
            
            [mutabCategoryNames addObject:dict[@"categoryName"]];
            NSMutableArray *GoodsIndexs = [NSMutableArray array];
            for (NSDictionary *goods in dict[@"goodsIndex"]) {
                CategoryGoods * good = [CategoryGoods objectWithKeyValues:goods];
                [GoodsIndexs addObject:good];
            }
            
            [mutabGoodsIndexs addObject:GoodsIndexs];
        }
        
        self.categoryNames = [mutabCategoryNames copy];
        self.categoryGoogs = [mutabGoodsIndexs copy];
        
        [self.collectionView reloadData];
        
        [SVProgressHUD dismiss];
        
        self.topic_img_str =  responseBody[@"topic_img"];
        self.collectionView.backgroundColor = HCMColor(233, 233, 233, 1.0);
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:error];
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.categoryNames count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *array = self.categoryGoogs[section];
    return [array count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SceneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSArray *array = self.categoryGoogs[indexPath.section];
    CategoryGoods * good = array[indexPath.row];
    
   [cell.good_Image sd_setImageWithURL:[NSURL URLWithString:good.goods_thumb] placeholderImage:[UIImage imageNamed:@"searcher-no-result-empty-icon"]];
    self.title = self.categoryNames[indexPath.section];
    
    cell.good_Name.text = good.goods_name;
    cell.market_price.text = [NSString stringWithFormat:@"原价:￥%@",good.market_price];

    if ([good.promote_price isEqualToString:@""]) {
         cell.shop_price.text = good.shop_price;
    }else{
        
        cell.shop_price.text = good.promote_price;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = self.categoryGoogs[indexPath.section];
    CategoryGoods * good = array[indexPath.row];
    DealViewController *dealVc = [[DealViewController alloc]initWithNibName:@"DealViewController" bundle:nil];
    
    dealVc.goods_id = good.goods_id;
    
    [self.navigationController pushViewController:dealVc animated:YES];
    
}


//为collection插入头视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 0)
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableview = headerView;
    }else{
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderViewXXX" forIndexPath:indexPath];
        reusableview = headerView;
    }
    
    
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    if (indexPath.section == 0) {
        
        UIImageView * ima = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cellW, 180)];
        
        //特殊高度@"30 ,"@"14",@"16",@"18"
        if([self.urlStr isEqualToString:@"30"]||[self.urlStr isEqualToString:@"40"]||[self.urlStr isEqualToString:@"16"]||[self.urlStr isEqualToString:@"41"]){
            ima.height = 270;
        }
        
        [ima sd_setImageWithURL:[NSURL URLWithString:self.topic_img_str] placeholderImage:[UIImage imageNamed:@"Placeholder_ Advertise"]];
      
        [reusableview addSubview:ima];

    }else{
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cellW, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.categoryNames[indexPath.section];
        label.textColor = [UIColor whiteColor];
        [label setBackgroundColor:HCMColor(235, 3, 21, 1.0)];
        [reusableview addSubview:label];
    }
    
    //reusableview.backgroundColor = [UIColor blueColor];
    return reusableview;
    
}
/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width =(HCMScreenWidth -30)/2;
    return CGSizeMake(width, 210*width/145);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    if (section == 0) {
        
        //特殊高度
        if([self.urlStr isEqualToString:@"30"]||[self.urlStr isEqualToString:@"40"]||[self.urlStr isEqualToString:@"16"]||[self.urlStr isEqualToString:@"41"]){
            return CGSizeMake(cellW, 270);
        }else{
            return CGSizeMake(cellW, 180);
        }
    }
    
    return CGSizeMake(cellW, 30);
}

@end
