//
//  DealViewController.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/24.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//  商品详情页
//  如果你看到这个商品详情，我估计你会晕掉，建议自己重写！

#define sides 10 //控件间距
#define baseControlHeight 50 //控件的基本高度
#define PopViewBaseHeight 150 //没有规格参数的最小的大小

#define priceMark \

#import "UMSocialWechatHandler.h"

#import "DealViewController.h"
#import "DealModel.h"

#import "JKAlertDialog.h"
#import "MBProgressHUD+MJ.h"
#import "HCMDealWebViewController.h"
#import "HCMCommentTableViewController.h"

#import "HCMVipLoginViewController.h"
#import "MKNumberBadgeView.h"
#import "HomeNetwork.h"
#import "GoodsCommentModel.h"

#import "GoodsCommentFrame.h"
#import "HCMShoppingTableViewController.h"
#import "HCMTabBarViewController.h"

#import "GoodsFormartMessage.h"
#import "UMSocial.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIImageView+MJWebCache.h"

@interface DealViewController ()<UIScrollViewDelegate,UIAlertViewDelegate,UMSocialUIDelegate,UITextFieldDelegate>
/**
 *  主滚动和商品图滚动
 */
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *Pictures_ScrollVIew;
/**
 *  商品的价格，名称，库存
 */
@property (weak, nonatomic) IBOutlet UILabel *shop_price_Top;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *market_price;
@property (weak, nonatomic) IBOutlet UILabel *goods_number;
@property (weak, nonatomic) IBOutlet UILabel *promote_end_date;
@property (weak, nonatomic) IBOutlet UILabel *Freight;//运费
@property (strong,nonatomic) DealModel *dealModel;

//最大购买数
@property(nonatomic,copy)NSString *buyMax;
//加号按钮
@property(nonatomic,strong)UIButton *addButton;
//接收图片的数组
@property(nonatomic ,strong)NSArray *small_pic_array;
@property(nonatomic ,strong)NSArray *thumb_pic_array;
//商品详情webview
@property (strong, nonatomic) IBOutlet UIView *buyCountView;

//****  弹出VIew的参数 ***/
@property(nonatomic) NSInteger count;              //记录购买数量
@property(nonatomic)CGFloat changeHeight;           //改变的高度
@property(assign,nonatomic) NSInteger tag;           //存储被点击的规格按钮
@property(assign,nonatomic) NSInteger tagOne;           //存储被点击的规格按钮
@property(assign,nonatomic) NSInteger tagTwo;           //存储被点击的规格按钮
@property(strong ,nonatomic)UILabel *format_name;     //可选规格的名称
@property(strong ,nonatomic)UILabel * countNumLabel;//-购买数量的label+
@property (weak, nonatomic) IBOutlet UIButton *countButton;//数量按钮
@property(strong ,nonatomic)NSMutableArray *format_id_array;//存储商品规格id的数组
@property(strong ,nonatomic)NSMutableArray *format_id_arrayOne;//存储商品规格id的数组
@property(strong ,nonatomic)NSMutableArray *format_id_arrayTwo;//存储商品规格id的数组
@property(strong ,nonatomic)NSMutableArray *format_nameAndPrice_array;//存储商品规格name的数组
@property(strong ,nonatomic)NSMutableArray *btnsArray;//存储可选规格的btn
//商品评论
@property (strong , nonatomic)NSMutableArray *commentArray;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
//商品规格
@property(nonatomic,strong) NSMutableArray *goods_Format_array;

@property(nonatomic,strong)NSArray * format_nameArr;
@property(nonatomic,strong)NSArray * format_msgArr;
@property(nonatomic,strong)NSArray * btnArr;
@property(nonatomic,strong)NSArray * btnArra;
@property(nonatomic,strong)NSMutableArray *allBtnPrice;
@property(nonatomic,copy)NSString *markPrice;
@property(nonatomic)float NewPrice_add;
//@property(nonatomic,copy)UILabel * priceLabel;

//购物车右上角徽标
@property (strong, nonatomic)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIToolbar *testToolbar;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buyNowAndAddCart;

@property(strong,nonatomic)NSUserDefaults *defaults;
@property(assign,nonatomic)BOOL status;
@property(strong,nonatomic)NSString *sid;
@property(strong,nonatomic)NSString *uid;
@property(nonatomic,strong)NSString *goods_list_number;
@property(strong,nonatomic)MKNumberBadgeView *numberBadge;
@property(strong,nonatomic)HCMShoppingTableViewController *shopping;
@property(assign,nonatomic)NSInteger counter;
@property (weak, nonatomic) IBOutlet UILabel *residueTime;

@property(copy,nonatomic)NSString *app_app;
@property(copy,nonatomic)NSString *myError;
@property(copy,nonatomic)NSString *youError;

@property(strong,nonatomic)NSMutableArray *shareImageArray;
@property(strong,nonatomic)UITextField *countTextField;

@property(strong,nonatomic)JKAlertDialog *alert;
@property(assign,nonatomic)NSInteger buyOrCartIndex;
@property(nonatomic)BOOL markClickBtn;
@end


