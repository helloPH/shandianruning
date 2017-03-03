//
//  Stockpile.m
//  CenterFo
//
//  Created by apple on 14-7-11.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "Stockpile.h"
//用户信息
#define kuserAccount               @"kuserAccountKey"
#define kuserPassword              @"kuserPassword"
#define kuserIDKey                 @"kuserIDKey"
#define kuserLogoKey               @"kuserLogoKey"
#define kuserNickNameKey           @"kuserNickNameKey"
#define kuserRealNameKey           @"kuserRealNameKey"
#define kuserSexKey                @"kuserSexKey"
#define kuserPhoneKey              @"kuserPhoneKey"
#define kuserEmailKey              @"kuserEmailKey"

// 账户信息
#pragma mark -------------------------------------- 账号信息
/** 用户积分*/
#define kuserJiFenKey               @"kuserJiFenKey"
/** 用户余额*/
#define kuserRankKey               @"kuserRankKey"
/** 是否认证*/
#define kuserStatus                 @"kuserStatus"
/** 用户是否开工*/
#define kisWorkKey               @"kisWorkKey"
/** 用户等级*/
#define kuserRankKey               @"kuserRankKey"

#define kuserIsRead            @"kuserIsRead"

/** 用户总接单量*/
#define kuserAllOrderNumKey               @"kuserAllOrderNumKey"
/** 用户总提成*/
#define kuserAllTiChengKey               @"kuserAllTiChengKey"
/** 用户总接单金额*/
#define kuserAllJieDanJinEKey               @"kuserAllJieDanJinEKey"
/** 用户总里程*/
#define kuserAllJuLiKey               @"kuserAllJuLiKey"


/** 用户今日订单*/
#define kuserTodayOrderNumKey               @"kuserTodayOrderNumKey"
/** 用户今日收益*/
#define kuserTodayShouYiKey               @"kuserTodayShouYiKey"
/** 用户今日里程*/
#define kuserTodayLiChengKey               @"kuserTodayLiChengKey"





//位置信息
#define kdefaultAddressIdKey       @"kdefaultAddressIdKey"
#define kprovinceKey               @"kprovinceKey"
#define kcityKey                   @"kcityKey"
#define kareaKey                   @"kareaKey"
#define kRode                      @"kRode"
#define kplaceKey                  @"kplaceKey"
#define klatitudeKey               @"klatitudeKey"
#define klongitudeKey              @"klongitudeKey"
//登录状态
#define kisLoginKey                @"kisLoginKey"
//秋秋跑腿
#define kdefaultBankName           @"kdefaultBankName"
#define kdefaultBankCardNum        @"kdefaultBankCardNum"
#define kdefaultBankCardKind       @"kdefaultBankCardKind"
// .m
// \ 代表下一行也属于宏
// ## 是分隔符
#define single_implementation(class) \
static class *_instance; \
\
+ (class *)shared##class \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}

@implementation Stockpile

single_implementation(Stockpile);

#pragma mark -私有方法

- (NSString *)loadStringFromDefaultsWithKey:(NSString *)key
{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return (str && str.length>0) ? str : @"";
}
- (NSData *)loadDataFromDefaultsWithKey:(NSString *)key{
    return  [[NSUserDefaults standardUserDefaults] dataForKey:key];
}
#pragma mark 写入系统偏好
- (void)saveToNSDefaultsWithKey1:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:self forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark -------------------------------------- 用户信息
//用户账号
-(void)setUserAccount:(NSString *)userAccount{
    [userAccount saveToNSDefaultsWithKey:kuserAccount];
}
-(NSString *)userAccount{
    return [self loadStringFromDefaultsWithKey:kuserAccount];
}
//用户密码
-(void)setUserPassword:(NSString *)userPassword{
    [userPassword saveToNSDefaultsWithKey:kuserPassword];
}
-(NSString *)userPassword{
    return [self loadStringFromDefaultsWithKey:kuserPassword];
}

