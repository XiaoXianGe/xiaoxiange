//
//  mainTableViewCell.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/26.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "mainTableViewCell.h"
#import "HomeCategorySearch.h"
@interface mainTableViewCell()



@end
@implementation mainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}
- (void)showImage:(NSString *)image textTitle:(NSString *)title{
    
    UILabel *label =  self.textLabel;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage: [UIImage imageNamed:@"head_ portrait"]];

    CALayer *imageViewLayer = self.imageView.layer;
    [imageViewLayer setMasksToBounds:YES];
    [imageViewLayer setCornerRadius:6.0];
    label.text = title;
    label.font = [UIFont systemFontOfSize:9];
    label.numberOfLines = 0;
 
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(2, 7, 30, 30);
    self.textLabel.frame = CGRectMake(44, 10, 56, 24);
    
}
@end