@implementation DealViewController
- (MKNumberBadgeView *)numberBadge{
    if (!_numberBadge) {
       _numberBadge = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(self.testToolbar.frame.size.width-23, self.testToolbar.frame.size.height - 45, 23, 23)];
        [self.testToolbar addSubview:_numberBadge];

    }
    return _numberBadge;
}

-(NSString *)receiveBadgeValue{
    if (!_receiveBadgeValue) {
        _receiveBadgeValue = [[NSString alloc]init];
    }
    return _receiveBadgeValue;
}
-(HCMShoppingTableViewController *)shopping{
    if (!_shopping) {
        _shopping = [[HCMShoppingTableViewController alloc]init];
    }
    return _shopping;
}
-(NSUserDefaults *)defaults{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
            }
    return _defaults;
}
-(NSString *)sid{
    if (!_sid) {
        _sid = [self.defaults objectForKey:@"sid"];
    }
    return _sid;
}
-(NSString *)uid{
    if (!_uid) {
        _uid = [self.defaults objectForKey:@"uid"];
    }
    return _uid;
}

-(BOOL)status{
    if (!_status) {
        _status = [self.defaults boolForKey:@"status"];
    }
    return _status;
}
-(NSArray *)format_msgArr{
    if (!_format_msgArr) {
        _format_msgArr = [[NSMutableArray alloc]init];
    }
    return _format_msgArr;
}
-(NSArray *)format_nameArr{
    if (!_format_nameArr) {
        _format_nameArr = [[NSMutableArray alloc]init];
    }
    return _format_nameArr;
}

-(NSMutableArray *)format_id_arrayTwo{//如果有规格选，则记录规格id
    if (!_format_id_arrayTwo) {
        _format_id_arrayTwo = [[NSMutableArray alloc]init];
    }
    return _format_id_arrayTwo;
}
-(NSMutableArray *)format_id_arrayOne{//如果有规格选，则记录规格id
    if (!_format_id_arrayOne) {
        _format_id_arrayOne = [[NSMutableArray alloc]init];
    }
    return _format_id_arrayOne;
}
-(NSMutableArray *)format_id_array{//如果有规格选，则记录规格id
    if (!_format_id_array) {
        _format_id_array = [[NSMutableArray alloc]init];
    }
    return _format_id_array;
}
-(NSMutableArray *)allBtnPrice{
    if (!_allBtnPrice) {
        _allBtnPrice = [NSMutableArray array];
    }
    return _allBtnPrice;
}


-(NSMutableArray *)format_nameAndPrice_array{
    if (!_format_nameAndPrice_array) {
        _format_nameAndPrice_array = [[NSMutableArray alloc]init];
    }
    return _format_nameAndPrice_array;
}
-(NSMutableArray *)btnsArray{
    if (!_btnsArray) {
        _btnsArray = [NSMutableArray array];
    }
    return _btnsArray;
}
-(UILabel *)format_name{//记录规格的名字，如果没有规格则显示：单一规格
    if (!_format_name) {
        _format_name = [[UILabel alloc]init];
    }
    return _format_name;
}
-(UILabel *)countNumLabel{//记录-购买数量的label+
    if (!_countNumLabel) {
        _countNumLabel = [[UILabel alloc]init];
    }
    return _countNumLabel;
}
-(NSMutableArray *)goods_Format_array{//记录储存请求回来的规格数组
    if (!_goods_Format_array) {
        _goods_Format_array = [NSMutableArray array];
    }
    return _goods_Format_array;
}

-(NSMutableArray *)shareImageArray{
    if (!_shareImageArray) {
        _shareImageArray = [NSMutableArray array];
    }
    return _shareImageArray;
}


#pragma mark --- 系统viewDidLoad ---

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //初始化
    [self setUpController];
    
    //分享到微信
    [self shareToWeChet];
    
    //请求商品详情
    [self sendDealOfGoodsRequest];
    
}

-(void)setUpController{
    
    self.count = 1;
    
    self.mainScrollView.delegate = self;
    
    self.Pictures_ScrollVIew.delegate = self;
    
    self.title = @"产品信息";
    
    //自动调整滚动视图插图(自动调整scorllview高度)
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickshare) image:@"item-info-header-share-icon-1" highImage:@"item-info-header-share-icon-1"];
}

//分享到微信
-(void)shareToWeChet{
    
    NSString *url = [[NSString alloc]init];
    if (self.status) {//带用户信息的分享
        NSString *uid = [self.defaults objectForKey:@"uid"];
        url = [NSString stringWithFormat:@"http://www.haocaimao.com/mobile/index.php?u=%@&m=default&c=goods&a=index&id=%@",uid,self.goods_id];
    }else{//没登录不带用户信息
        url = [NSString stringWithFormat:@"http://www.haocaimao.com/mobile/index.php?m=default&c=goods&a=index&id=%@",self.goods_id];
    }
    [UMSocialWechatHandler setWXAppId:APP_ID appSecret:APP_SECRET url:url];
}