//用户ID
-(void)setUserID:(NSString *)userID{
    [userID saveToNSDefaultsWithKey:kuserIDKey];
}
-(NSString *)userID{
    return [self loadStringFromDefaultsWithKey:kuserIDKey];
}
//用户头像
-(void)setUserLogo:(NSString *)userLogo{
    [userLogo saveToNSDefaultsWithKey:kuserLogoKey];
}
-(NSString *)userLogo{
    return [self loadStringFromDefaultsWithKey:kuserLogoKey];
}
//用户昵称
-(void)setUserNickName:(NSString *)userNickName{
    [userNickName saveToNSDefaultsWithKey:kuserNickNameKey];
}
-(NSString *)userNickName{
    return [self loadStringFromDefaultsWithKey:kuserNickNameKey];
}
//用户真实姓名
-(void)setUserRealName:(NSString *)userRealName{
    [userRealName saveToNSDefaultsWithKey:kuserRealNameKey];
}
-(NSString *)userRealName{
    return [self loadStringFromDefaultsWithKey:kuserRealNameKey];
}
//用户性别
-(void)setUserSex:(NSString *)userSex{
    [userSex saveToNSDefaultsWithKey:kuserSexKey];
}
-(NSString *)userSex{
    return [self loadStringFromDefaultsWithKey:kuserSexKey];
}
//用户电话
-(void)setUserPhone:(NSString *)userPhone{
    [userPhone saveToNSDefaultsWithKey:kuserPhoneKey];
}
-(NSString *)userPhone{
    return [self loadStringFromDefaultsWithKey:kuserPhoneKey];
}
//用户邮箱
-(void)setUserEmail:(NSString *)userEmail{
    [userEmail saveToNSDefaultsWithKey:kuserEmailKey];
}
-(NSString *)userEmail{
    return [self loadStringFromDefaultsWithKey:kuserEmailKey];
}

