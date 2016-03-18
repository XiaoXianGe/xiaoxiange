//
//  AddressNerworking.h
//  haocaimao
//
//  Created by 好采猫 on 15/8/31.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//请求超时
#define TIMEOUT 10

typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlock)(NSString *error);

@interface AddressNerworking : NSObject

+(AddressNerworking *)sharedManager;
-(AFHTTPRequestOperationManager *)baseHtppRequest;

/**
 *  用户登录
 */
- (void)postUserLogoin:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
-(void)postweiXinUserLogoin:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  找回密码的短信
 */
-(void)postinserPasswordURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  找回密码
 */
-(void)postinserNewPassword:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  用户信息
 */
- (void)postUserInfo:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  短信验证 postUserRegmsm
*/
- (void)postUserRegmsm:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  用户注册
 */
- (void)postUserSignup:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  用户指导
 */
- (void)postUserArticle:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  收货地址列表
 */
- (void)postaddresslist:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  国内省市区名称列表
 */
- (void)postRegionList:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  省市区
 */
-(void)postRegionUrl:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  增加收货地址
 */
- (void)postAddressAdd:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  收货地址资料
 */
- (void)postAddressInfo:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  删除收货地址
 */
- (void)postAddressDelete:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  设置默认的收货地址
 */
- (void)postAddressSetDefault:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  编辑新的收货地址
 */
- (void)postAddressUpData:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  个人收藏
 */
- (void)postCollectList:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  删除个人收藏
 */
- (void)postCollectDelete:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  未付款详情订单
 */
- (void)postOrderList:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  取消未付款订单
 */
- (void)postOrderCancel:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  支付付款订单
 */
- (void)postOrderPay:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  确认收货订单
 */
- (void)postOrderAffirmReceived:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  浏览历史
 */
- (void)lookHistory:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  我的账户
 */
- (void)postMyWallet:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  修改密码
 */
- (void)postChangePassWord:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  缺失商品登记
 */
- (void)postBookOutGoods:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  红包
 */
- (void)postHongBao:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  添加红包
 */
- (void)postAddHongBao:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  余额提现申请列表
 */
- (void)postLookTakeMoneyOut:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  余额提现
 */
- (void)postTakeMoneyOut:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  用户信息2.0
 */
- (void)postUserInfoURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  服务与反馈
 */
- (void)postServiceOut:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
/**
 *  关注品牌
 */
- (void)postattentionURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  微信支付（代付款）
 */
- (void)postAwaitPayWechatPayURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  版本检查更新
 */
- (void)postVersionCheckURL:(NSDictionary *)userInfo successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;







@end