#pragma mark --- 商品详情的toolBar所有控件 ---
/**                 ***
 *  加入购物车 按钮    *  立即购买 按钮
 *                  **/
- (IBAction)addCartCreateButton:(UIButton *)sender {

    if ([self.app_app isEqualToString:@"1"]) {
        
        [SVProgressHUD showInfoWithStatus:@"此商品暂时无法购买"];
        
        return;
    }
    
    _markClickBtn = YES;
    
    NSInteger index = [self.buyNowAndAddCart indexOfObject:sender];
    
    self.buyOrCartIndex = index;
    
    BOOL status = [self.defaults boolForKey:@"status"];

    if (status) {
        
        if ([self.countButton.titleLabel.text isEqualToString:@"规格数量"]) {
            
            [self PopViewShow:nil];
                
            return;

        }        
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];

            //判读是否有sepc(规格)数据再取数据
            if (self.format_id_array.count == 0) {
                dict[@"spec"] = @"";
   
              }else{

                NSMutableArray *arr = [[NSMutableArray alloc]init];
                
                [arr addObject:self.format_id_array[self.tag]];
                  
                if (self.format_id_arrayOne.firstObject != nil) {
                    [arr addObject:self.format_id_arrayOne[self.tagOne]];}
                  
                if (self.format_id_arrayTwo.firstObject != nil) {
                    [arr addObject:self.format_id_arrayTwo[self.tagTwo]];}
                dict[@"spec"] = arr;
            }
        
        
        NSString *uid = [self.defaults objectForKey:@"uid"];
        NSString *sid = [self.defaults objectForKey:@"sid"];

        NSDictionary * dictBuyNow =   @{
                                        @"session":@{@"sid":sid,@"uid":uid},
                                        @"spec":dict[@"spec"],
                                        @"number":self.countTextField.text,
                                        @"goods_id":self.goods_id
                                        };

        [[HomeNetwork sharedManager]postBuyNow:dictBuyNow successBlock:^(id responseBody) {
           
            self.myError = responseBody[@"status"][@"error_desc"];

            if (index == 0) {//点击立即购买,跳转页面

                if([self.myError isEqualToString:@"您已经达到该商品抢购上限！"]){
                    self.tabBarController.selectedIndex = 2;
                    
                    return;
                }
                
                ///判断是否重复
                if (responseBody[@"status"][@"error_code"]) {
                    
                    [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
                    return ;
                }

                self.tabBarController.selectedIndex = 2;
                if (self.tabBarController.selectedIndex == 2) {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }

        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:error];
            
        }];

        NSDictionary * dictAddToCart = @{@"session":@{@"sid":sid,@"uid":uid}};
        
        [[HomeNetwork sharedManager]postAddToCart:dictAddToCart successBlock:^(id responseBody) {
            
            //判断
            if (responseBody[@"status"][@"error_code"]) {
                
                [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];

                return;
            }
            
            if (index == 1) {
                
                if([self.myError isEqualToString:@"购买失败"]){
                    
                    [SVProgressHUD showInfoWithStatus:@"购买失败"];
                    return;
                    
                }
                
                if([self.myError isEqualToString:@"您已经达到该商品抢购上限！"]){
                    
                    [SVProgressHUD showInfoWithStatus:@"已达到该商品抢购上限！"];
                    return;
                    
                }

                [self loadGoods_number];
                self.receiveBadgeValue= self.goods_list_number;
                
                [SVProgressHUD showSuccessWithStatus:@"已加入购物车"];

            }
            
        } failureBlock:^(NSString *error) {
            
           [SVProgressHUD showInfoWithStatus:error];
            
            if (error) {
                
                [SVProgressHUD showInfoWithStatus:error];
                return;
            }
        }];
        return;
        
    }else{
        
        HCMVipLoginViewController *login =[[HCMVipLoginViewController alloc]init];
        [self.navigationController presentViewController:login animated:YES completion:nil];

    }

}

/**
 *  我的收藏
 */
