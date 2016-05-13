//
//  HCMHomeTopViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/10/11.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "HCMHomeTopViewController.h"
#import "SDCycleScrollView.h"

#import "HCMHomeCollectionViewController.h"
#import "HCMSubCollectionViewController.h"
#import "HomeTopGoodsModel.h"

#import "DealViewController.h"
#import "HomeNetwork.h"

@interface HCMHomeTopViewController ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *HotGoodsZone;
@property (strong , nonatomic) NSArray *receiveGoodsIDArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerForLayout;

@end

@implementation HCMHomeTopViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //头部广告请求
    [self sendHomeAdvertisementRequest];
    
    //计算轮播图与分类大图标的距离
    self.headerForLayout.constant =HCMScreenWidth/2 + 24*HCMScreenWidth/320 + 40;
    
    [HCMNSNotificationCenter addObserver:self selector:@selector(test:) name:@"RereshHearView" object:nil];
}

//刷新广告
-(void)test:(NSNotification *)notification{
    
    [self sendHomeAdvertisementRequest];
}



//横幅
- (IBAction)Banner:(UIButton *)sender {
    
    int tag = sender.tag%60;
    
    NSArray * arr = @[@"256",@"69",@"143"];
    [self.delegate touchClickToBanner:self goodsID:arr[tag]];
}

//申请成为合伙人
- (IBAction)gotoThePartnerCenter {
    
    [self.delegate gotoPartnerCenter:self];
    
}

//应用场景
- (IBAction)clickZoneButtons:(UIButton *)sender {
    
    int tag = sender.tag%10;
     NSArray *arr = @[@"20",@"21",@"28",@"38",@"27",@"22",@"24",@"29"];
    [self.delegate touchClickToScene:self url:arr[tag]];
    
}

//劳保，消防，机械，清洁，办公，焊接
- (IBAction)category_six_Button:(UIButton *)sender {
    int tag = sender.tag%20;
    
    NSArray *arr = @[@"132",@"622",@"21",@"16",@"69",@"21"];
    [self.delegate touchClickPrassCategory:self tag:arr[tag] number:sender.tag];
}

//活动专区
- (IBAction)activityVPN:(UIButton *)sender {
    int tag = sender.tag%50;
    
    NSArray *arr = @[@"30",@"40",@"16",@"41"];
    
    [self.delegate touchClickToScene:self url:arr[tag]];
    
}

//九宫格
- (IBAction)goods_nineButton:(UIButton *)sender {
    int tag = sender.tag%30;
//    NSArray *arr = @[@"640",@"669",@"629",@"742",@"818",@"933",@"1535",@"1493",@"1601"];
                    //安全帽   安全鞋  手套 家庭工具箱  清洁机  梯子   照明     万用表   传感器
    
    NSArray *arr = @[@"681", @"631", @"1535",   @"215", @"21", @"1961",  @"629", @"624", @"625"];
                    //消防器材 足部防护  节能照明   物料搬运  工具装备  家具日用  手部防护   呼吸防护   头部防护
    [self.delegate touchClickPrassCategory:self tag:arr[tag] number:sender.tag];
    
}

//品牌
- (IBAction)brandButton:(UIButton *)sender {
    int tag = sender.tag%40;
    NSArray *arr = @[@"44",@"施耐德",@"47",@"61",@"122",@"298"];
                    //3M              世达  霍尼韦尔 威力狮 金佰利
   [self.delegate touchClickPrassCategory:self tag:arr[tag] number:sender.tag];
    
}


-(void)sendHomeAdvertisementRequest{
    
    [[HomeNetwork sharedManager]postHomeAdvertisement:nil successBlock:^(id responseBody) {
        
        [self updateAdvertisingOfDic:responseBody];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:error];
    }];
    
}


//头部广告
-(void)updateAdvertisingOfDic:(NSDictionary *)dict{
   
    NSDictionary *dic = [HomeTopGoodsModel NewsWithJSON:dict];
    NSArray * imageArray = dic[@"small"];
    self.receiveGoodsIDArray = dic[@"goods_id"];
  
//    CGRect frame = [[UIScreen mainScreen]bounds];
    
    // 情景一：采用本地图片实现
//    NSArray *images = @[[UIImage imageNamed:@"h1.jpg"],
//                        [UIImage imageNamed:@"h2.jpg"],
//                        [UIImage imageNamed:@"h3.jpg"]
//                        ];
    
    // 本地加载 --- 创建不带标题的图片轮播器
//    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 20, frame.size.width, 160) imagesGroup:images];

    
    //网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 20, HCMScreenWidth, HCMScreenWidth/2) imageURLStringsGroup:imageArray]; // 模拟网络延时情景
    
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.delegate = self;
    
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"Placeholder_ Advertise"];
    cycleScrollView.dotColor = HCMColor(230, 30, 30, 0.2);
    [self.view addSubview:cycleScrollView];
}

#pragma mark --- SDCycleScrollViewDelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    [self.delegate touchClickToAdvertise:self goodsID:self.receiveGoodsIDArray[index]];

}

#pragma 获取首页界面图片

//加载8个大分类图标
-(void)load8Png{
    
}

//加载6个分类图标（六宫格）
-(void)load6Png{
    
}

//加载活动专区4图
-(void)load4Activity{
    
}

//加载9宫图
-(void)load9Png{
    
}

//加载广告横幅
-(void)load3Banner{
    
}


@end
