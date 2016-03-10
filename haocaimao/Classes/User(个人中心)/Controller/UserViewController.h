//
//  UserViewController.h
//  haocaimao
//
//  Created by 好采猫 on 15/8/17.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController

@property (nonatomic, strong)NSString *userName;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end
