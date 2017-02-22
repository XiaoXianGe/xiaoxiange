//
//  HCMUserLocationTableViewControllerTableViewCell.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/29.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HCMUserLocationTableViewControllerTableViewCell.h"

@interface HCMUserLocationTableViewControllerTableViewCell ()



@end

@implementation HCMUserLocationTableViewControllerTableViewCell





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)changeAddaress:(UIButton *)btn {
    
    self.popVC(btn.tag);
    
    
    
}
- (IBAction)deleteAddress:(UIButton *)btn {
    
    self.deleAddress(btn.tag);
    
    
}



@end
