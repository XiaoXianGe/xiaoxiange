//
//  CartNetwork.h
//  haocaimao
//
//  Created by 好采猫 on 15/9/14.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//请求超时
#define HCMTIMEOUT 15

typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlock)(NSString *error);

@interface CartNetwork : NSObject

+(CartNetwork *)sharedManager;
-(AFHTTPRequestOperationManager *)baseHtppRequest;

/**
 *  购物车列表
 */
- (void)postCartList:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  清空购物车
 */
- (void)postDeleteCartList:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  购物车物品数量增删
 */
- (void)postCartUpData:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  购物车物品移除
 */
- (void)postCartDelete:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  结算页面
 */
- (void)postFlowCheckOrder:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  点击结算
 */
- (void)postflowDone:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  购物车商店移除
 */
-(void)postCartShopDelete:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  猜你喜欢
 */

-(void)postguessLike:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
@end