- (IBAction)collectButton:(UIButton *)sender {

   // NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    BOOL status = [self.defaults boolForKey:@"status"];
    if (status) {
        
        if (self.collectButton.selected == NO) {
            
            self.collectButton.selected = YES;
            
            NSString *uid = [self.defaults objectForKey:@"uid"];
            NSString *sid = [self.defaults objectForKey:@"sid"];
            
            NSDictionary *dict = @{@"session":@{@"sid":sid,@"uid":uid},@"goods_id":self.goods_id};
            
            [[HomeNetwork sharedManager]postCollectGoods:dict successBlock:^(id responseBody) {
                ///判断是否
                if (responseBody[@"status"][@"error_code"]) {
                    
                    self.collectButton.selected = NO;
                    [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
                    HCMVipLoginViewController *vip = [[HCMVipLoginViewController alloc]initWithNibName:@"HCMVipLoginViewController" bundle:nil];
                    [self.navigationController pushViewController:vip
                                                         animated:YES];
                    return ;
                }else{
                    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                }
                return;
            } failureBlock:^(NSString *error) {
                
                [SVProgressHUD showInfoWithStatus:error];
                if (error) {
                    self.collectButton.selected = NO;
                    [SVProgressHUD showInfoWithStatus:error];
                    
                    return;
                }
                
            }];
            
        }else{
            
            
            
        }
        
        return;
        
    }else{
     
        HCMVipLoginViewController *login =[[HCMVipLoginViewController alloc]init];
        [self.navigationController presentViewController:login animated:YES completion:nil];
    }
}

/**
 *  购物车
 */
- (IBAction)cartButton:(UIButton *)sender {
    
    
    BOOL status = [self.defaults boolForKey:@"status"];
    if (status) {
        
        NSString *uid = [self.defaults objectForKey:@"uid"];
        NSString *sid = [self.defaults objectForKey:@"sid"];
        
        NSDictionary *dict = @{@"session":@{@"sid":sid,@"uid":uid}};
        
        [[HomeNetwork sharedManager]postShoppingCart:dict successBlock:^(id responseBody) {
            
            ///判断是否
            if (responseBody[@"status"][@"error_code"]) {
                
                [SVProgressHUD showInfoWithStatus:responseBody[@"status"][@"error_desc"]];
                return ;
            }
            
            self.tabBarController.selectedIndex = 2;
            if (self.tabBarController.selectedIndex == 2) {
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        } failureBlock:^(NSString *error) {
            
            [SVProgressHUD showInfoWithStatus:error];
        }];
        
        
        
    }else{
        
        HCMVipLoginViewController *login =[[HCMVipLoginViewController alloc]init];
        [self.navigationController presentViewController:login animated:YES completion:nil];
    }
}

/**
 *  翻页动画
 */
- (void)animationtype{
    CATransition *animation = [CATransition animation];
    animation.duration = 1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    //animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromTop;
    
    [self.view.window.layer addAnimation:animation forKey:nil];
}

/**
 *  购物车徽标
 */
-(void)setMKNumberBadgeView{
    
    self.numberBadge.value = [self.goods_list_number integerValue];
    
    self.numberBadge.contentMode = UIViewContentModeScaleToFill;
    
}



#pragma mark --- 商品评论 ---
/**
 *  商品评论按钮
 */
- (IBAction)CommentButton:(UIButton *)sender {
    
    [MBProgressHUD showMessage:@"加载数据"];
    
    NSDictionary *dict = @{@"goods_id":self.goods_id,@"pagination":@{@"count":@"20",@"page":@"1"}};
    
    [[HomeNetwork sharedManager]postGoodsComment:dict successBlock:^(id responseBody) {
        
        NSMutableArray *mutabArray = [NSMutableArray array];
        
        for (NSDictionary *dict in responseBody[@"data"]) {
            
            GoodsCommentModel *goodModel = [GoodsCommentModel goodsCommentWithJSON:dict];
            
            GoodsCommentFrame * goodsFrame = [[GoodsCommentFrame alloc]init];
            
            goodsFrame.comment = goodModel;
            
            [mutabArray addObject:goodsFrame];
        }
        
        self.commentArray = mutabArray;
    
        HCMCommentTableViewController *commentVC = [[HCMCommentTableViewController alloc]initWithNibName:@"HCMCommentTableViewController" bundle:nil];
        
        commentVC.receiveCommentArray = self.commentArray;
        
        [self.navigationController pushViewController:commentVC animated:YES];
        
        [MBProgressHUD hideHUD];
        
    } failureBlock:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:error];
    }];
    
    
}

#pragma mark --- 购买数量 ---
/**
 *  修改购买数量  键盘弹出
 */
-(void)changeTextFieldStatus{
    
    HCMLogFunc;
    
    [self.countTextField becomeFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
         self.alert.y = - (self.changeHeight/2) - 30;
    }];

}

/**
 *  购买数量  *  加
 */
-(void)countAdd{
    
    int buymax = [self.buyMax intValue];
    
    if (self.count == buymax && self.countTextField.text.length) {
        
        [SVProgressHUD showInfoWithStatus:@"已是最大购买数量"];
        self.count = 1;
        return;
    }else{
         self.count = [self.countTextField.text integerValue];
        self.count += 1;
        self.countTextField.text = [NSString stringWithFormat:@"%ld",(long)self.count];

    }
    
}

/**
 *  购买数量  *  减
 */
-(void)countSub{
    
    self.count = [self.countTextField.text integerValue];
    self.count -= 1;
    while (self.count < 1) {
        self.count = 1;
    }
    self.countTextField.text = [NSString stringWithFormat:@"%ld",(long)self.count];

}

/**
 *  购买数量  *  确定
 */
-(void)clickOK{
    
    if (!self.countTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"数量不能为空"];
        return;
    }
    
    [self.alert dismiss];
    
    self.count = [self.countTextField.text integerValue];
    
    [self.countTextField resignFirstResponder];
    
    if (self.btnsArray.count == 0) {
        
        [self.countButton setTitle:[NSString stringWithFormat:@"数量 : %zd",self.count] forState:UIControlStateNormal];
        
    }else{
        UIButton *btn =  self.btnsArray[self.tag];
        [self.countButton setTitle:[NSString stringWithFormat:@"数量:%zd 规格:%@",self.count,btn.titleLabel.text] forState:UIControlStateNormal];
        
    }
    
