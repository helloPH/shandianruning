 //
//  AppDelegate.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/20.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "AppDelegate.h"
#import "GuiderViewController.h"

#import "GeRenZhongXinViewController.h"
#import "LoginViewController.h"
#import "ShouYeViewController.h"
#import "KuaiCheSuccess.h"

//百度地图
#import <BaiduMapAPI_Base/BMKMapManager.h>

#import <UMSocialCore/UMSocialCore.h>

// 引 JPush功能所需头 件
#import "JPUSHService.h"
// iOS10注册APNs所需头 件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max 
#import <UserNotifications/UserNotifications.h>
#endif


#import "MessageDetailsViewController.h"
#import "QQClassViewContoller.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()<JPUSHRegisterDelegate>
@property (nonatomic,strong) BMKMapManager *baiDuManager;


@property (nonatomic,strong) ShouYeViewController * shouYe;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupNewViewController];
    //配置百度地图
    [self configBaiDuMap];
    //个推推送
    [self setupJPush:launchOptions];
    
    // UMeng  设置
    [self setupUMeng];
    return YES;
}
#pragma mark ------------------------------------------- 推送
-(void)setupJPush:(NSDictionary *)launchOptions {
    // Required
    // notice: 3.0.0及以后版本注册可以这样写，也可以继续 旧的注册 式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加 定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:kJPAppKey channel:@"Publish channel" apsForProduction:YES];
    
    [self registerRemoteNotification];
}
-(void)chongZhiBadge{
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
#pragma mark -- UMeng
-(void)setupUMeng{
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
//    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
}
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxcc45165cdb2717a1" appSecret:@"52f188f405708025917a068d0a95ddf0" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105917063"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        
//        [self alertWithError:error];
    }];
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
#pragma mark -- 注册推送
- (void)registerRemoteNotification {
    //
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
}
#pragma mark -- 注册Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support /// 后台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]
        ]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    if ([userInfo[@"type"] isEqualToString:@"0"]) {// 新订单
        completionHandler(UNNotificationPresentationOptionSound);
        [self receive:userInfo];
    }else{
         completionHandler(UNNotificationPresentationOptionAlert);
    }
 // 需要执 这个 法，选择 是否提醒 户，有Badge、Sound、Alert三种类型可以选择设置
