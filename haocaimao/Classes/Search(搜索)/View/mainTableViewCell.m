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

//- (void)awakeFromNib {
// 
//   
//}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//    }
//    return self;
//}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
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
    if (HCMScreenWidth == 414.0) {
        label.font = [UIFont systemFontOfSize:11];

    }else{
        label.font = [UIFont systemFontOfSize:9];

    }
    label.numberOfLines = 0;

}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    self.textLabel.textColor = selected ? HCMColor(180, 20, 30, 1.0) : HCMColor(88 , 88, 88, 1.0);

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    if (HCMScreenWidth == 414.0) {
        self.imageView.frame = CGRectMake(2, 9, 33, 33);
         self.textLabel.frame = CGRectMake(44, 10, 67, 30);
    }else{
         self.textLabel.frame = CGRectMake(44, 10, 54, 24);
        self.imageView.frame = CGRectMake(2, 7, 30, 30);
    }
    
   
    
    
}
@end
