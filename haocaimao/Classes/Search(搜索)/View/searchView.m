//
//  searchView.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/1.
//  Copyright © 2015年 haocaimao. All rights reserved.


#import "searchView.h"
#import "mainTableViewCell.h"
#import "secondCollectionViewCell.h"
#import "HomeCategorySearch.h"

#import "mainTableViewModel.h"
#import "secondCollectionViewModel.h"
#import "secondCollectionReusableView.h"

#define markLineColor HCMColor(230, 230, 230, 1.0)
#define searchViewColor HCMColor(255, 255, 255, 1.0)
#define searchBackgroudColor HCMColor(244, 244, 244, 1.0)

#define BannerHeight 80
#define FristLabelHeight 25
#define sectionHeaderName [UIFont systemFontOfSize:12]
#define tableViewWidth 115

@interface searchView()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>;

/** tableView文字数据 */
@property (strong, nonatomic) NSMutableArray *searchData;
/** tableView图片数据 */
//@property (strong, nonatomic) NSMutableArray *tableViewModel;


/** 选中的位置 */
@property (assign, nonatomic) NSInteger selectedNum;

@property (weak, nonatomic) UITableView *mainTableView;
@property (weak, nonatomic) UICollectionView *secondCollectionView;

@property (weak,nonatomic) UILabel *LineLabel;
@property (weak,nonatomic) UIButton *Btn;
@property (weak,nonatomic) UILabel *HeaderLabel;

@end

@implementation searchView

static NSString *const identifier = @"ID";
static NSString *const headerID = @"CollectionHeaderView";



- (instancetype)initWithFrame:(CGRect)frame WithDataModel:(NSMutableArray *)data WithTableViewModel:(NSMutableArray *)tableViewModel {
    self = [super initWithFrame:frame];
    if (self) {
        _searchData = data;
       // _tableViewModel = tableViewModel;
        _selectedNum = 0;
        [self setupLeftTableView];
        [self setupRightCollectionView];
    }
    return self;
}


