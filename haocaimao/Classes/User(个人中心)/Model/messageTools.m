//
//  messageTools.m
//  haocaimao
//
//  Created by 好采猫 on 16/7/14.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import "messageTools.h"


@implementation messageTools

+(id)MessageWithData:(NSDictionary *)dict
{
    return [[self alloc]initWithMessageData:dict];

}

-(id)initWithMessageData:(NSDictionary *)dict
{
    
    NSDictionary *dictt = [NSDictionary dictionary];
    dictt = dict[@"data"][@"messCateIndex"];
//    HCMLog(@"dictt%@",dictt);
    
    self.toAllTitle = @"活动消息";
    if ([dictt[@"toAll"] isKindOfClass:[NSDictionary class]]) {
        _toAllContent = dictt[@"toAll"][@"title"];
        _toAllIcon = ![dictt[@"toAll"][@"unReadTotal"] integerValue];
        _toAllYearMonthDay = [dictt[@"sentTime"] substringToIndex:10];
        _toAllHourMinuteSecond = [dictt[@"sentTime"] substringFromIndex:12];
    }else{
        _toAllContent = dictt[@"toAll"];
        _toAllIcon = 1;

    }
    
    self.toManagerTitle = @"合伙人消息";
    if ([dictt[@"toManager"] isKindOfClass:[NSDictionary class]]) {
        self.toManagerContent = dictt[@"toManager"][@"title"];
        _toManagerIcon = ![dictt[@"toManager"][@"unReadTotal"] integerValue];
        _toManagerYearMonthDay = [dictt[@"toManager"][@"sentTime"] substringToIndex:10];
        _toManagerHourMinuteSecond = [dictt[@"toManager"][@"sentTime"] substringFromIndex:11];
    }else{
        _toManagerContent = dictt[@"toManager"];
        _toManagerIcon = 1;
    }
    
    self.toCustomIdTitle = @"私信消息";
    if ([dictt[@"toCustomId"] isKindOfClass:[NSDictionary class]]) {
        self.toCustomContent = dictt[@"toCustomId"][@"title"];
        _toCustomIdIocn =![dictt[@"toCustomId"][@"unReadTotal"] integerValue];
        _toCustomYearMonthDay = [dictt[@"toCustomId"][@"sentTime"] substringToIndex:10];
        _toCustomHourMinuteSecond = [dictt[@"toCustomId"][@"sentTime"] substringFromIndex:11];
    }else{
        _toCustomContent = dictt[@"toCustomId"];
        _toCustomIdIocn = 1;
    }

    return self;
}

@end
