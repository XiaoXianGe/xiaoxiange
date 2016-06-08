//
//  AddressNerworking.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/31.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "AddressNerworking.h"

@implementation AddressNerworking

/**
 *  用户登录URL
 */
static NSString *const userLoginURL = @"http://www.haocaimao.com/ecmobile/?url=user/signin";
//static NSString *const userLoginURL = @"http://192.168.10.162/ecmobile/?url=user/signin";
/**
 *  微信登录URL
 */
static NSString *const weiXinUserLoginURL = @"http://www.haocaimao.com/ecmobile/index.php?url=user/wechatLogin";
//static NSString *const weiXinUserLoginURL = @"http://192.168.10.162/ecmobile/index.php?url=user/wechatLogin";
/**
 *  用户信息URL
 */
static NSString *const userInfoURL = @"http://www.haocaimao.com/ecmobile/?url=user/info";
/**
 *  修改密码短信URL
 */
static NSString *const inserPasswordURL = @"http://www.haocaimao.com/ecmobile/?url=user/get_password_msm";
/**
 *  找回密码URL
 */
static NSString *const inserNewPasswordURL = @"http://www.haocaimao.com/ecmobile/?url=user/get_password";

/**
 *  用户注册URL
 */
static NSString *const userSignupURL = @"http://www.haocaimao.com/ecmobile/?url=user/signup";

/**
 *  用户收货地址管理URL
 */
static NSString *const addressListURL = @"http://www.haocaimao.com/ecmobile/?url=address/list";

/**
 *  国内省市区名称列表
 */
static NSString *const regionListURL = @"http://www.haocaimao.com/ecmobile/?url=region";

/**
 *  用户增加收货地址URL
 */
static NSString *const addressAddURL = @"http://www.haocaimao.com/ecmobile/?url=address/add";
/**
 *  点击查看已存在地址URL
 */
static NSString *const addressInfoURL = @"http://www.haocaimao.com/ecmobile/?url=address/info";
/**
 *  点击删除收货地址URL
 */
static NSString *const addressDeleteURL = @"http://www.haocaimao.com/ecmobile/?url=address/delete";
/**
 *  点击修改收货地址URL
 */
static NSString *const addressUpDataURL = @"http://www.haocaimao.com/ecmobile/?url=address/update";
/**
 *  点击设置默认收货地址URL
 */
static NSString *const addressSetDefaultURL = @"http://www.haocaimao.com/ecmobile/?url=address/setDefault";

/**
 *  个人收藏URL
 */
static NSString *const collectListURL = @"http://www.haocaimao.com/ecmobile/?url=user/collect/list";

/**
 *  删除个人收藏URL
 */
static NSString *const collectDeleteURL = @"http://www.haocaimao.com/ecmobile/?url=user/collect/delete";

/**
 * 未付款URL
 */
static NSString *const orderListURL = @"http://www.haocaimao.com/ecmobile/?url=order/list";

/**
 * 取消未付款URL
 */
static NSString *const orderCancelURL = @"http://www.haocaimao.com/ecmobile/?url=order/cancel";

/**
 *   支付宝付款URL
 */
static NSString *const orderPaylURL = @"http://www.haocaimao.com/ecmobile/?url=order/pay";

/**
 *   确认收货URL
 */
static NSString *const orderAffirmReceivedlURL = @"http://www.haocaimao.com/ecmobile/?url=order/affirmReceived";

/**
 *   浏览历史
 */
static NSString *const lookHistoryURL = @"http://www.haocaimao.com/ecmobile/index.php?url=user/history";

/**
 *   个人中心余额,优惠券,猫豆的接口
 */
static NSString *const myWallletURL = @"http://www.haocaimao.com/ecmobile/index.php?url=user/account";

/**
 *   修改原密码
 */
static NSString *const changePassWordURL = @"http://www.haocaimao.com/ecmobile/index.php?url=user/password";

/**
 *   缺失商品登记
 */
static NSString *const bookOutGoodsURL = @"http://www.haocaimao.com/ecmobile/?url=user/booking";

/**
 *   红包
 */
static NSString *const hongBaoURL = @"http://www.haocaimao.com/ecmobile/index.php?url=user/bonus";

/**
 *   添加红包
 */
static NSString *const addHongBaoURL = @"http://www.haocaimao.com/ecmobile/index.php?url=user/add_bonus";
/**
 *   金额提现列表
 */
static NSString *const LookTakeMoneyURL = @"http://www.haocaimao.com/ecmobile/index.php?url=user/withdraw_list";

/**
 *   金额提现
 */
static NSString *const TakeMoneyURL = @"http://www.haocaimao.com/ecmobile/index.php?url=user/withdraw_cash";

/**
 *   用户信息2.0
 */
static NSString *const userInfosURL = @"http://www.haocaimao.com/ecmobile/index.php?url=user/profile";
/**
 *   服务与反馈
 */
static NSString *const serviceURL = @"http://www.haocaimao.com/ecmobile/index.php?url=user/service";
/**
 *  关注品牌
 */
