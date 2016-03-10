//
//  HCMDealNumberCell.m
//  ScrollPageDown_Demo
//
//  Created by 李芷贤 on 16/3/2.
//  Copyright © 2016年 LJH. All rights reserved.
//

#import "HCMDealNumberCell.h"
#import "MJExtension.h"

@interface HCMDealNumberCell()

/** 商品数量 */
@property (weak, nonatomic) IBOutlet UILabel *numberText;

@property(nonatomic)CGFloat changeHeight;

@end


@implementation HCMDealNumberCell



- (void)awakeFromNib {
    


}

/** 加按钮 */
- (IBAction)add {
    
    NSInteger add = [self.numberText.text integerValue] + 1;
    self.numberText.text = [NSString stringWithFormat:@"%ld",(long)add];
}

/** 减按钮 */
- (IBAction)sub {
    
    NSInteger add = [self.numberText.text integerValue];
    if (add > 1) add -= 1;
    self.numberText.text = [NSString stringWithFormat:@"%ld",(long)add];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        
    }
    return self;
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat newH = 10;
    self.changeHeight = 0;
    
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 0;//用来控制button距离父视图的高
    
    HCMLog(@"%lu",(unsigned long)[(NSArray *)self.dealModel.specification count]);
    
    for (NSDictionary *dict in (NSArray *)self.dealModel.specification) {
        
        if (self.changeHeight) {
            self.changeHeight += 28;
            h = self.changeHeight;
        }
        UILabel * label = [[UILabel alloc]init];
        label.text = dict[@"name"];
        label.frame = CGRectMake(10,  newH + self.changeHeight, HCMScreenWidth, 15);
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1.0];
        [self.contentView addSubview:label];
        
        
        for (NSDictionary *dict1 in dict[@"value"]) {
                
            //根据计算文字的大小
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
            CGFloat length = [dict1[@"label"] boundingRectWithSize:CGSizeMake(HCMScreenWidth - 20, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0]];
            button.tag = [dict1[@"id"] integerValue];
            [button setTitle:dict1[@"label"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:11];
            [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(10 + w, h + newH + 20  , length+8, 20);
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:10.0];
            
            if(10 + w + length + 15 > HCMScreenWidth){//当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
                w = 0; //换行时将w置为0
                h = h + button.frame.size.height + 8;
                button.frame = CGRectMake(10 + w, h + newH +20 , length+8, 20);//重设button的frame
            }
            
             w = button.frame.size.width + button.frame.origin.x;
            self.changeHeight = h + newH + 15 ;
            [self.contentView addSubview:button];
        }
        w = 0;

    }
    
}

-(void)touchButton:(UIButton *)Button{
    NSLog(@"..%lu",Button.tag);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