//加载tableView 13分类
- (void)setupLeftTableView{
    
    
    CGRect frame;
    
    if (HCMScreenWidth == 414.0) {
        frame = CGRectMake(0, 0, tableViewWidth, HCMScreenHeight-110);
    }else{
        frame = CGRectMake(0, 0, 100, HCMScreenHeight-110);
    }
    
    UITableView *mainTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    
    mainTableView.showsVerticalScrollIndicator = NO;
    mainTableView.backgroundColor = searchBackgroudColor;
    
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    
    self.mainTableView = mainTableView;
    mainTableView.separatorStyle = UITableViewCellAccessoryNone;
    [self addSubview:mainTableView];
    
    [self.mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _searchData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HomeCategorySearch *model = _searchData[indexPath.row];
    
    mainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
   
    if (!cell) {
    
        cell = [[mainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
//    UIView *view = [[UIView alloc]init];
//    view.backgroundColor = markLineColor;
//    view.frame = CGRectMake(0, cell.height-1, cell.contentView.width, 1);
//    [cell.contentView addSubview:view];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    [cell showImage:model.cateLogo textTitle:model.cateName];
    
    if (_selectedNum == indexPath.row) {
        cell.contentView.backgroundColor = searchViewColor;
        
    }else{
        
        cell.contentView.backgroundColor = searchBackgroudColor;
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HCMLog(@"%ld",(long)indexPath.row);

    self.selectedNum = indexPath.row;
    
    HomeCategorySearch *model = _searchData[indexPath.row];
    
    mainTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    
    [HCMNSNotificationCenter postNotificationName:@"collectionModel" object:nil userInfo:@{@"indexOfTable":model.cateId}];
    
    cell.contentView.backgroundColor = searchViewColor;

    [self.secondCollectionView scrollRectToVisible:CGRectMake(0, 0, self.secondCollectionView.frame.size.width, HCMScreenHeight-108) animated:NO];
    
    [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    mainTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.contentView.backgroundColor = searchBackgroudColor;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (HCMScreenWidth == 414.0 ) {
        return 50;
    }
    return 44;
}

//* cell的分割线向左移动  *//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}



//////////////////////////////   collection View //////////////////////////////////
//////////////////////////////   collection View //////////////////////////////////
//////////////////////////////   collection View //////////////////////////////////
//////////////////////////////   collection View //////////////////////////////////
//////////////////////////////   collection View //////////////////////////////////
//////////////////////////////   collection View //////////////////////////////////
//////////////////////////////   collection View //////////////////////////////////
//////////////////////////////   collection View //////////////////////////////////



//提前注册collection的cell，注册头视图
- (void)setupRightCollectionView{
    UICollectionViewFlowLayout *fLayout = [[UICollectionViewFlowLayout alloc]init];
    fLayout.minimumInteritemSpacing = 10.0f;
    fLayout.minimumLineSpacing = 10.0f;
    
    CGRect frame;
    
    if (HCMScreenWidth == 414.0) {
        frame = CGRectMake(tableViewWidth, 0, HCMScreenWidth - tableViewWidth, HCMScreenHeight-110);
    }else{
        frame = CGRectMake( 100, 0, HCMScreenWidth - 100, HCMScreenHeight-110);
    }
    
    UICollectionView *secondCollectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:fLayout];
    secondCollectionView.showsVerticalScrollIndicator = NO;
    secondCollectionView.backgroundColor = searchViewColor;
    secondCollectionView.delegate = self;
    secondCollectionView.dataSource = self;
    self.secondCollectionView = secondCollectionView;
    [secondCollectionView registerClass:[secondCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    
    UINib *nib = [UINib nibWithNibName:@"secondCollectionReusableView" bundle:nil];
    
    [secondCollectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    
    [secondCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TopHeaderView"];
    
    [self addSubview:secondCollectionView];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.collectionHeaderModel.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.collectionViewModel[section]count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    secondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    secondCollectionViewModel *model = self.collectionViewModel[indexPath.section][indexPath.row];
    cell.goods_name = model.cateName3;
    cell.goods_image = model.cateLogo;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    secondCollectionViewModel *model = self.collectionHeaderModel[indexPath.section];
    
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 0)
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TopHeaderView" forIndexPath:indexPath];
        
        if (!self.Btn) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, headerView.width - 20, HCMScreenWidth * BannerHeight /320)];
            
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.cateBanner]  forState:UIControlStateNormal];
            btn.tag = [model.cateId integerValue];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            self.Btn = btn;
            [headerView addSubview:self.Btn];
        }else{
            self.Btn.tag = [model.cateId integerValue];
            [self.Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.cateBanner]  forState:UIControlStateNormal];
            
        }
        
        if (!self.HeaderLabel) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, HCMScreenWidth * BannerHeight /320,headerView.width, FristLabelHeight)];
            label.backgroundColor = [UIColor whiteColor];
            label.font = sectionHeaderName;
            label.text = [NSString stringWithFormat:@"    %@",model.cateName2];
            self.HeaderLabel = label;
            [headerView addSubview:self.HeaderLabel];
        }else{
             self.HeaderLabel.text = [NSString stringWithFormat:@"    %@",model.cateName2];
        }
        
        reusableview = headerView;
    }else{
    
        secondCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerID forIndexPath:indexPath];
        
        header.sectionName.font = sectionHeaderName;
        header.backgroundColor = [UIColor whiteColor];
        secondCollectionViewModel *model = self.collectionHeaderModel[indexPath.section];
        header.sectionName.text = [NSString stringWithFormat:@"    %@",model.cateName2];
        reusableview = header;

    }

    return reusableview;
}

- (void)clickBtn:(UIButton *)cateid{
    [self clickGoods:[NSString stringWithFormat:@"%lu",(long)cateid.tag]];

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width;
    if (HCMScreenWidth ==414.0) {
        width =(HCMScreenWidth - tableViewWidth - 40)/3;
    }else{
        width =(HCMScreenWidth - 100 - 40)/3;
    }
    
    CGFloat height = width * 80 / 60;
    return CGSizeMake(width,height);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}


//头视图的高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
    
        return CGSizeMake(self.secondCollectionView.width, HCMScreenWidth * BannerHeight /320 + FristLabelHeight);
    }
    CGSize size={self.secondCollectionView.frame.size.width,34};
    return size;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    secondCollectionViewModel *model = self.collectionViewModel[indexPath.section][indexPath.row];
    [self clickGoods:model.cateId3];
}
- (void)clickGoods:(NSString *)cateid{
    [HCMNSNotificationCenter postNotificationName:@"HCMSort_ViewController" object:nil userInfo:@{@"cateId3":cateid}];
}
- (void)reloadView{
   
    [self.secondCollectionView reloadData];
}
- (void)setCollectionHeaderModel:(NSMutableArray *)collectionHeaderModel{
    _collectionHeaderModel = collectionHeaderModel;
   }
- (void)setCollectionViewModel:(NSMutableArray *)collectionViewModel{
    _collectionViewModel = collectionViewModel;
}




- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [HCMNSNotificationCenter postNotificationName:@"searchKeyboard" object:nil];
}
@end