static NSString *const attentionURL = @"http://www.haocaimao.com/ecmobile/index.php?url=user/hotBrand";
/**
 *  微信支付（代付款）
 */
static NSString *const awaitpayWechatpayURL = @"http://www.haocaimao.com/ecmobile/index.php?url=order/awaitpay_wechatpay";

/**
 *  版本检测更新
 */
static NSString *const VersionCheckURL = @"http://www.haocaimao.com/ecmobile/index.php?url=common/versionCheck";

/**
 * 订单详情
 */
static NSString *const Order_detailsURL = @"http://www.haocaimao.com/ecmobile/index.php?url=order/details";

/**
 *  物流信息
 */
static NSString *const Order_expressURL = @"http://www.haocaimao.com/ecmobile/index.php?url=order/express";

///************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************/

+(AddressNerworking *)sharedManager{
    static AddressNerworking *sharedNetworkSingleton = nil;
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

#pragma mark -- 用户登录
-(void)postUserLogoin:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    [manager.requestSerializer  setHTTPShouldHandleCookies:NO];
    
    NSString *urlStr = [userLoginURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];

}
#pragma mark -- 微信登录

-(void)postweiXinUserLogoin:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    [manager.requestSerializer  setHTTPShouldHandleCookies:NO];
    
    NSString *urlStr = [weiXinUserLoginURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
    
}

#pragma mark -- 用户信息
-(void)postUserInfo:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [userInfoURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
    
}
#pragma mark -- 找回密码
-(void)postinserNewPassword:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
   
    NSString *urlStr = [inserNewPasswordURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
    
}

#pragma mark -- 用户注册
-(void)postUserSignup:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [userSignupURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
    
}
#pragma mark -- 短信验证
-(void)postUserRegmsm:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
    
}
#pragma mark -- 找回密码短信验证
-(void)postinserPasswordURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [inserPasswordURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
    
}

#pragma mark -- 用户指导
-(void)postUserArticle:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
    
}

#pragma  mark - 请求用户收货地址
- (void)postaddresslist:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [addressListURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
}

#pragma  mark - 国内省市区名称列表
- (void)postRegionList:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [regionListURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
}

#pragma  mark - 国内省市区
-(void)postRegionUrl:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [url stringByRemovingPercentEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
}
#pragma mark - 用户增加收货地址
- (void)postAddressAdd:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [addressAddURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
}
#pragma mark - 点击查看已存在地址
- (void)postAddressInfo:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [addressInfoURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
}
#pragma mark - 删除收货地址
- (void)postAddressDelete:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [addressDeleteURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
}
#pragma mark - 设置默认的收货地址
-(void)postAddressSetDefault:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [addressSetDefaultURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
}
#pragma mark - 修改收货地址
- (void)postAddressUpData:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [addressUpDataURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
}

#pragma mark - 个人收藏
-(void)postCollectList:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [collectListURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
    
}

#pragma  mark - 删除个人收藏
-(void)postCollectDelete:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [collectDeleteURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
    
}


#pragma mark - 未付款
-(void)postOrderList:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [orderListURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        
    }];
}

#pragma mark - 取消未付款订单
-(void)postOrderCancel:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [orderCancelURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
}


#pragma mark - 支付付款订单
-(void)postOrderPay:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [orderPaylURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
}

// 确认收货订单
-(void)postOrderAffirmReceived:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [orderAffirmReceivedlURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
}

// 浏览历史
- (void)lookHistory:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [lookHistoryURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
}

//我的钱包
- (void)postMyWallet:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [myWallletURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
    
}

//修改密码
- (void)postChangePassWord:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [changePassWordURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
    
}

/**
 *  缺失商品登记
 */
- (void)postBookOutGoods:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [bookOutGoodsURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
    
}

/**
 *  红包
 */
- (void)postHongBao:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [hongBaoURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
    
}

/**
 *  添加红包
 */
- (void)postAddHongBao:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [addHongBaoURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
    
}

/**
 *  余额提现申请列表
 */
- (void)postLookTakeMoneyOut:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [LookTakeMoneyURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
    
}

/**
 *  余额提现
 */
- (void)postTakeMoneyOut:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [TakeMoneyURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
    
}
/**
 *  服务与反馈
 */
- (void)postServiceOut:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [serviceURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
    
}

/**
 *  用户信息2.0
 */
- (void)postUserInfoURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [userInfosURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
    
}
/**
 *  关注品牌
 */
- (void)postattentionURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [attentionURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
    
}

/**
 *  微信支付（代付款）
 */
- (void)postAwaitPayWechatPayURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [awaitpayWechatpayURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
    
}
/**
 *  版本检查更新
 */
- (void)postVersionCheckURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [VersionCheckURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
    
    
    
    
}


/**
 *  订单详情
 */
- (void)postOrder_detailsURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [Order_detailsURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
    
    

}


/**
 *  物流信息
 */
- (void)postOrder_expressURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [Order_expressURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:userInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        
        failureBlock(errorStr);
        
    }];
}



@end


