//
//  AppDelegate.m
//  haocaimao
//
//  Created by 好采猫 on 15/8/12.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import "AppDelegate.h"
#import "HCMTabBarViewController.h"
#import "SDWebImageManager.h"
#import "HWNewfeatureViewController.h"

#import "UMSocial.h"
#import "HCMAdVC.h"
#import "weiXinData.h"
#import "UMSocialWechatHandler.h"

#import "WXApiManager.h"
#import "DealViewController.h"
#import "HCMSubCollectionViewController.h"


@interface AppDelegate ()<WXApiDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) HCMTabBarViewController *tab;

@property( strong ,nonatomic )NSDictionary *dict;

@property (copy,nonatomic)NSString *push;

@property(copy,nonatomic)NSString * markPush;

@end

@implementation AppDelegate

- (HCMTabBarViewController *)tab{
    if (!_tab) {
        _tab = [[HCMTabBarViewController alloc] init];
    }
    return _tab;
}

-(NSDictionary *)dict{
    if (!_dict) {
        _dict = [NSDictionary dictionary];
    }
    return _dict;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //3D-touch
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0){
        [self setUp3Dtouch];
    }
    
    //微信分享 onReq微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用
    [WXApi registerApp:APP_ID];
    [UMSocialData setAppKey:@"5636fa51e0f55af8bf004172"];
    
    //微信支付 向微信注册wxd930ea5d5a258f4f
    //[WXApi registerApp:@"wx2a1388283f78955d" withDescription:@"好采猫采购平台"];
    
    // 根据--新版本--设置根控制器
    [self setUpRootViewController];
    
    //注册推送通知
    [self registerNotification];
    
    // 处理远程通知启动APP
    [self receiveNotificationByLaunchingOptions:launchOptions];

    _markPush = @"0";
    
    return YES;

}

-(NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

-(void)setUpRootViewController
{
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];

    NSString *key = @"CFBundleShortVersionString";
    
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if ([currentVersion isEqualToString:lastVersion]) {
        
        // 版本号相同：这次打开和上次打开的是同一个版本
        self.window.rootViewController = self.tab;
        
    } else {
        // 这次打开的版本和上一次不一样，显示新特性
        self.window.rootViewController = [[HWNewfeatureViewController alloc] init];
        
        // 将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.window makeKeyAndVisible];
    
}

//3D-touch
-(void)setUp3Dtouch
{
    
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    
    UIApplicationShortcutItem *shortCutItem = [[UIApplicationShortcutItem alloc]initWithType:@"" localizedTitle:@"搜搜看看" localizedSubtitle:@"每天一看" icon:icon userInfo:nil];
    
    NSArray *shortItems = @[shortCutItem];
    
    [[UIApplication sharedApplication]setShortcutItems:shortItems];
}


- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    self.tab.selectedIndex = 1;
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url] ||
            [WXApi handleOpenURL:url delegate:[weiXinData alloc]] ;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url] ||
            [WXApi handleOpenURL:url delegate:[weiXinData alloc]];
}


-(void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber -= 1;
}

-(void)applicationWillEnterForeground:(UIApplication *)application
{
    HCMLog(@"进入前台");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //通知删除《分类搜索》的键盘退出按钮
    [HCMNSNotificationCenter postNotificationName:@"deleteBtn" object:nil];
    HCMLog(@"进入后台");
    
}

-(void)dealloc
{
    [HCMNSNotificationCenter removeObserver:self];
}

/*********************************
 *********************************
 *********************************
 ******** 个推推送（开发中）*********
 *********************************
 *********************************
 *********************************
 *********************************/

-(void)registerNotification
{
    
    // 通过 appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    
    // 注册APNS
    [self registerUserNotification];
    
}


#pragma mark - 用户通知(推送) _自定义方法
/** 注册通知用户 */
- (void)registerUserNotification
{

    // 判读系统版本是否是“iOS 8.0”以上
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
//    } else { // iOS8.0 以前远程推送设置方式
//        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        
//        // 注册远程通知 -根据远程通知类型
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//    }
}


/** 自定义：APP被“推送”启动时处理推送消息处理（APP 未启动-->启动）*/
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions
{
    if (!launchOptions)return;
    
    /*
     通过“远程推送”启动APP
     UIApplicationLaunchOptionsRemoteNotificationKey 远程推送Key
     */
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"\nAPP被“推送”启动时处理推送消息处理（APP 未启动-->启动>>>[Launching RemoteNotification]:%@", userInfo);

    }
}



#pragma mark - 系统为_IOS 7.0 _时使用
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    /// Background Fetch 恢复 SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用
/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

