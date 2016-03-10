//
//  HCMEnshrineCell.h
//  haocaimao
//
//  Created by 好采猫 on 15/9/1.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEnshrine.h"

@class HCMEnshrineCell;



@protocol HCMEnshrineCellDelegete <NSObject>

- (void)clickDeleteCell:(HCMEnshrineCell *)enshrineCell;

@end



@interface HCMEnshrineCell : UICollectionViewCell

@property (weak, nonatomic)id<HCMEnshrineCellDelegete> delegate;

@property (strong, nonatomic) UserEnshrine *enshrine;

@property (weak, nonatomic) IBOutlet UIButton *cilckDlete;

@property (assign, nonatomic)NSIndexPath *index_path;

@property (strong, nonatomic)NSString *rem_ID;

@end