//    [self getThePriceForGood:self.markPrice upDownPrice:self.allBtnPrice[self.tag]];

    if (_markClickBtn) {

        UIButton *btn = [self.buyNowAndAddCart objectAtIndex:_buyOrCartIndex];

        [self addCartCreateButton:btn];
    }
    
  
    
}

#pragma mark --- PopView弹出 ---
/**
 *  数量按钮：PopView弹出
 */
- (IBAction)PopViewShow:(id)sender {
    
    
    UIColor *color=HCMColor(200, 45, 55,1.0);
    CGFloat buyviewW = self.buyCountView.frame.size.width;
    CGFloat buyviewH = PopViewBaseHeight + self.changeHeight;

    if (self.alert) {
        self.alert=[[JKAlertDialog alloc]initWithTitle:@"购买数量" message:@"" color:color andBoolen:YES AlertsWidth:buyviewW AlertsHeight:buyviewH];

        self.alert.contentView=self.buyCountView;
        [self.alert show];

        return;
    }

    CGFloat newH = 10;
    self.changeHeight = 0;
    
    int j = 0;
    
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 0;//用来控制button距离父视图的高
    
    
//    [self.buyCountView addSubview:self.priceLabel];
    
    NSArray *markArr = nil;
    
    for (NSString *str in self.format_nameArr) {
        
        int i = 0;
        int test = 0;
        
        NSMutableArray *markArray = [[NSMutableArray alloc]init];
        
        
        UILabel *label = [[UILabel alloc]init];
        NSMutableArray *format_nameAndPrice_array = [NSMutableArray new];
        //规格名称
        label.text = str;
        label.textColor = HCMColor(33, 33, 33,1.0);
        
        if (self.changeHeight) {
            self.changeHeight += 28;
            h = self.changeHeight;
        }
        
        label.frame = CGRectMake(10,  newH + self.changeHeight, 150, 20);
        
        label.backgroundColor = [UIColor clearColor];
        [self.buyCountView addSubview:label];
        
        for (GoodsFormartMessage *dealFormat in self.format_msgArr[j]) {
            
            NSString *str_id = dealFormat.format_ID;
            NSString *str_Name = dealFormat.label;
            NSString *str_price = dealFormat.price;
            
            if (j==0) {[self.format_id_array addObject:str_id];
                [self.allBtnPrice addObject:str_price];}
            if (j==1) {[self.format_id_arrayOne addObject:str_id];}
            if (j==2) {[self.format_id_arrayTwo addObject:str_id];}
            
            [format_nameAndPrice_array addObject:str_Name];
        }
        
        markArr = format_nameAndPrice_array;
        
        for (int k = 0; k<markArr.count; k++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            
            button.tag = i;
            [button setBackgroundImage:[UIImage imageNamed:@"item-info-buy-kinds-btn-grey"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"item-info-buy-kinds-active-btn"] forState:UIControlStateSelected];
            [button setTintColor:[UIColor clearColor]];
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            if (j==0) {[button addTarget:self action:@selector(chooseFormatButton:) forControlEvents:UIControlEventTouchUpInside];}
            if (j==1) {[button addTarget:self action:@selector(chooseFormatButtonOne:) forControlEvents:UIControlEventTouchUpInside];}
            if (j==2) {[button addTarget:self action:@selector(chooseFormatButtonTwo:) forControlEvents:UIControlEventTouchUpInside];}
            
            //根据计算文字的大小
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
            CGFloat length = [markArr[k] boundingRectWithSize:CGSizeMake(self.buyCountView.frame.size.width, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
            
            //为button赋值
            [button setTitle:markArr[k] forState:UIControlStateNormal];
            
            //设置button的frame
            button.frame = CGRectMake(5 + w, h + newH + 25  , length+8, 20);
            //            if (test == 1) {
            //
            //                h = h + button.frame.size.height + 10;
            //
            //            }
            
            if(5 + w + length + 10 > self.buyCountView.frame.size.width){//当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
                w = 0; //换行时将w置为0
                h = h + button.frame.size.height + 8;
                button.frame = CGRectMake(5 + w, h + newH +25 , length+8, 20);//重设button的frame
            }
            
            w = button.frame.size.width + button.frame.origin.x;
            self.changeHeight = h + newH + 15 ;
            [markArray addObject:button];
            [self.buyCountView addSubview:button];
            i++;
        }
        if (j == 0) {self.btnsArray = [markArray copy];}
        if (j == 1) {self.btnArr = [markArray copy];}
        if (j == 2) {self.btnArra = [markArray copy];}
        w = 0;
        j++;
        test++;
        
    }

    
    //********************************************************************////
    buyviewH = PopViewBaseHeight + self.changeHeight;

    //分割线
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, baseControlHeight + self.changeHeight, 200, 1)];
    label.backgroundColor = HCMColor(234, 234, 234,1.0);
    [self.buyCountView addSubview:label];
    
    //减
    UIButton *subButton = [[UIButton alloc]initWithFrame:CGRectMake(80, baseControlHeight + sides + self.changeHeight, 30, 30)];
    [subButton setImage:[UIImage imageNamed:@"item-info-buy-choose-min-btn"] forState:UIControlStateNormal];
    [subButton addTarget:self action:@selector(countSub) forControlEvents:UIControlEventTouchUpInside];
    [self.buyCountView addSubview:subButton];
    
    //加
    self.addButton = [[UIButton alloc]initWithFrame:CGRectMake(165, baseControlHeight + sides + self.changeHeight, 30, 30)];
    [self.addButton setImage:[UIImage imageNamed:@"item-info-buy-choose-sum-btn"] forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(countAdd) forControlEvents:UIControlEventTouchUpInside];
    [self.buyCountView addSubview:self.addButton];
    
    //数目
    UITextField * countTextField =[[UITextField alloc]init];
    countTextField.frame = CGRectMake(110, baseControlHeight +sides +2 + self.changeHeight, 56, 26);
    countTextField.text = @"1";
    countTextField.backgroundColor = HCMColor(245, 245, 245,1.0);
    countTextField.textAlignment = NSTextAlignmentCenter;
    countTextField.keyboardType = UIKeyboardTypeNumberPad;
    [countTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.countTextField = countTextField;
    [self.buyCountView addSubview:self.countTextField];
    

    UIButton *countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    countBtn.frame = CGRectMake(110, baseControlHeight +sides +2 + self.changeHeight, 56, 26);
    [countBtn setBackgroundColor:[UIColor clearColor]];
    [countBtn addTarget:self action:@selector(changeTextFieldStatus) forControlEvents:UIControlEventTouchUpInside];
    [self.buyCountView addSubview:countBtn];

    //确定
    UIButton *OKButton = [[UIButton alloc]init];//WithFrame:CGRectMake(8, baseControlHeight + 50 + self.changeHeight, 244, 35)];
    OKButton.x = 17 ;
    OKButton.y = baseControlHeight + 50 + self.changeHeight;
    OKButton.size = CGSizeMake(244, 35);
    
    [OKButton setBackgroundImage:[UIImage imageNamed:@"button-narrow-red"] forState:UIControlStateNormal];
    [OKButton setTitle:@"确  定" forState:UIControlStateNormal];
    [OKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [OKButton addTarget:self action:@selector(clickOK) forControlEvents:UIControlEventTouchUpInside];
    [self.buyCountView addSubview:OKButton];
    
    //*** 弹出框的大小内容
    self.alert=[[JKAlertDialog alloc]initWithTitle:@"购买数量" message:@"" color:color andBoolen:YES AlertsWidth:buyviewW AlertsHeight:buyviewH];
    
    self.alert.contentView=self.buyCountView;
    [self.alert show];

}

- (void) textFieldDidChange:(UITextField *) TextField{
    self.count =  [TextField.text integerValue];
  
}

-(void)chooseFormatButton:(UIButton *)btns{
    
    self.tag = btns.tag;
    for (UIButton *btn in self.btnsArray) {
        btn.selected = NO;
    }
    btns.selected = YES;
    
    self.countTextField.text = @"1";
    if (self.btnsArray.count == 0) {
        
        [self.countButton setTitle:[NSString stringWithFormat:@"数量 : %zd",self.count] forState:UIControlStateNormal];
        return;
    }else{
        UIButton *btn =  self.btnsArray[self.tag];
        [self.countButton setTitle:[NSString stringWithFormat:@"数量:%zd 规格:%@",self.count,btn.titleLabel.text] forState:UIControlStateNormal];
        
    }

//    [self getThePriceForGood:self.markPrice upDownPrice:self.allBtnPrice[self.tag]];
    
}

//截取价格字符串 加减价格
//-(void)getThePriceForGood:(NSString *)price upDownPrice:(NSString *)upDownPrice{
//
//    NSRange range = [price rangeOfString:@"元"];
//    NSUInteger location = range.location;
//    
//    NSString *priceC = [[NSString alloc]initWithFormat:@"%@",[price substringToIndex:location]];
//    float floatPriceStr = [priceC floatValue];//原价
//
//    float test =  [upDownPrice floatValue];
//    
//    floatPriceStr = floatPriceStr + test;
//    
//    self.shop_price_Top.text = [NSString stringWithFormat:@"￥%.2f元",floatPriceStr];
//
//    
//}

-(void)chooseFormatButtonOne:(UIButton *)btns{
     self.tagOne = btns.tag;
    for (UIButton *btn in self.btnArr) {
        btn.selected = NO;
    }
    btns.selected = YES;
}

-(void)chooseFormatButtonTwo:(UIButton *)btns{
    self.tagTwo = btns.tag;
    for (UIButton *btn in self.btnArra) {
        btn.selected = NO;
    }
    btns.selected = YES;
}

-(void)clickshare{

    if (!self.status) {

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"你尚未登录，合伙人登录分享 才有收益噢!" delegate:self cancelButtonTitle:@"不登录分享" otherButtonTitles:@"先登录", nil];
        
        [alert show];
    }else{
        
        [self shareGoodsAndSomeInfo];
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [self shareGoodsAndSomeInfo];
    }else{
        
        HCMVipLoginViewController *vc = [[HCMVipLoginViewController alloc]init];
        
        [self presentViewController:vc animated:YES completion:nil];

    }
}

-(void)shareGoodsAndSomeInfo{
    UIImageView *imageView = [self.shareImageArray firstObject];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5636fa51e0f55af8bf004172"
                                      shareText:self.goods_name.text
                                     shareImage:imageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,nil]
                                       delegate:self];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        //NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

