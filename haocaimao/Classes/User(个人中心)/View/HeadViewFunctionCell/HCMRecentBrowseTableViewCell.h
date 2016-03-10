//
//  HCMRecentBrowseTableViewCell.h
//  haocaimao
//
//  Created by 李芷贤 on 15/11/12.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCMRecentBrowseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIButton *recommendBtn1;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn2;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn3;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn4;


@end
