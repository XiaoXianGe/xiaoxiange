//
//  HCMCartCell.m
//  haocaimao
//
//  Created by 好采猫 on 15/9/15.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMCartCell.h"

#import "CartDoodsListModel.h"
#import "CartListFrame.h"

#import "HCMbuyView.h"
#define HCMgoodNumY 130
#define HCMgoodNumH 25
@interface HCMCartCell()

@property (nonatomic, weak)NSString *goodsID;
@property (nonatomic, weak)NSString *seller_id;

@property (nonatomic, weak)UIView *goodsView;//商品view
@property (nonatomic, weak)UILabel *goodsNameLabel; //商品名称
@property (nonatomic, weak)UILabel *goodsNumberLabel; //商品数量
@property (nonatomic, weak)UILabel *goodsAttrValueLabel; //商品规格
@property (nonatomic, weak)UIImageView *goodsImg;//商品图片
@property (weak, nonatomic) UIButton *selectedBtn;//选择按钮
@property (weak, nonatomic) UILabel *goods_price;//商品价格



@property (nonatomic, weak)UIButton *allGoodsSelectedBtn;//全选按钮
@property (nonatomic, weak)UIButton *addGoods;
@property (nonatomic, weak)UIButton *reduceGoods;
@property (nonatomic, weak)UILabel *numberGoods;
@property (strong, nonatomic) UIButton *allShopSelectedBtn;

@property (nonatomic, strong) NSString *buyMax;
@end

@implementation HCMCartCell


{
    int _goodsCount;//商品数量
    int _goodsInitCount;
    BOOL good;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MyCell";
    HCMCartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HCMCartCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.cartGoods.goods = ^(BOOL obj){
            good = obj;
            
        };
       
             [self shopView];
            }
    return self;
}


- (void)shopView{
    UIView *goodsView = [[UIView alloc]init];
    goodsView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:goodsView];
    self.goodsView = goodsView;
    
    
    //删除button
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [selectedBtn setBackgroundImage:[UIImage imageNamed:@"button-narrow-gray"] forState:UIControlStateNormal];
    [selectedBtn setImage:[UIImage imageNamed:@"item-delete-shanchu"] forState:UIControlStateNormal];
    [selectedBtn setClipsToBounds:YES];
    selectedBtn.layer.cornerRadius = 13;
    
    self.selectedBtn = selectedBtn;
    [goodsView addSubview:selectedBtn];
    
    
    //商品价格
    UILabel *goods_price = [[UILabel alloc]init];
    goods_price.textColor = [UIColor redColor];
    self.goods_price = goods_price;
    goods_price.font = HCMgoods_priceFont;
    [goodsView addSubview:goods_price];
    
     
    //商品图片
    UIImageView *goodsImg = [[UIImageView alloc]init];
    [goodsImg setImage:[UIImage imageNamed:@"searcher-no-result-empty-icon"]];
    [self.goodsView addSubview:goodsImg];
    self.goodsImg = goodsImg;
    
    //商品名称
    UILabel *goodsNameLabel = [[UILabel alloc]init];
    goodsNameLabel.font = HCMgoodsNameFont;
    goodsNameLabel.numberOfLines = 0;
    goodsNameLabel.textColor = [UIColor blackColor];
    
    [self.goodsView addSubview:goodsNameLabel];
    self.goodsNameLabel = goodsNameLabel;
    
    //商品规格
    UILabel *goodsAttrValueLabel = [[UILabel alloc]init];
    goodsAttrValueLabel.font = HCMgoodsNameFont;
    [self.goodsView addSubview:goodsAttrValueLabel];
    self.goodsAttrValueLabel = goodsAttrValueLabel;
    
    
    // 编辑的数量变化的数据
    UIButton *reduceGoods = [[UIButton alloc]init];
    reduceGoods.userInteractionEnabled = YES;
    [reduceGoods setBackgroundImage:[UIImage imageNamed:@"shopping-cart-edit-choose-min-btn"] forState:UIControlStateNormal];
    [reduceGoods addTarget:self action:@selector(clickReduceGoods) forControlEvents:UIControlEventTouchUpInside];
    [goodsView addSubview:reduceGoods];
    self.reduceGoods = reduceGoods;
    
    UIButton *addGoods = [[UIButton alloc]init];
    [addGoods setBackgroundImage:[UIImage imageNamed:@"shopping-cart-edit-choose-sum-btn"] forState:UIControlStateNormal];
    [addGoods addTarget:self action:@selector(clickAddGoods) forControlEvents:UIControlEventTouchUpInside];
    [goodsView addSubview:addGoods];
    self.addGoods = addGoods;
    
    UILabel *numberGoods = [[UILabel alloc]init];
    numberGoods.backgroundColor = HCMColor(244, 244, 244, 1.0);
    numberGoods.textAlignment = NSTextAlignmentCenter;
    numberGoods.font = [UIFont systemFontOfSize:12];
    [goodsView addSubview:numberGoods];
    self.numberGoods = numberGoods;

    
    [HCMNSNotificationCenter addObserver:self selector:@selector(clickDeleteBtn:) name:@"clickDeleteBtn" object:nil];//编辑事件
}