//     [self receive:userInfo];
}
// iOS 10 Support // 前台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
//    completionHandler(); // 系统要求执 这个 法
    [self receive:userInfo];
}
-(void)receive:(NSDictionary *)userInfo{
// Required, iOS 7 Support
//    [JPUSHService handleRemoteNotification:userInfo];
    NSString * type    = [NSString stringWithFormat:@"%@",userInfo[@"type"]];
    NSString * orderId = [NSString stringWithFormat:@"%@",userInfo[@"value"]];
    
    
    NSLog(@"通知：：：%@",userInfo);
    if ([type isEqualToString:@"0"]) {// 抢订单
        if (!_shouYe) {
            _shouYe = [ShouYeViewController new];
        }
         [_shouYe  receiveOrder:orderId];
    }else if ([type isEqualToString:@"1"]){// 消息
        if (_shouYe) {
            MessageDetailsViewController * mess = [MessageDetailsViewController new];
            mess.msgId=orderId;
            [_shouYe.navigationController pushViewController:mess animated:YES];
        }
    }else if ([type isEqualToString:@"2"]){// 课堂
        if (_shouYe) {
            QQClassViewContoller * class = [QQClassViewContoller new];
            class.classId=orderId;
            [_shouYe.navigationController pushViewController:class animated:YES];
        }
    }else if ([type isEqualToString:@"3"]){// 快车 支付成功
       
        if (_shouYe) {
            KuaiCheSuccess * success = [KuaiCheSuccess new];
            success.shouRu=orderId;
            [_shouYe.navigationController pushViewController:success animated:YES];
        }
        [CoreSVP showMessageInCenterWithMessage:[NSString stringWithFormat:@"%@",@"订单支付成功"]];
    }else{
        [CoreSVP showMessageInCenterWithMessage:[NSString stringWithFormat:@"未知类型的通知：\n%@",userInfo]];

    }

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
    UIApplicationState  state = [UIApplication sharedApplication].applicationState;
    if (state==UIApplicationStateBackground) {//后台

          completionHandler(UIBackgroundFetchResultNewData);
        

    };
    if (state==UIApplicationStateActive) {//前台
        [JPUSHService handleRemoteNotification:userInfo];
        [self receive:userInfo];
    };
    
}
#pragma mark ------------------------------------------- 百度地图配置
-(void)configBaiDuMap{
    _baiDuManager = [[BMKMapManager alloc]init];
    BOOL ret = [_baiDuManager start:@"sAeTPR5DErR63tg8Ul75l2n9YRGcPaqV"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"百度地图配置失败");
    }
}
-(void)setupNewViewController{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (![Stockpile sharedStockpile].isLogin) {
        _navi = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    }
    else
    {
        _shouYe = [[ShouYeViewController alloc] init];
        _navi = [[UINavigationController alloc] initWithRootViewController:_shouYe];
    }
    self.window.rootViewController = _navi;
    
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GuideKey"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"GuideKey"] ) {
        GuiderViewController *guideVC = [[GuiderViewController alloc] initWithBlock:^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GuideKey"];
                self.window.rootViewController = _navi;
            });
        }];
        self.window.rootViewController = guideVC;
    }
    else
    {
        self.window.rootViewController = _navi;
    }
    
    [self.window makeKeyAndVisible];
}
#pragma mark ------------------------------------------- 退出
-(void)OutLogin{
    [[Stockpile sharedStockpile] setIsLogin:NO];
    [self turnOffNotification];
    [[UIApplication sharedApplication]unregisterForRemoteNotifications]; //  注销推送
#pragma mark -------------------------------------- 账号信息
    //  用户 资料 和 地理资料
    [[Stockpile sharedStockpile] setDefaultAddressId:@""];
    [[Stockpile sharedStockpile] setUserAccount:@""];
    [[Stockpile sharedStockpile] setUserID:@""];
    [[Stockpile sharedStockpile] setUserRealName:@""];
    [[Stockpile sharedStockpile] setUserLogo:@""];
    [[Stockpile sharedStockpile] setUserPhone:@""];
    
    //银行信息
    [[Stockpile sharedStockpile] setDefaultBankName:@""];
    [[Stockpile sharedStockpile] setDefaultBankCardNum:@""];
    [[Stockpile sharedStockpile] setDefaultBankCardKind:@""];
    
    
    //   账户 情况
    [[Stockpile sharedStockpile] setUserYuE:@""];
    [[Stockpile sharedStockpile] setUserRank:@""];
    [[Stockpile sharedStockpile] setUserJiFen:@""];
    [[Stockpile sharedStockpile] setUserStatus:0];
    [[Stockpile sharedStockpile] setIsWork:false];
    
    
    
    // 订单情况
    // 总的
    [[Stockpile sharedStockpile] setUserAllOrderNum:@""];
    [[Stockpile sharedStockpile] setUserAllTiCheng:@""];
    [[Stockpile sharedStockpile] setUserAllJieDanJinE:@""];
    [[Stockpile sharedStockpile] setUserAllJuLi:@""];
    
    // 今日
    [[Stockpile sharedStockpile] setUserTodayOrderNum:@""];
    [[Stockpile sharedStockpile] setUserTodayShouYi:@""];
    [[Stockpile sharedStockpile] setUserTodayLiCheng:@""];
    [self setupNewViewController];
}
-(void)turnOnNotification{
    //设置推送别名
    NSString *bieMing = [NSString stringWithFormat:@"SD%@",[Stockpile sharedStockpile].userID];
    NSLog(@"设置的别名 %@",bieMing);
    //
//    [self registerRemoteNotification];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    [JPUSHService setTags:nil
                    alias:bieMing
    fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
    }];

}
-(void)turnOffNotification{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [JPUSHService setTags:nil alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"%d",iResCode);
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    //判断是否开始旋转
    NSNotification *notification =[NSNotification notificationWithName:@"judgeStartRotation" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
