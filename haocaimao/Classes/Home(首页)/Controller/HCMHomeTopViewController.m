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
#import "GBTopLineView.h"

#import "UIButton+WebCache.h"

@interface HCMHomeTopViewController ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *HotGoodsZone;
@property (strong , nonatomic) NSArray *receiveGoodsIDArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerForLayout;

@property(nonatomic,strong)NSMutableArray*dataArr;
@property (nonatomic,strong) GBTopLineView *TopLineView;


@property (weak, nonatomic) IBOutlet UIButton *eightLogo1;
@property (weak, nonatomic) IBOutlet UIButton *eightLogo2;
@property (weak, nonatomic) IBOutlet UIButton *eightLogo3;
@property (weak, nonatomic) IBOutlet UIButton *eightLogo4;
@property (weak, nonatomic) IBOutlet UIButton *eightLogo5;
@property (weak, nonatomic) IBOutlet UIButton *eightLogo6;
@property (weak, nonatomic) IBOutlet UIButton *eightLogo7;
@property (weak, nonatomic) IBOutlet UIButton *eightLogo8;


@property (weak, nonatomic) IBOutlet UIButton *sixLogo1;
@property (weak, nonatomic) IBOutlet UIButton *sixLogo2;
@property (weak, nonatomic) IBOutlet UIButton *sixLogo3;
@property (weak, nonatomic) IBOutlet UIButton *sixLogo4;
@property (weak, nonatomic) IBOutlet UIButton *sixLogo5;
@property (weak, nonatomic) IBOutlet UIButton *sixLogo6;


@property (weak, nonatomic) IBOutlet UIButton *Banner1;
@property (weak, nonatomic) IBOutlet UIButton *Banner2;
@property (weak, nonatomic) IBOutlet UIButton *Banner3;
@property (weak, nonatomic) IBOutlet UIButton *Banner4;

@property (weak, nonatomic) IBOutlet UIButton *Activity1;
@property (weak, nonatomic) IBOutlet UIButton *Activity2;
@property (weak, nonatomic) IBOutlet UIButton *Activity3;
@property (weak, nonatomic) IBOutlet UIButton *Activity4;

@property (weak, nonatomic) IBOutlet UIButton *nineLogo1;
@property (weak, nonatomic) IBOutlet UIButton *nineLogo2;
@property (weak, nonatomic) IBOutlet UIButton *nineLogo3;
@property (weak, nonatomic) IBOutlet UIButton *nineLogo4;
@property (weak, nonatomic) IBOutlet UIButton *nineLogo5;
@property (weak, nonatomic) IBOutlet UIButton *nineLogo6;
@property (weak, nonatomic) IBOutlet UIButton *nineLogo7;
@property (weak, nonatomic) IBOutlet UIButton *nineLogo8;
@property (weak, nonatomic) IBOutlet UIButton *nineLogo9;


@end

@implementation HCMHomeTopViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataArr=[[NSMutableArray alloc]init];
    //头部广告请求
    [self sendHomeAdvertisementRequestTEXT];
    
    //计算轮播图与分类大图标的距离
    self.headerForLayout.constant =HCMScreenWidth/2+22;//+ 24*HCMScreenWidth/320
    
    [HCMNSNotificationCenter addObserver:self selector:@selector(UpdownAll:) name:@"RereshHearView" object:nil];
    [self createTopLineView];
    
//    [self loadAllPic];
    
}

#pragma mark-创建头条视图
-(void)createTopLineView
{
    
    _TopLineView = [[GBTopLineView alloc]initWithFrame:CGRectMake(0, 0, 260, 30)];
    
    _TopLineView.center = CGPointMake(HCMScreenWidth/2.0+43, [self GBTopLineViewHeight]);
    
    _TopLineView.backgroundColor = [UIColor whiteColor];
    
    __weak __typeof(self)weakSelf = self;
    
    _TopLineView.clickBlock = ^(NSInteger index){
        
        GBTopLineViewModel *model = weakSelf.dataArr[index];
        
        NSLog(@"%@,%@",model.type,model.title);
        
        [weakSelf GBTopLineViewModel:(GBTopLineViewModel *)model];
    
    };
    
    [self.view addSubview:_TopLineView];
    
    [self getData];
    
}

#pragma mark-获取数据
- (void)getData
{
    NSArray *arr2 = @[@"企业政府阳光采购电商平台",@"  正品 低价 高效 阳光",@"以电商化实现采购阳光化",@"   对公采购 上好采猫 "];
    
    for (int i=0; i<arr2.count; i++) {
        
        GBTopLineViewModel *model = [[GBTopLineViewModel alloc]init];

        model.title = arr2[i];

        [_dataArr addObject:model];
    }
    
    [_TopLineView setVerticalShowDataArr:_dataArr];
}

-(void)GBTopLineViewModel:(GBTopLineViewModel *)model
{
    
    [self.delegate touchGBTopLineView:model.type title:model.title];
}

