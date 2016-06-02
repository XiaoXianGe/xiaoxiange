//
//  HCMPartnerCenterViewController.m
//  合伙人test
//
//  Created by 好采猫 on 16/3/9.
//  Copyright © 2016年 好采猫. All rights reserved.
//
//  合伙人中心  提成 分成  

#import "HCMPartnerCenterViewController.h"
#import "UIView+Extension.h"
#import "HCMPartnerCenterCell.h"

#import "HomeNetwork.h"
#import "PartnerIndexModel.h"
#import "PartnerIndex2Model.h"
#import "MJExtension.h"

#import "UMSocialWechatHandler.h"
#import "UMSocial.h"

#define CellHeight 40 


@interface HCMPartnerCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UMSocialUIDelegate>

/** 内容视图 */
@property (strong, nonatomic) IBOutlet UIView *VView;
/** 最底层的滚动 */
@property(nonatomic,strong)UIScrollView *scrollView;
/** 注册人数tableview*/
@property (weak, nonatomic) IBOutlet UITableView *ParnterNumberTableView;
/** 下单分成tableview*/
@property (weak, nonatomic) IBOutlet UITableView *orderNumberTableView;
/** 红色头部view*/
@property (weak, nonatomic) IBOutlet UIView *headRedVIew;
/** 绿色头部view*/
@property (weak, nonatomic) IBOutlet UIView *headGreenView;

@property(strong,nonatomic)PartnerIndexModel *partnerIndexModel;

@property(strong,nonatomic)NSMutableArray *indexArray;

@property(strong,nonatomic) NSUserDefaults *defaults;

@property (weak, nonatomic) IBOutlet UIButton *shareWeChat;

@property (weak, nonatomic) IBOutlet UIButton *shareFaceToFace;

@property (strong ,nonatomic) UIView *QRCodeView;

@property (copy,nonatomic) NSString * uid;
@property (copy,nonatomic) NSString * sid;

@property(assign)BOOL status;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_heightConstraint;

@end

@implementation HCMPartnerCenterViewController

-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建scrollView
    [self setUpScrollView];
    
    //初始化控制器
    [self setUpController];
    
    //发送网络请求
    [self NetWorking];
    
}

/**
 *  发送网络请求
 */
-(void)NetWorking{
    
    self.status = [self.defaults boolForKey:@"status"];
    
    if (self.status) {
        
        self.uid = [self.defaults objectForKey:@"uid"];
        self.sid = [self.defaults objectForKey:@"sid"];
        
        NSMutableDictionary *params =[NSMutableDictionary dictionary];
        params[@"session"] = @{@"uid":self.uid,@"sid":self.sid};
        
        [[HomeNetwork sharedManager]postPartnerIndexURL:params successBlock:^(id responseBody) {
            
            self.partnerIndexModel= [PartnerIndexModel objectWithKeyValues:responseBody[@"data"]];
            
           self.indexArray = [PartnerIndex2Model objectArrayWithKeyValuesArray:responseBody[@"data"][@"index"]];
            
            [self.ParnterNumberTableView reloadData];
            [self.orderNumberTableView reloadData];
            
            [SVProgressHUD dismiss];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
            
        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:@"加载失败"];
            
        }];
    }
}


/**
 *  初始化控制器
 */
