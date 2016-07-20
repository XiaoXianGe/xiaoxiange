//
//  HCMDealMsgTableViewCell.h
//  haocaimao
//
//  Created by 好采猫 on 16/7/15.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface HCMDealMsgTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *sentTime;
@property (weak, nonatomic) IBOutlet UILabel *title;
/** messageId */
@property(nonatomic,strong)NSString * messageId;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;


@end
