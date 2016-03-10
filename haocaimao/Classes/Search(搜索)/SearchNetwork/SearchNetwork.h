//
//  SearchNetwork.h
//  haocaimao
//
//  Created by 李芷贤 on 15/9/14.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//请求超时
#define TIMEOUT 15



@interface SearchNetwork : NSObject

typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlock)(NSString *error);



+(SearchNetwork *)sharedManager;
-(AFHTTPRequestOperationManager *)baseHtppRequest;

/**
 *  分类搜索
 */
-(void)postCategorySearch:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  子搜索
 */
-(void)postCategorySubSearch:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  点击subSearch打开人气排序
 */
-(void)postSubSearch:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  牌子筛选
 */
-(void)postBrandFiltrate:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  牌子价格筛选
 */
-(void)postBrandPrice:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;





@end
