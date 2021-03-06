//
//  HomeNetwork.h
//  haocaimao
//
//  Created by 李芷贤 on 15/9/14.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


//请求超时
#define HCMTIMEOUT 15


@interface HomeNetwork : NSObject

typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlock)(NSString *error);



+(HomeNetwork *)sharedManager;
-(AFHTTPRequestOperationManager *)baseHtppRequest;

/**
 *  商品评论
 */
- (void)postGoodsComment:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  首页广告
 */
- (void)postHomeAdvertisement:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  首页分类商品
 */
- (void)postHomeCategoryGoods:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  加入购物车(商品详情里面的)
 */
- (void)postAddToCart:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  立即购买(商品详情里面的)
 */
- (void)postBuyNow:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  收藏商品(商品详情里面的)
 */
- (void)postCollectGoods:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  购物车(商品详情里面的)
 */
- (void)postShoppingCart:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  商品详情(商品详情里面的)
 */
- (void)postGoodsDesc:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  合伙人申请接入
 */
-(void)postPartnerFormURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  合伙人申请接入
 */
-(void)postPartnerApplyURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  合伙人提成数据
 */
-(void)postPartnerIndexURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  合伙人当面扫
 */
-(void)postPartnerQRCodeCreateURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  我要询价-不带图片post
 */
-(void)postinquriePriceURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;



@end