-(void)clickBack{
    
    [MBProgressHUD hideHUD];
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
     [self.timer invalidate];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;

    self.navigationController.navigationBarHidden = NO;
    if (_status) {
        [self loadGoods_number];
    }
}


/**
 *  商品详情webView
 */
- (IBAction)GoodsDealsShow:(UIButton *)sender {
    
    HCMDealWebViewController *webViewVC = [[HCMDealWebViewController alloc]initWithNibName:@"HCMDealWebViewController" bundle:nil];
    
    webViewVC.receive_id = self.passGoodsDeal_id_Str;
    
    [self.navigationController pushViewController:webViewVC animated:YES];
    
}

#pragma mark --- 商品详情请求 ---

/**
 *  发送商品详情的请求体
 */
-(void)sendDealOfGoodsRequest{
    
    [SVProgressHUD showWithStatus:@"网络加载"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    HCMLog(@"%@",self.goods_id);
    
    if (self.status) {
        
        params[@"session"] = @{@"sid":self.sid,@"uid":self.uid};
        params[@"goods_id"] = self.goods_id;
        
    }else{
        
        params[@"goods_id"] = self.goods_id;
        
    }
    
    [manager POST:@"http://www.haocaimao.com/ecmobile/?url=goods" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
        //如果登录成功
        if (!jsonDict[@"status"][@"error_code"] && params[@"session"]!=nil) {

             [self parseJsonData:jsonDict];
            
            //发送购物车
            [self loadGoods_number];
            
        }else{
            
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            
            param[@"goods_id"] = self.goods_id;
            
            [manager POST:@"http://www.haocaimao.com/ecmobile/?url=goods" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                    [self parseJsonData:jsonDic];
                
                    return ;
            
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                    [SVProgressHUD showInfoWithStatus:error.userInfo.description];
                 
             }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(clickBack) userInfo:nil repeats:NO];
        
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        [SVProgressHUD dismiss];
        
    }];
    
}

