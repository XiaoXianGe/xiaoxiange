//
//  searchView.h
//  haocaimao
//
//  Created by 好采猫 on 15/12/1.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class mainTableViewModel;
@interface searchView : UIView


/** collection数据 */
@property (strong, nonatomic) NSMutableArray *collectionViewModel;

/** collection头部数据 */
@property (strong, nonatomic) NSMutableArray *collectionHeaderModel;

- (instancetype)initWithFrame:(CGRect)frame WithDataModel:(NSMutableArray *)data WithTableViewModel:(NSMutableArray *)tableViewModel ;

- (void)reloadView;



@end
