//
//  dealMsgModel.h
//  haocaimao
//
//  Created by 好采猫 on 16/7/15.
//  Copyright © 2016年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface dealMsgModel : NSObject

/** 发送的时间 */
@property(nonatomic,strong)NSString * sentTime;
/** 标题 */
@property(nonatomic,strong)NSString * title;
/** 消息ID */
@property(nonatomic,strong)NSString * messageId;
/** 是否已读 1为已读，0为未读*/
@property(nonatomic,strong)NSString * readed;


@end
