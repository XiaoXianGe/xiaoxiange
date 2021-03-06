//
//  HomeNetwork.m
//  haocaimao
//
//  Created by 李芷贤 on 15/9/14.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "HomeNetwork.h"

@implementation HomeNetwork

/**
 *  商品评论URL
 */
static NSString *const goodsCommentURL = @"http://www.haocaimao.com/ecmobile/?url=comments";
/**
 *  首页广告URL
 */
static NSString *const HomeAdvertisementURL = @"http://www.haocaimao.com/ecmobile/?url=home/data";
/**
 *  首页分类商品URL
 */
static NSString *const HomeCategoryURL = @"http://www.haocaimao.com/ecmobile/?url=home/category";

/**
 *  加入购物车URL
 */
static NSString *const shoppingCartURL = @"http://www.haocaimao.com/ecmobile/?url=cart/list";
/**
 *  立即购买URL
 */
static NSString *const buyNowURL = @"http://www.haocaimao.com/ecmobile/?url=cart/create";

/**
 * 创建收藏商品URL
 */
static NSString *const CreateCollectURL = @"http://www.haocaimao.com/ecmobile/?url=user/collect/create";

/**
 * 商品详情里面的商品详情按钮URL
 */
static NSString *const goodsDescURL = @"http://www.haocaimao.com/ecmobile/?url=goods/desc";

/**
 * 合伙人申请接入URL
 */
static NSString *const PartnerFormURL = @"http://www.haocaimao.com/ecmobile/?url=user/salesPartnerForm";

/**
 * 合伙人信息接入URL
 */
static NSString *const PartnerApplyURL = @"http://www.haocaimao.com/ecmobile/?url=user/salesPartnerApply";

/**
 * 合伙人信息接入URL
 */
static NSString *const PartnerIndexURL = @"http://www.haocaimao.com/ecmobile/?url=user/salesPartnerIndex";
/**
 * 合伙人信息接入URL
 */
static NSString *const PartnerQRCodeCreateURL = @"http://www.haocaimao.com/ecmobile/?url=common/QRCodeCreate";

/**
 * 我要询价-不带图片post
 */
static NSString *const inquirePriceURL = @"http://www.haocaimao.com/ecmobile/?url=user/inquirePrice";




+(HomeNetwork *)sharedManager{
    static HomeNetwork *sharedNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkSingleton = [[self alloc] init];
    });
    return sharedNetworkSingleton;
}

-(AFHTTPRequestOperationManager *)baseHtppRequest{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:HCMTIMEOUT];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    
    return manager;
}




#pragma mark - 商品评论
- (void)postGoodsComment:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [goodsCommentURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];

}

#pragma mark - 首页广告
- (void)postHomeAdvertisement:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [HomeAdvertisementURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
        
    }];

    
    
}
#pragma mark - 首页分类商品
- (void)postHomeCategoryGoods:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [HomeCategoryURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
}


#pragma mark - 加入购物车
- (void)postAddToCart:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [shoppingCartURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
}

#pragma mark - 立即购买
- (void)postBuyNow:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [buyNowURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
}

#pragma mark - 收藏商品
- (void)postCollectGoods:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [CreateCollectURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
}


#pragma mark - 前往购物车
- (void)postShoppingCart:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [shoppingCartURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
    
}

#pragma mark - 商品详情
-(void)postGoodsDesc:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [goodsDescURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
}



#pragma mark - 合伙人接入

-(void)postPartnerFormURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [PartnerFormURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
}
/**
 *  合伙人申请接入
 */
-(void)postPartnerApplyURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [PartnerApplyURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
    
}
/**
 *  合伙人提成数据
 */
-(void)postPartnerIndexURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [PartnerIndexURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
    
}

/**
 *  合伙人当面扫
 */
-(void)postPartnerQRCodeCreateURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [PartnerQRCodeCreateURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
    
}

/**
 *  我要询价-不带图片post
 */
-(void)postinquriePriceURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [inquirePriceURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
}




@end