// 账户信息
#pragma mark -------------------------------------- 账号信息
/** 用户等级*/
-(void)setUserRank:(NSString *)userRank{
    [userRank saveToNSDefaultsWithKey:kuserRankKey];
}
-(NSString *)userRank{
    return [self loadStringFromDefaultsWithKey:kuserRankKey];
}
//用户积分
-(void)setUserJiFen:(NSString *)userJiFen{
    [userJiFen saveToNSDefaultsWithKey:kuserJiFenKey];
}
-(NSString *)userJiFen{
    return [self loadStringFromDefaultsWithKey:kuserJiFenKey];
}
//用户 是否认证
-(void)setUserStatus:(NSInteger)userStatus{
    [[NSUserDefaults standardUserDefaults]setInteger:userStatus forKey:kuserStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSInteger)userStatus{
    return [[NSUserDefaults standardUserDefaults]integerForKey:kuserStatus];
}
/** 用户是否开工*/
-(void)setIsWork:(BOOL)isWork{
    [[NSUserDefaults standardUserDefaults]setBool:isWork forKey:kisWorkKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)isWork{
    return [[NSUserDefaults standardUserDefaults]boolForKey:kisWorkKey];
}


/** 用户有新消息*/
-(void)setIsRead:(BOOL)isRead{
    [[NSUserDefaults standardUserDefaults]setBool:isRead forKey:kuserIsRead];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)isRead{
    return [[NSUserDefaults standardUserDefaults]boolForKey:kuserIsRead];
}
/** 用户总接单量*/
-(void)setUserAllOrderNum:(NSString *)userAllOrderNum{
    [userAllOrderNum saveToNSDefaultsWithKey:kuserAllOrderNumKey];
}
-(NSString *)userAllOrderNum{
    return [self loadStringFromDefaultsWithKey:kuserAllOrderNumKey];
}
/** 用户总提成*/
-(void)setUserAllTiCheng:(NSString *)userAllTiCheng{
    [userAllTiCheng saveToNSDefaultsWithKey:kuserAllTiChengKey];
}
-(NSString *)userAllTiCheng{
    return [self loadStringFromDefaultsWithKey:kuserAllTiChengKey];
}
/** 用户总接单金额*/
-(void)setUserAllJieDanJinE:(NSString *)userAllJieDanJinE{
    [userAllJieDanJinE saveToNSDefaultsWithKey:kuserAllJieDanJinEKey];
}
-(NSString *)userAllJieDanJinE{
    return [self loadStringFromDefaultsWithKey:kuserAllJieDanJinEKey];
}
/** 用户总距离*/
-(void)setUserAllJuLi:(NSString *)userAllJuLi{
    [userAllJuLi saveToNSDefaultsWithKey:kuserAllJuLiKey];
}
-(NSString *)userAllJuLi{
    return [self loadStringFromDefaultsWithKey:kuserAllJuLiKey];
}


/** 用户今日订单*/
-(void)setUserTodayOrderNum:(NSString *)userTodayOrderNum{
    [userTodayOrderNum saveToNSDefaultsWithKey:kuserTodayOrderNumKey];
}
-(NSString *)userTodayOrderNum{
    return [self loadStringFromDefaultsWithKey:kuserTodayOrderNumKey];
}
/** 用户今日收益*/
-(void)setUserTodayShouYi:(NSString *)userTodayShouYi{
    [userTodayShouYi  saveToNSDefaultsWithKey:kuserTodayShouYiKey];
}
-(NSString *)userTodayShouYi{
    return [self loadStringFromDefaultsWithKey:kuserTodayShouYiKey];
}
/** 用户今日里程*/
-(void)setUserTodayLiCheng:(NSString *)userTodayLiCheng{
    [userTodayLiCheng  saveToNSDefaultsWithKey:kuserTodayLiChengKey];
}
-(NSString *)userTodayLiCheng{
    return [self loadStringFromDefaultsWithKey:kuserTodayLiChengKey];
}




#pragma mark -------------------------------------- 位置信息
//默认地址ID
-(void)setDefaultAddressId:(NSString *)defaultAddressId{
    [defaultAddressId saveToNSDefaultsWithKey:kdefaultAddressIdKey];
}
-(NSString *)defaultAddressId{
    return [self loadStringFromDefaultsWithKey:kdefaultAddressIdKey];
}
//省
-(void)setProvince:(NSString *)province{
    [province saveToNSDefaultsWithKey:kprovinceKey];
}
-(NSString *)province{
    return [self loadStringFromDefaultsWithKey:kprovinceKey];
}
//市
-(void)setCity:(NSString *)city{
    [city saveToNSDefaultsWithKey:kcityKey];
}
-(NSString *)city{
    return [self loadStringFromDefaultsWithKey:kcityKey];
}
//区（县）
-(void)setArea:(NSString *)area{
    [area saveToNSDefaultsWithKey:kareaKey];
}
-(NSString *)area{
    return [self loadStringFromDefaultsWithKey:kareaKey];
}
//街道
-(void)setRode:(NSString *)rode{
    [rode saveToNSDefaultsWithKey:kRode];
}
-(NSString *)rode{
   return [self loadStringFromDefaultsWithKey:kRode];
}
//详细地址
-(void)setPlace:(NSString *)place{
    [place saveToNSDefaultsWithKey:kplaceKey];
}
-(NSString *)place{
    return [self loadStringFromDefaultsWithKey:kplaceKey];
}
//经度
-(void)setLongitude:(NSString *)longitude{
    [longitude saveToNSDefaultsWithKey:klongitudeKey];
}
-(NSString *)longitude{
    return [self loadStringFromDefaultsWithKey:klongitudeKey];
}
//纬度
-(void)setLatitude:(NSString *)latitude{
    [latitude saveToNSDefaultsWithKey:klatitudeKey];
}
-(NSString *)latitude{
    return [self loadStringFromDefaultsWithKey:klatitudeKey];
}
#pragma mark -------------------------------------- 登录状态
-(void)setIsLogin:(BOOL)isLogin{
    [[NSUserDefaults standardUserDefaults]setBool:isLogin forKey:kisLoginKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)isLogin{
    return [[NSUserDefaults standardUserDefaults]boolForKey:kisLoginKey];
}
#pragma mark -------------------------------------- 秋秋跑腿项目需求
/** 银行的名字*/
-(void)setDefaultBankName:(NSString *)defaultBankName{
    [defaultBankName saveToNSDefaultsWithKey:kdefaultBankName];
}
-(NSString *)defaultBankName{
    return [self loadStringFromDefaultsWithKey:kdefaultBankName];
}
//用户默认的银行卡
-(void)setDefaultBankCardNum:(NSString *)defaultBankCardNum{
    [defaultBankCardNum saveToNSDefaultsWithKey:kdefaultBankCardNum];
}
-(NSString *)defaultBankCardNum{
    return [self loadStringFromDefaultsWithKey:kdefaultBankCardNum];
}
/** 绑定的银行卡类型*/
-(void)setDefaultBankCardKind:(NSString *)defaultBankCardKind{
    [defaultBankCardKind saveToNSDefaultsWithKey:kdefaultBankCardKind];
}
-(NSString *)defaultBankCardKind{
    return [self loadStringFromDefaultsWithKey:kdefaultBankCardKind];
}



@end