- (void)loadGoods_number{
    
    NSDictionary * dictBuyNow = @{@"session":@{@"sid":self.sid,@"uid":self.uid}};
    
    /*得到购物车信息 */
    [[HomeNetwork sharedManager]postAddToCart:dictBuyNow successBlock:^(id responseBody) {
        
        self.goods_list_number = responseBody[@"data"][@"total"][@"real_goods_count"];
        
        [self setMKNumberBadgeView];
        
    } failureBlock:^(NSString *error) {
        
        [SVProgressHUD showInfoWithStatus:error];
        
    }];

}

//倒计时
-(void)promoteEndDate:(NSString *)inputTime{
    
    //当前时间
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:60*8*60];
    NSString *timeStr = [NSString stringWithFormat:@"%@",dat];
    
    
    NSRange range = [timeStr rangeOfString:@"+"];
    timeStr = [timeStr substringToIndex:range.location];
    
    
    
    //特价截至时间
    NSString *endTimeStr = [NSString stringWithFormat:@"%@",inputTime];
    range = [endTimeStr rangeOfString:@"+"];
    endTimeStr = [endTimeStr substringToIndex:range.location];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *cal=[NSCalendar currentCalendar];
    unsigned int unitFlags= NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:[date dateFromString:timeStr] toDate:[date dateFromString:endTimeStr] options:0];
    
    //时间差
   // NSString *timeIntervalStr = [NSString stringWithFormat:@"%ld天%ld小时%ld分钟%ld秒",(long)[d day],(long)[d hour],(long)[d minute],(long)[d second]];
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    //时间差秒
    NSInteger sec = [d day]*86400 +[d hour]*3600+[d minute]*60+[d second];
    self.counter = sec;
    
}

-(void)updateTimer:(NSTimer *)timer{
    
    if (--self.counter <0 ) {
        [self.timer invalidate];
    }else{
        self.promote_end_date.text = [NSString stringWithFormat:@"%d天%d小时%d分钟%d秒",(self.counter/86400),(self.counter/3600%24),(self.counter/60%60),(self.counter%60)];
    }
}

