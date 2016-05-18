//
//  SearchNetwork.m
//  haocaimao
//
//  Created by 李芷贤 on 15/9/14.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "SearchNetwork.h"

@implementation SearchNetwork




/**
 * 搜索主页URL
 */
static NSString *const CategorySearchURL = @"http://www.haocaimao.com/ecmobile/?url=home/classificationTop";
/**
 *  搜索子类URL
 */
static NSString *const CategorySubURL = @"http://www.haocaimao.com/ecmobile/?url=home/classificationInfo";

/**
 * 点击subSearch打开人气排序URL
 */
static NSString *const SubSearchURL = @"http://www.haocaimao.com/ecmobile/?url=search";


//static NSString *const SubSearchURL = @"http://192.168.10.162/ecmobile/?url=search";
/**
 * 牌子筛选URL
 */
static NSString *const BrandFiltrateURL = @"http://www.haocaimao.com/ecmobile/?url=brand";

/**
 * 牌子价格URL
 */
static NSString *const BrandPriceURL = @"http://www.haocaimao.com/ecmobile/?url=price_range";




+(SearchNetwork *)sharedManager{
    static SearchNetwork *sharedNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkSingleton = [[self alloc] init];
    });
    return sharedNetworkSingleton;
}

-(AFHTTPRequestOperationManager *)baseHtppRequest{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    return manager;
    
    
}



#pragma mark - 分类搜索
-(void)postCategorySearch:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [CategorySearchURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
}


#pragma mark - 点击subSearch打开人气排序
-(void)postSubSearch:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [SubSearchURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
}


#pragma mark - 牌子筛选
-(void)postBrandFiltrate:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [BrandFiltrateURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
}


#pragma mark - 牌子价格筛选
-(void)postBrandPrice:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [BrandPriceURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];

}
#pragma mark - 子搜索
- (void)postCategorySubSearch:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [CategorySubURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];

}



@end
