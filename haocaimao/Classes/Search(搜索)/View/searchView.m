//
//  searchView.m
//  haocaimao
//
//  Created by 好采猫 on 15/12/1.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "searchView.h"
#import "mainTableViewCell.h"
#import "secondCollectionViewCell.h"
#import "HomeCategorySearch.h"

#import "mainTableViewModel.h"
#import "secondCollectionViewModel.h"
#import "secondCollectionReusableView.h"

#define searchViewColor HCMColor(255, 255, 255, 1.0)
#define searchBackgroudColor HCMColor(240, 240, 240, 1.0)

#define BannerHeight 80
#define FristLabelHeight 25
#define sectionHeaderName [UIFont systemFontOfSize:12]

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

//-(void)layoutSubviews{
//    NSInteger selectedIndex = 0;
//    
//    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
//    
//    [self.mainTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//
//}


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
    
    UITableView *mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, HCMScreenHeight-104) style:UITableViewStylePlain];
    mainTableView.showsVerticalScrollIndicator = NO;
    mainTableView.backgroundColor = searchBackgroudColor;
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    
    self.mainTableView = mainTableView;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    mainTableView.separatorColor = [UIColor lightGrayColor];
    [self addSubview:mainTableView];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _searchData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HomeCategorySearch *model = _searchData[indexPath.row];
    
    mainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (!cell) {
    
        cell = [[mainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
       
    }
    
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
    
    return 44;
}

//* cell的分割线向左移动  *//
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



//////////////////////////////   collection View //////////////////////////////////


//提前注册collection的cell，注册头视图
- (void)setupRightCollectionView{
    UICollectionViewFlowLayout *fLayout = [[UICollectionViewFlowLayout alloc]init];
    fLayout.minimumInteritemSpacing = 10.0f;
    fLayout.minimumLineSpacing = 10.0f;
    
    UICollectionView *secondCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake( 100, 0, HCMScreenWidth - 100, HCMScreenHeight-104) collectionViewLayout:fLayout];
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
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, headerView.width - 20, BannerHeight)];
            
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.cateBanner]  forState:UIControlStateNormal];
            btn.tag = [model.cateId integerValue];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            self.Btn = btn;
            [headerView addSubview:self.Btn];
        }else{
            
            [self.Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.cateBanner]  forState:UIControlStateNormal];
        }
        
        if (!self.HeaderLabel) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, BannerHeight,headerView.width, FristLabelHeight)];
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
    
    return CGSizeMake(60, 80);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}


//头视图的高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
    
        return CGSizeMake(self.secondCollectionView.width, BannerHeight + FristLabelHeight);
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
