//
//  RegionNetworking.h
//  adderleDemo
//
//  Created by 好采猫 on 15/10/13.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//请求超时
#define TIMEOUT 15

@interface RegionNetworking : NSObject

typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlock)(NSString *error);

+(RegionNetworking *)sharedManager;
-(AFHTTPRequestOperationManager *)baseHtppRequest;

/**
 *  省市区
 */
-(void)getRegionUrl:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

@end
