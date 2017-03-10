//
//  AppDelegate.h
//  QQRunning
//
//  Created by 软盟 on 2016/12/20.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import <UIKit/UIKit.h>
//个推推送
#import "GeTuiSdk.h"     // GetuiSdk头文件应用

// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

/// 个推开发者网站中申请App时，注册的AppId、AppKey、AppSecret
//#define kJPAppId           @"iMahVVxurw6BNr7XSn9EF2"
#define kJPAppKey          @"14a5cd16e8b255259fee7bd8"
//#define kJPAppSecret       @"G0aBqAD6t79JfzTB6Z5lo5"
@interface AppDelegate : UIResponder <UIApplicationDelegate,GeTuiSdkDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) UINavigationController *navi;
/** 注册 APNs */
-(void)registerRemoteNotification;
-(void)OutLogin;
-(void)turnOnNotification;
-(void)turnOffNotification;
-(void)chongZhiBadge;
@end

