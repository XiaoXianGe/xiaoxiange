//
//  HWSearchBar.m
//  傻逼黑马微博2期
//
//  Created by apple on.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "HWSearchBar.h"
@interface HWSearchBar()<UITextFieldDelegate>

@end

@implementation HWSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"请输入搜索条件";
        self.background = [UIImage imageNamed:@"cell-bg-single"];
        
        // 通过init来创建初始化绝大部分控件，控件都是没有尺寸
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"searcher-new-search-icon"];
        searchIcon.frame = CGRectMake(0, 0, 30, 30);
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.returnKeyType = UIReturnKeySearch;
        
    }
    return self;
}

+ (instancetype)searchBar
{
    return [[self alloc] init];
}


@end