//解析
-(void)parseJsonData:(NSDictionary *)jsonDict{
    
    
    NSLog(@"%@",jsonDict);
    
    ///判断是否重复
    if (jsonDict[@"status"][@"error_code"]) {
        
        [SVProgressHUD showInfoWithStatus:jsonDict[@"status"][@"error_desc"]];
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    
    //商品详情
    self.dealModel = [DealModel GoodsDealWithJSON:jsonDict];
    
    self.passGoodsDeal_id_Str = self.dealModel.goods_id;
    if ([self.dealModel.promote_price isEqual:@0]) {
        
        self.markPrice = self.dealModel.shop_price;
        self.shop_price_Top.text = [NSString stringWithFormat:@"￥%@",self.dealModel.shop_price];
        
    }else if(self.passGoodsDeal_id_Str != nil){
        
        self.shop_price_Top.text = [NSString stringWithFormat:@"￥%@",self.dealModel.formated_promote_price];
        NSString *str =self.dealModel.promote_end_date;
        [self promoteEndDate:str];
        self.residueTime.hidden = NO;
        self.promote_end_date.hidden = NO;
    }
    
    self.app_app = self.dealModel.app_app;
    self.market_price.text = self.dealModel.market_price;
    self.goods_number.text = self.dealModel.goods_number;
    self.goods_name.text = self.dealModel.goods_name;
    self.buyMax = self.dealModel.buyMax;
    
    if ([self.dealModel.is_shipping isEqualToString:@"1"]) {
        self.Freight.text = @"邮费:  包邮";
    }
    if (self.shop_price_Top.text) {
        NSString *str = self.dealModel.shop_price;
        NSRange range = NSMakeRange(0, (str.length -1));
        str = [str substringWithRange:range];
        if (str.floatValue >= 39.0) {
            self.Freight.text = @"运费:  包邮";
        }
    }
   
    //shopping.tabBarItem.badgeValue = @"26";
    
    //判断是否已经收藏
    BOOL isBOOL = [self.dealModel.collected integerValue];
    if (isBOOL == YES) {
        self.collectButton.selected = YES;
    }

    //***************//解析小图
    self.small_pic_array = jsonDict[@"data"][@"pictures"];
    int i = 0;
    for (NSDictionary *smallDic in self.small_pic_array) {
        
        self.dealModel = [DealModel GoodsSmallPicturesWithJSON:smallDic];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((270*i+10), 10, 260, 260)];
        
        imageView.layer.cornerRadius=5;
        imageView.layer.borderWidth=5;
        imageView.layer.borderColor=[UIColor whiteColor].CGColor;
        imageView.layer.masksToBounds=YES;
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        NSURL *URL = [NSURL URLWithString:self.dealModel.small_pictures_URL];
        
        [imageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"Placeholder_goods"]];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        [self.shareImageArray addObject:imageView];
        
        [self.Pictures_ScrollVIew addSubview:imageView];
        i++;
    }
    
    self.Pictures_ScrollVIew.contentSize = CGSizeMake(i*272, 270);
    
    //**********///解析大图
    self.thumb_pic_array = jsonDict[@"data"][@"pictures"];
    NSMutableArray *thumbMutArray = [NSMutableArray new];
    for (NSDictionary *thumbDic in self.thumb_pic_array) {
        
        [thumbMutArray addObject:thumbDic[@"thumb"]];
        
    }
    self.thumb_pic_array = [thumbMutArray copy];

    //********//解析商品规格数据//**  没有规格信息
    if ([jsonDict[@"data"][@"specification"]firstObject] == nil) {
        self.format_name.text = @"单一规格";
        self.format_name.frame = CGRectMake(100, 10 , 150, 30);
        
        [self.buyCountView addSubview:self.format_name];
        
        NSRange range = [self.markPrice rangeOfString:@"元"];
        NSUInteger location = range.location;
        
        NSString *priceC = [[NSString alloc]initWithFormat:@"%@",[self.markPrice substringToIndex:location]];
        float floatPriceStr = [priceC floatValue];//原价
        
        self.NewPrice_add = floatPriceStr;
        
     }else{///***  有规格信息
         
//         self.priceLabel.textColor = HCMColor(33, 33, 33,1.0);
//         self.priceLabel.frame = CGRectMake(160, 10, 111, 20);
//         self.priceLabel.textColor = [UIColor redColor];
//         self.priceLabel.text = self.shop_price_Top.text;
//         

         NSMutableArray *mutabNames = [NSMutableArray array];
         NSMutableArray *mutabMsg = [NSMutableArray array];
         
         for (NSDictionary *dict in jsonDict[@"data"][@"specification"]) {
             
             [mutabNames addObject:dict[@"name"]];
             NSMutableArray *formartMsg = [NSMutableArray array];
             for (NSDictionary *goods in dict[@"value"]) {
                 GoodsFormartMessage * good = [GoodsFormartMessage objectWithKeyValues:goods];
                 [formartMsg addObject:good];
             }
             [mutabMsg addObject:formartMsg];
         }
         
         self.format_nameArr = [mutabNames copy];
         self.format_msgArr = [mutabMsg copy];
         
     }
    
    [SVProgressHUD dismiss];
}

//浏览大图
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    
    NSInteger count = self.small_pic_array.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        //NSString *url = [self.self.small_pic_array[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:self.thumb_pic_array[i]]; // 图片路径
        photo.srcImageView = self.Pictures_ScrollVIew.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

-(void)dealloc{
    [self.timer invalidate];
    
}
    
@end