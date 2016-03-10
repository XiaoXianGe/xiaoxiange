//
//  BrandViewController.m
//  haocaimao
//
//  Created by 李芷贤 on 15/9/17.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "BrandViewController.h"
#import "SearchNetwork.h"
#import "HCMSort_ViewController.h"
#import "SortBrandFiltrate.h"
#import "SVProgressHUD.h"
#import "UIBarButtonItem+Extension.h"
#import "SortBarndPrice.h"
#import "UIView+Extension.h"
#import "HomeNetwork.h"

@interface BrandViewController ()<UIScrollViewDelegate>

@property(strong,nonatomic)NSArray *allBrandNameArray;
@property(strong,nonatomic)NSArray *allBrandIdArray;
@property(strong,nonatomic)NSArray *allPriceArray;
@property(strong,nonatomic)UIView *brandView;
@property(strong,nonatomic)UIView *priceView;
@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)NSMutableArray *markBrandArray;
@property(strong,nonatomic)NSMutableArray *markPriceArray;
@property(strong,nonatomic)NSMutableArray *priceMaxArray;
@property(strong,nonatomic)NSMutableArray *priceMinArray;
@property(strong,nonatomic)NSMutableArray *category_id_array;
@property(strong,nonatomic)NSMutableArray *category_name_array;
@property(strong,nonatomic)NSMutableArray *markCategoryArray;
@end

@implementation BrandViewController

typedef void(^ButtonBlock)();

-(NSMutableArray *)markBrandArray{
    if (!_markBrandArray) {
        _markBrandArray = [NSMutableArray array];
    }
    return _markBrandArray;
}
-(NSMutableArray *)markPriceArray{
    if (!_markPriceArray) {
        _markPriceArray = [NSMutableArray array];
    }
    return _markPriceArray;
}
-(NSMutableArray *)markCategoryArray{
    if (!_markCategoryArray) {
        _markCategoryArray = [NSMutableArray array];
    }
    return _markCategoryArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"筛选条件";
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
    if (self.category_id!=nil) {
        [self searchBrand];
    }else{
        [self searchCategory];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.scrollView.delegate= self;
    //防止数据不够不能拖动
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.scrollView];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickAccomplish) image:@"nav-complete" highImage:@"nav-complete"];
    
}

-(void)clickBack{
    
    [SVProgressHUD dismiss];
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)searchBrand{
    NSDictionary *dict = nil;
    
    dict = @{@"category_id":self.category_id};
    
    /**
     *  牌子筛选请求
     */
    [[SearchNetwork sharedManager]postBrandFiltrate:dict successBlock:^(id responseBody) {
        
        NSMutableArray *mutBrandArray = [NSMutableArray array];
        NSMutableArray  *mutBrandIdArray = [NSMutableArray array];
        
        for (NSDictionary *dict in responseBody[@"data"]) {
            
            SortBrandFiltrate * brand = [SortBrandFiltrate parseSortFiltrateWith:dict];
            
            [mutBrandArray addObject:brand.brand_name];
            [mutBrandIdArray addObject:brand.brand_id];
            
        }
        
        self.allBrandNameArray = mutBrandArray;
        self.allBrandIdArray = mutBrandIdArray;
        
        self.brandView = [self creatButtonWithArray:self.allBrandNameArray title:@"请选择牌子" action:@selector(handleClick:) markArray:self.markBrandArray];
        [self setScorllViewAddSubview:self.brandView];
        
        /**
         *  价格筛选请求
         */
        [[SearchNetwork sharedManager]postBrandPrice:dict successBlock:^(id responseBody) {
            
            NSMutableArray *mutPriceArray = [NSMutableArray array];
            NSMutableArray *mutPriceMaxArray = [NSMutableArray array];
            NSMutableArray *mutPriceMinArray = [NSMutableArray array];
            NSString *str = nil;
            
            if ([responseBody[@"data"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dict in responseBody[@"data"]) {
                    
                    SortBarndPrice *brand = [SortBarndPrice parseSortPriceWith:dict];
                    
                    str = [NSString stringWithFormat:@"%@-%@",brand.price_min,brand.price_max];
                    
                    [mutPriceArray addObject:str];
                    [mutPriceMaxArray addObject:brand.price_max];
                    [mutPriceMinArray addObject:brand.price_min];
                }
                self.allPriceArray = mutPriceArray;
                self.priceMinArray = mutPriceMinArray;
                self.priceMaxArray = mutPriceMaxArray;
                
                if([self.allPriceArray firstObject] != nil){
                    
                    self.priceView = [self creatButtonWithArray:self.allPriceArray title:@"请选择价格" action:@selector(priceClick:) markArray:self.markPriceArray];
                    
                    self.priceView.y = self.brandView.height + 20;
                    
                    [self setScorllViewAddSubview:self.priceView];
                    
                }
                
            };
            
            [SVProgressHUD dismiss];
            
        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:error];
            
           
            
        }];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:error];
        
    }];

}