- (void)clickDeleteBtn:(NSNotification *)notification{
    
    UIButton *btn = notification.userInfo[@"clickDeleteBtn"];
    if (!btn.selected) {
        //[self.delegate clickDeleteGoodsCell:self redID:self.goodsID];
        [self.delegate clickDeleteShopGoodsCell:self seller_id:self.seller_id];
    }
}

- (void)selectedBtn:(UIButton *)selectedBtn{

        [self.delegate clickDeleteGoodsCell:self redID:self.goodsID];
    
}

- (void)clickReduceGoods{
    
    if (_goodsCount == 1) {
        return;
    }else{
        
        _goodsCount--;
        self.numberGoods.text = [NSString stringWithFormat:@"%d",_goodsCount];
    }
    [self.delegate clickEditGoodsNumberCell:self redID:self.goodsID number:_goodsCount];
}

- (void)clickAddGoods{
    
    if ([self.buyMax isEqualToString:@"1"]) {
        
        [SVProgressHUD showInfoWithStatus:@"限购产品"];
        return;
        
    }
    
    _goodsCount++;
    
    self.numberGoods.text = [NSString stringWithFormat:@"%d",_goodsCount];
    [self.delegate clickEditGoodsNumberCell:self redID:self.goodsID number:_goodsCount];
}

- (void)setCartGoods:(CartListFrame *)cartGoods{
    
    _cartGoods = cartGoods;
    CartDoodsListModel *listModel = cartGoods.listModel;
     self.goodsNameLabel.text = listModel.goods_name;
    self.goodsNameLabel.frame = cartGoods.goodsNameLabelF;
    
    self.goodsNumberLabel.text = [NSString stringWithFormat:@"x %@",listModel.goods_number];
    self.goodsNumberLabel.frame = cartGoods.goodsNumberLabelF;
    self.numberGoods.text = listModel.goods_number;
    self.numberGoods.frame = cartGoods.numberGoodsF;
    
    _goodsCount = [listModel.goods_number intValue];
    _goodsInitCount = [listModel.goods_number intValue];
    
    self.goodsAttrValueLabel.text = listModel.goods_attr_value;
    self.goodsAttrValueLabel.frame = cartGoods.goodsAttrValueLabelF;
    
    self.goodsID = listModel.rec_id;
    self.seller_id = listModel.seller_id;
    self.buyMax = listModel.buymax;
    
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:listModel.img_small] placeholderImage:[UIImage imageNamed:@"searcher-no-result-empty-icon"]];
    self.goodsImg.frame = cartGoods.goodsImgF;
    self.reduceGoods.frame = cartGoods.reduceGoodsF;
    self.addGoods.frame = cartGoods.addGoodsF;
    self.goodsView.frame = cartGoods.goodsViewF;
    
    self.goods_price.frame = cartGoods.goods_priceF;
    self.goods_price.text = [NSString stringWithFormat:@"￥%@",listModel.goods_price];
    self.selectedBtn.frame = cartGoods.selectedBtnF;
    
    }


-(void)dealloc{
    [HCMNSNotificationCenter removeObserver:self];
}
@end
