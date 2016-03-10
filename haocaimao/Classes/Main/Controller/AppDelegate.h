//
//  AppDelegate.h
//  haocaimao
//
//  Created by 好采猫 on 15/8/12.
//  Copyright (c) 2015年 haocaimao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeTuiSdk.h"

#define kGtAppId           @"CpImJNLL1d9ddNFoYESqn1"
#define kGtAppKey          @"pv1KACPqsr7EH41671Jl91"
#define kGtAppSecret       @"howKgtUETf7kHpbdtqxOp8"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate, GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