-(void)searchCategory{
    
    /**
     *  牌子筛选请求
     */
    [[SearchNetwork sharedManager]postBrandFiltrate:nil successBlock:^(id responseBody) {
        
        NSMutableArray *mutBrandArray = [NSMutableArray array];
        NSMutableArray  *mutBrandIdArray = [NSMutableArray array];
        
        for (NSDictionary *dict in responseBody[@"data"]) {
            
            SortBrandFiltrate * brand = [SortBrandFiltrate parseSortFiltrateWith:dict];
            
            [mutBrandArray addObject:brand.brand_name];
            [mutBrandIdArray addObject:brand.brand_id];
            
        }
        
        self.allBrandNameArray = mutBrandArray;
        self.allBrandIdArray = mutBrandIdArray;
        
        self.brandView = self.brandView = [self creatButtonWithArray:self.allBrandNameArray title:@"请选择牌子" action:@selector(handleClick:) markArray:self.markBrandArray];
        
        [self setScorllViewAddSubview:self.brandView];
        
        /**
         *  分类请求
         */
        [[HomeNetwork sharedManager]postHomeCategoryGoods:nil successBlock:^(id responseBody) {
            
            NSMutableArray *mutIDarray = [NSMutableArray array];
            NSMutableArray *mutNameArray = [NSMutableArray array];
            NSString *str = nil;
            
            for (NSDictionary *dict in responseBody[@"data"]) {
                
                [mutIDarray addObject:dict[@"id"]];
                str = dict[@"name"];
                [mutNameArray addObject:str];
                
            }
            self.category_id_array = mutIDarray;
            self.category_name_array = mutNameArray;
            
            //self.priceView = [self creatCategoryButtonWithArray:self.category_name_array];
            self.priceView = [self creatButtonWithArray:self.category_name_array title:@"请选择分类" action:@selector(categoryClick:) markArray:self.markCategoryArray];
            
            self.priceView.y = self.brandView.height + 20;
            
            [self setScorllViewAddSubview:self.priceView];
            
            [SVProgressHUD dismiss];
            
        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:error];
           
        }];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:error];
       
    }];
}

-(void)setScorllViewAddSubview:(UIView *)addView{
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,800);
    
    [self.scrollView addSubview:addView];
    
}

-(UIView *)creatButtonWithArray:(NSArray *)BrandArray title:(NSString *)title action:(SEL)action markArray:(NSMutableArray *)markArray{
    
    UIView *BrandandPriceView = [[UIView alloc]init];
    UIImageView *bgImage = [[UIImageView alloc]init];
    [bgImage setImage:[UIImage imageNamed:@"body-cont-bg"]];
    
    [BrandandPriceView addSubview:bgImage];
    
    
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 40;//用来控制button距离父视图的高

    for (int i = 0; i < BrandArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        button.tag = i;
        [button setBackgroundImage:[UIImage imageNamed:@"item-info-buy-kinds-btn-grey"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"item-info-buy-kinds-active-btn"] forState:UIControlStateSelected];
        
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [button setTintColor:[UIColor clearColor]];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        CGFloat length = [BrandArray[i]  boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        
        //为button赋值
        [button setTitle:BrandArray[i] forState:UIControlStateNormal];
        
        //设置button的frame
        button.frame = CGRectMake(10 + w, h, length + 11 , 25);
        
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(10 + w + length +20 > [UIScreen mainScreen].bounds.size.width){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + 10;//距离父视图也变化
            
            button.frame = CGRectMake(10 + w, h, length + 11, 25);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        
        [markArray addObject:button];

        [BrandandPriceView addSubview:button];
    }
    
    BrandandPriceView.frame = CGRectMake(5, 10, self.view.frame.size.width-10, h + 35);
    bgImage.frame = CGRectMake(0, 0, self.view.frame.size.width-10, h + 35);
    
    UILabel *brandLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 180, 30)];
    brandLabel.text = title;
    [BrandandPriceView addSubview:brandLabel];
    
    return BrandandPriceView;
    
}

//点击事件
- (void)handleClick:(UIButton *)btns{

    for (UIButton *btn in self.markBrandArray) {
        btn.selected = NO;
    }
    btns.selected = YES;
    self.brand_id = [self.allBrandIdArray[btns.tag] integerValue];
    
}
- (void)priceClick:(UIButton *)btns{
    
    for (UIButton *btn in self.markPriceArray) {
        btn.selected = NO;
    }
    btns.selected = YES;
    self.price_max = self.priceMaxArray[btns.tag];
    self.price_min = self.priceMinArray[btns.tag];
}
- (void)categoryClick:(UIButton *)btns{
    
    for (UIButton *btn in self.markCategoryArray) {
        btn.selected = NO;
    }
    btns.selected = YES;
    self.category_id = self.category_id_array[btns.tag];
}
//点击完成
-(void)clickAccomplish{

    for(UIViewController *controller in self.navigationController.viewControllers) {
        if([controller isKindOfClass:[HCMSort_ViewController class]]){
            HCMSort_ViewController *owr = (HCMSort_ViewController *)controller;
            
             owr.brand_id = self.brand_id;
             owr.category_id = self.category_id;
             //owr.keyWords = @"";
            if (self.markPriceArray) {
                owr.price_max = self.price_max;
                owr.price_min = self.price_min;
            }
             [[NSNotificationCenter defaultCenter]postNotificationName:@"searchMessage" object:nil];
            
            [self.navigationController popToViewController:owr animated:YES];
            
           
            
        }
    }
    
}


@end