-(void)setUpController{
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"合伙人中心";
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    
    self.orderNumberTableView.userInteractionEnabled = NO;
    self.ParnterNumberTableView.userInteractionEnabled = NO;
    
    [self.orderNumberTableView registerNib:[UINib nibWithNibName:@"HCMPartnerCenterCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.ParnterNumberTableView registerNib:[UINib nibWithNibName:@"HCMPartnerCenterCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

//创建scrollView
-(void)setUpScrollView{
    
    
    [SVProgressHUD show];
    
    self.VView.frame = CGRectMake(0, 0, HCMScreenWidth, 9999);
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
//    self.scrollView = scrollView;
    
    // 设定scrollView的可显示区域窗口的大小
    scrollView.frame = CGRectMake(0, 0, HCMScreenWidth, HCMScreenHeight);
    
    // 设定scrollView的可滚动区域的大小
    scrollView.contentSize = CGSizeMake(HCMScreenWidth, HCMScreenHeight);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    [scrollView addSubview:self.VView];
    
    [self.VView updateConstraintsIfNeeded];
    [self.view updateConstraints];
    
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSUInteger count1 = 1;
    
    if (tableView == self.ParnterNumberTableView) {
        self.ParnterNumberTableView.height = CellHeight * count1;
        return count1;
    }else{
        
//        self.headGreenView.y = self.headRedVIew.y + self.headRedVIew.height + CellHeight * count1 + 15;
//        
//        self.orderNumberTableView.y = self.headGreenView.y + self.headGreenView.height;
//        
//        self.orderNumberTableView.height = CellHeight * (self.indexArray.count? self.indexArray.count : 1 );
//        
//        self.shareFaceToFace.y = self.orderNumberTableView.y + self.orderNumberTableView.height + 30;
//        
//        self.shareWeChat.y = self.shareFaceToFace.y;
//        
//        _scrollView.contentSize = CGSizeMake(320, self.orderNumberTableView.y + self.orderNumberTableView.height + 100);
        
//        if (HCMScreenWidth == 320.0) {
//            self.top_heightConstraint.constant = 0;
//        }
        
        self.top_heightConstraint.constant = CellHeight * (self.indexArray.count? self.indexArray.count : 1 );
        
        
        return self.indexArray.count ? self.indexArray.count : 1 ;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCMPartnerCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //设置row隔空颜色
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = HCMColor(233, 233, 233, 1.0);}
    else{
        cell.backgroundColor = HCMColor(211, 211, 211, 1.0);}
    
    //红色tableView内容设置
    if (tableView == self.ParnterNumberTableView) {
        cell.Label_Left.text = self.partnerIndexModel.rank;
        cell.Label_Middle.text = self.partnerIndexModel.amount;
        cell.Label_Right.text = self.partnerIndexModel.proportion;
        
    }else{//绿色tableView内容设置
        if (self.indexArray.count == 0) { //返回内容为空
            cell.Label_Left.text = @"--";
            cell.Label_Right.text = @"--";
            cell.Label_Middle.text = @"--";
            
        }else{//返回内容有值
            PartnerIndex2Model *model = self.indexArray[indexPath.row];
            cell.Label_Left.text = model.orderSN;
            cell.Label_Middle.text = model.commission;
            
            if ([model.status isEqualToString:@"1"]) {
                cell.Label_Right.text =@"已结算";
            }else{
                cell.Label_Right.text = @"未结算";
                cell.Label_Right.textColor = [UIColor redColor];
            }
        }
    }
    return cell;
}

//分享合伙人
- (IBAction)shareToWeChat {
    
    NSString *url = [NSString stringWithFormat:@"http://www.haocaimao.com/mobile/index.php?u=%@",self.uid];
    [UMSocialWechatHandler setWXAppId:APP_ID appSecret:APP_SECRET url:url];
    
    
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5636fa51e0f55af8bf004172"
                                      shareText:@"0元创业,立刻成为好采猫合伙人，领只招财猫回家！"
                                     shareImage:[UIImage imageNamed:@"partnerLogo"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,nil]
                                       delegate:self];
    
    
}
 

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [SVProgressHUD showSuccessWithStatus:@"分享成功"];
    }
}

//当面扫一扫二维码
- (IBAction)shareForFaceToFace {
    if (self.status) {
        
        if (self.QRCodeView)  {
            [self.view addSubview:self.QRCodeView];
            return;
        }
       [SVProgressHUD show];
        NSMutableDictionary *params =[NSMutableDictionary dictionary];
        params[@"session"] = @{@"uid":self.uid,@"sid":self.sid};
        
        [[HomeNetwork sharedManager]postPartnerQRCodeCreateURL:params successBlock:^(id responseBody) {
            
            [self setupQRCode:responseBody];
            
            [SVProgressHUD dismiss];
            
        } failureBlock:^(NSString *error) {
            [SVProgressHUD showInfoWithStatus:@"加载失败"];
        }];
    }
}

//创建二维码
-(void)setupQRCode:(NSDictionary *)responseBody{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = HCMColor(30, 30, 30, 0.7);
    view.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.y = 150;
    imageView.x = (HCMScreenWidth-220) /2;
    HCMLog(@"%f",HCMScreenHeight);
    imageView.size = CGSizeMake(220, 220);
    [imageView sd_setImageWithURL:responseBody[@"data"][@"shareImages"]];
    [view addSubview:imageView];
    
    UIButton *button =[[UIButton alloc]init];
    button.frame = [UIScreen mainScreen].bounds;
    [button addTarget:self action:@selector(dismissQRCode) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    self.QRCodeView = view;
    
}

//关闭二维码
-(void)dismissQRCode{
    [self.QRCodeView removeFromSuperview];
    
}

-(void)clickBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
}
@end
