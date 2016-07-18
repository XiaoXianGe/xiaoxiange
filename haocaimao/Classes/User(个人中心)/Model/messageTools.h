//
//  messageTools.h
//  haocaimao
//
//  Created by 好采猫 on 16/7/14.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messageTools : NSObject

@property (copy, nonatomic)   NSString*toAllTitle;//活动消息标题
@property (copy, nonatomic)  NSString *toManagerTitle;//合伙人标题
@property (copy, nonatomic)  NSString *toCustomIdTitle;//私信标题

@property (assign, nonatomic) BOOL toAllIcon;
@property (assign, nonatomic) BOOL toManagerIcon;
@property (assign, nonatomic) BOOL toCustomIdIocn;

@property (copy, nonatomic)  NSString *toAllContent;
@property (copy, nonatomic) NSString  *toManagerContent;
@property (copy, nonatomic)  NSString *toCustomContent;

@property (copy, nonatomic)  NSString *toAllYearMonthDay;
@property (copy, nonatomic)  NSString *toManagerYearMonthDay;
@property (copy, nonatomic)  NSString *toCustomYearMonthDay;

@property (copy, nonatomic) NSString  *toAllHourMinuteSecond;
@property (copy, nonatomic) NSString  *toManagerHourMinuteSecond;
@property (copy, nonatomic) NSString  *toCustomHourMinuteSecond;



+(id)MessageWithData:(NSDictionary *)dict;

@end