#pragma mark - 远程通知(推送)回调
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken:%@",deviceToken.description);
    
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [GeTuiSdk registerDeviceToken:myToken];
    
    NSLog(@"\n程通知注册成功:%@\n\n", myToken);
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
    [GeTuiSdk registerDeviceToken:@""];
    
    NSLog(@"\n远程通知注册失败:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber -= 1;
    NSLog(@"\n(App运行在后台/App运行在前台)>>:%@\n\n", userInfo);

}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    // 处理APN
    NSLog(@"---透传推送消息---:%@\n\n", userInfo);
        
    application.applicationIconBadgeNumber -= 1;

    completionHandler(UIBackgroundFetchResultNewData);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pushMessageToController];
    });
    _markPush = @"1";
    

}

#pragma mark - GeTuiSdkDelegate
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@"返回的 cid = %@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"错误回调:%@\n\n", [error localizedDescription]);
}


/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId andOffLine:(BOOL)offLine fromApplication:(NSString *)appId
{
    
    // [4]: 收到个推消息
    NSData *payload = [GeTuiSdk retrivePayloadById:payloadId];
    
    if (payload) {
        //接收到的《描述内容》
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:payload options:NSJSONReadingMutableContainers error:nil];
        _dict = dic;

        if ([_markPush isEqualToString:@"1"]){
            _markPush = @"0";
            return;
        }

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:_dict[@"title"] message:_dict[@"content"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立刻查看", nil];
        [alert show];
    }

    /**
//    NSString *payloadMsg = nil;
//    if (payload) {
//        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes length:payload.length encoding:NSUTF8StringEncoding];
//    }
//    
//    NSString *msg = [NSString stringWithFormat:@" 1111payloadId=%@,2222taskId=%@,3333messageId:%@,4444payloadMsg:%@%@", payloadId, taskId, aMsgId, payloadMsg, offLine ? @"<离线消息>" : @""];
//    NSLog(@"透传消息回调:%@\n\n", msg);
//
//

     *汇报个推自定义事件
     *actionId：用户自定义的actionid，int类型，取值90001-90999。
     *taskId：下发任务的任务ID。
     *msgId： 下发任务的消息ID。
     *返回值：BOOL，YES表示该命令已经提交，NO表示该命令未提交成功。注：该结果不代表服务器收到该条命令
     **/
    [GeTuiSdk sendFeedbackMessage:90001 taskId:taskId msgId:aMsgId];
    
}

- (void)clickBack
{
    // 获取导航控制器
    UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
    UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
    
    [pushClassStance popViewControllerAnimated:YES];
}
/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result
{
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"sendMessage消息回调:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus
{
    // [EXT]:通知SDK运行状态
    NSLog(@"运行状态通知:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error
{
    if (error) {
        NSLog(@"\nError---:%@\n\n", [error localizedDescription]);
        return;
    }
    NSLog(@"设置推送模式:%@\n\n", isModeOff ? @"开启" : @"关闭");
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
     if ([title isEqualToString:@"立刻查看"])
     {
         [self pushMessageToController];
     }
}

//获取到推送后，跳转到对应的控制器
-(void)pushMessageToController{
    // 获取导航控制器
    UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
    UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
    NSString *contenttype = _dict[@"contenttype"];
    if ([contenttype isEqualToString:@"1"]) {
        
        //这里收的是    *消息内容
        DealViewController *pushVC = [[DealViewController alloc]initWithNibName:@"DealViewController" bundle:nil];
        pushVC.goods_id = _dict[@"actionId"];
        // 跳转到对应的控制器
        [pushClassStance pushViewController:pushVC animated:YES];
        
    }else if ([contenttype isEqualToString:@"2"]){

        HCMSubCollectionViewController *subCOllVC = [[HCMSubCollectionViewController alloc]initWithNibName:@"HCMSubCollectionViewController" bundle:nil];
        subCOllVC.urlStr = _dict[@"actionId"];
        // 跳转到对应的控制器
        [pushClassStance pushViewController:subCOllVC animated:YES];
        
    }else if ([contenttype isEqualToString:@"3"]){
        
        [SVProgressHUD showWithStatus:@"加载中"];
        tabVC.tabBar.hidden = YES;
        pushClassStance.navigationBarHidden = NO;
        
        UIViewController *vc = [[UIViewController alloc]init];
        
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0, HCMScreenWidth,HCMScreenHeight)];
        
        //    NSString *url = @"http://www.haocaimao.com/culture.html";
        
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_dict[@"actionId"]]]];
        
        vc.title = @"企业简介";
        vc.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clickBack) image:@"nav-back" highImage:@"nav-back"];
        
        [vc.view addSubview:webView];
        
        [pushClassStance pushViewController:vc animated:YES];
        
        [SVProgressHUD dismiss];
    }

}

@end