-(NSInteger)GBTopLineViewHeight
{
    
    NSInteger height = 0;
    
    if (HCMScreenWidth == 320.0) height = 198+162;
    if (HCMScreenWidth == 375.0) height = 230+158;
    if (HCMScreenWidth == 414.0) height = 252+155;
    
    return height;
    
}

//刷新广告
-(void)UpdownAll:(NSNotification *)notification
{
    
    [self sendHomeAdvertisementRequest];
    
    
}

//横幅
- (IBAction)Banner:(UIButton *)sender
{
    
    int tag = sender.tag%60;
    
    NSArray * arr = @[@"256",@"69",@"143"];
    [self.delegate touchClickToBanner:self goodsID:arr[tag]];
}

//申请成为合伙人
- (IBAction)gotoThePartnerCenter
{
    
    [self.delegate gotoPartnerCenter:self];
    
}

//应用场景
- (IBAction)clickZoneButtons:(UIButton *)sender
{
    
    int tag = sender.tag%10;
     NSArray *arr = @[@"20",@"21",@"28",@"38",@"27",@"22",@"24",@"29"];
    [self.delegate touchClickToScene:self url:arr[tag]];
    
}

//劳保，消防，机械，清洁，办公，焊接
- (IBAction)category_six_Button:(UIButton *)sender
{
    int tag = sender.tag%20;
    NSArray *arr = @[@"132",@"622",@"21",@"16",@"69",@"265"];
    [self.delegate touchClickPrassCategory:self tag:arr[tag] number:sender.tag];
}

//活动专区
- (IBAction)activityVPN:(UIButton *)sender
{
    int tag = sender.tag%50;
    
    NSArray *arr = @[@"30",@"40",@"16",@"41"];
    
    [self.delegate touchClickToScene:self url:arr[tag]];
    
}

//九宫格
- (IBAction)goods_nineButton:(UIButton *)sender
{
    int tag = sender.tag%30;

    NSArray *arr = @[@"681", @"631", @"1535",   @"215", @"21", @"1961",  @"629", @"624", @"625"];
                    //消防器材 足部防护  节能照明   物料搬运  工具装备  家具日用  手部防护   呼吸防护   头部防护
    [self.delegate touchClickPrassCategory:self tag:arr[tag] number:sender.tag];
    
}

//品牌
- (IBAction)brandButton:(UIButton *)sender
{
    int tag = sender.tag%40;
    NSArray *arr = @[@"44",@"施耐德",@"47",@"61",@"122",@"298"];
                    //3M              世达  霍尼韦尔 威力狮 金佰利
   [self.delegate touchClickPrassCategory:self tag:arr[tag] number:sender.tag];
    
}

//备用清理缓存 再刷新(通知的方法)
-(void)sendHomeAdvertisementRequest
{
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];
    
    HCMLog(@"清理了缓存");

    [[HomeNetwork sharedManager]postHomeAdvertisement:nil successBlock:^(id responseBody) {

        [self updateAdvertisingOfDic:responseBody];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:error];
    }];
    
    
    
}

//初始化的netWorking
-(void)sendHomeAdvertisementRequestTEXT
{

    [[HomeNetwork sharedManager]postHomeAdvertisement:nil successBlock:^(id responseBody) {
        
        [self updateAdvertisingOfDic:responseBody];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:error];
    }];
    

}

//头部广告
-(void)updateAdvertisingOfDic:(NSDictionary *)dict
{
   
    NSDictionary *dic = [HomeTopGoodsModel NewsWithJSON:dict];
    NSArray * imageArray = dic[@"small"];
    self.receiveGoodsIDArray = dic[@"goods_id"];
    /*
//    CGRect frame = [[UIScreen mainScreen]bounds];儿子
    
    // 情景一：采用本地图片实现
//    NSArray *images = @[[UIImage imageNamed:@"h1.jpg"],
//                        [UIImage imageNamed:@"h2.jpg"],
//                        [UIImage imageNamed:@"h3.jpg"]
//                        ];
    
    // 本地加载 --- 创建不带标题的图片轮播器
//    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 20, frame.size.width, 160) imagesGroup:images];
*/
    
    for (NSString *str in imageArray) {
        HCMLog(@"%@",str);
    }
    
    //网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 20, HCMScreenWidth, HCMScreenWidth/2) imageURLStringsGroup:imageArray]; // 模拟网络延时情景
   
    
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.delegate = self;
    
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"Placeholder_ Advertise"];
    cycleScrollView.dotColor = HCMColor(230, 30, 30, 0.2);
    [self.view addSubview:cycleScrollView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadAllPic];
    });


}

#pragma mark --- SDCycleScrollViewDelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    [self.delegate touchClickToAdvertise:self goodsID:self.receiveGoodsIDArray[index]];

}

#pragma 获取首页界面图片

