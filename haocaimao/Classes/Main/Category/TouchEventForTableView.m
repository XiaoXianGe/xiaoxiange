//
//  TouchEventForTableView.m
//  haocaimao
//
//  Created by 好采猫 on 15/11/18.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import "TouchEventForTableView.h"

@implementation TouchEventForTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addToucheEvent:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)addToucheEvent:(UITapGestureRecognizer *)tap
{
    [self endEditing:YES];
}

@end