-(void)loadAllPic
{

  
        [self load8Png];
        
        [self load6Png];
        
        [self load4Banner];
        
        [self load4Activity];
        
        [self load9Png];


}

//加载8个大分类图标
-(void)load8Png
{
    
    [_eightLogo1 sd_setImageWithURL:[self loadPic:@"2.png"] forState:UIControlStateNormal];
    [_eightLogo2 sd_setImageWithURL:[self loadPic:@"3.png"] forState:UIControlStateNormal];
    [_eightLogo3 sd_setImageWithURL:[self loadPic:@"4.png"] forState:UIControlStateNormal];
    [_eightLogo4 sd_setImageWithURL:[self loadPic:@"5.png"] forState:UIControlStateNormal];
    [_eightLogo5 sd_setImageWithURL:[self loadPic:@"6.png"] forState:UIControlStateNormal];
    [_eightLogo6 sd_setImageWithURL:[self loadPic:@"7.png"] forState:UIControlStateNormal];
    [_eightLogo7 sd_setImageWithURL:[self loadPic:@"8.png"] forState:UIControlStateNormal];
    [_eightLogo8 sd_setImageWithURL:[self loadPic:@"9.png"] forState:UIControlStateNormal];
    
}

//加载6个分类图标（六宫格）
-(void)load6Png
{
    [_sixLogo1 sd_setImageWithURL:[self loadPic:@"11.jpg"] forState:UIControlStateNormal];
    [_sixLogo2 sd_setImageWithURL:[self loadPic:@"12.jpg"] forState:UIControlStateNormal];
    [_sixLogo3 sd_setImageWithURL:[self loadPic:@"13.jpg"] forState:UIControlStateNormal];
    [_sixLogo4 sd_setImageWithURL:[self loadPic:@"14.jpg"] forState:UIControlStateNormal];
    [_sixLogo5 sd_setImageWithURL:[self loadPic:@"15.jpg"] forState:UIControlStateNormal];
    [_sixLogo6 sd_setImageWithURL:[self loadPic:@"16.jpg"] forState:UIControlStateNormal];
}

//加载活动专区4图
-(void)load4Activity
{
    [_Activity1 sd_setBackgroundImageWithURL:[self loadPic:@"18.jpg"] forState:UIControlStateNormal];
    [_Activity2 sd_setBackgroundImageWithURL:[self loadPic:@"19.jpg"] forState:UIControlStateNormal];
    [_Activity3 sd_setBackgroundImageWithURL:[self loadPic:@"20.jpg"] forState:UIControlStateNormal];
    [_Activity4 sd_setBackgroundImageWithURL:[self loadPic:@"21.jpg"] forState:UIControlStateNormal];
}

//加载9宫图
-(void)load9Png
{
    
    [_nineLogo1 sd_setBackgroundImageWithURL:[self loadPic:@"23.jpg"] forState:UIControlStateNormal];
    [_nineLogo2 sd_setBackgroundImageWithURL:[self loadPic:@"24.jpg"] forState:UIControlStateNormal];
    [_nineLogo3 sd_setBackgroundImageWithURL:[self loadPic:@"25.jpg"] forState:UIControlStateNormal];
    [_nineLogo4 sd_setBackgroundImageWithURL:[self loadPic:@"26.jpg"] forState:UIControlStateNormal];
    [_nineLogo5 sd_setBackgroundImageWithURL:[self loadPic:@"27.jpg"] forState:UIControlStateNormal];
    [_nineLogo6 sd_setBackgroundImageWithURL:[self loadPic:@"28.jpg"] forState:UIControlStateNormal];
    [_nineLogo7 sd_setBackgroundImageWithURL:[self loadPic:@"29.jpg"] forState:UIControlStateNormal];
    [_nineLogo8 sd_setBackgroundImageWithURL:[self loadPic:@"30.jpg"] forState:UIControlStateNormal];
    [_nineLogo9 sd_setBackgroundImageWithURL:[self loadPic:@"31.jpg"] forState:UIControlStateNormal];
    
    
}

//加载广告横幅
-(void)load4Banner
{
    
    [_Banner1 sd_setBackgroundImageWithURL:[self loadPic:@"10.jpg"] forState:UIControlStateNormal];
    [_Banner2 sd_setBackgroundImageWithURL:[self loadPic:@"17.jpg"] forState:UIControlStateNormal];
    [_Banner3 sd_setBackgroundImageWithURL:[self loadPic:@"22.jpg"] forState:UIControlStateNormal];
    [_Banner4 sd_setBackgroundImageWithURL:[self loadPic:@"32.jpg"] forState:UIControlStateNormal];
    
}

-(NSURL *)loadPic:(NSString *)PicName
{
    
    NSString *URLa = @"http://www.haocaimao.com/ios/";
    NSString *urlStr = [URLa stringByAppendingString:PicName];
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    
    return URL;
}



@end
