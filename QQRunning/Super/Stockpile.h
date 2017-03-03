//
//  Stockpile.h
//  CenterFo
//
//  Created by apple on 14-7-11.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Helper.h"

#define single_interface(class)  + (class *)shared##class;

@interface Stockpile : NSObject

single_interface(Stockpile);
#pragma mark -------------------------------------- 位置信息
/** 默认地址ID*/
@property (nonatomic,strong) NSString *defaultAddressId;
/** 省*/
@property (nonatomic,strong) NSString *province;
/** 市*/
@property (nonatomic,strong) NSString *city;
/** 县(区)*/
@property (nonatomic,strong) NSString *area;
/** 路*/
@property (nonatomic,strong) NSString *rode;
/** 详细地址*/
@property (nonatomic,strong) NSString *place;
/** 纬度*/
@property (nonatomic,strong) NSString *latitude;
/** 经度*/
@property (nonatomic,strong) NSString *longitude;
#pragma mark -------------------------------------- 用户信息
/** 用户账号*/
@property (nonatomic,strong) NSString *userAccount;
/** 密码 */
@property (nonatomic,strong) NSString *userPassword;
/** 用户ID*/
@property (nonatomic,strong) NSString *userID;
/** 用户头像*/
@property (nonatomic,strong) NSString *userLogo;
/** 用户昵称*/
@property (nonatomic,strong) NSString *userNickName;
/** 用户真实姓名*/
@property (nonatomic,strong) NSString *userRealName;
/** 用户性别*/
@property (nonatomic,strong) NSString *userSex;
/** 用户手机(电话)*/
@property (nonatomic,strong) NSString *userPhone;
/** 用户邮箱*/
@property (nonatomic,strong) NSString *userEmail;

#pragma mark -------------------------------------- 账号信息
/** 用户等级*/
@property (nonatomic,strong) NSString *userRank;
/** 用户积分*/
@property (nonatomic,strong) NSString *userJiFen;
/** 用户余额*/
@property (nonatomic,strong) NSString *userYuE;
/** 是否*/
@property (nonatomic,assign) NSInteger userStatus;
/** 用户是否开工*/
@property (nonatomic,assign) BOOL isWork;




/** 用户消息是否有新消息*/
@property (nonatomic,assign) BOOL isRead;
/** 用户总接单量*/
@property (nonatomic,strong) NSString *userAllOrderNum;
/** 用户总接单金额*/
@property (nonatomic,strong) NSString *userAllJieDanJinE;
/** 用户总提成*/
@property (nonatomic,strong) NSString *userAllTiCheng;
/** 用户总距离*/
@property (nonatomic,strong) NSString *userAllJuLi;


/** 用户今日订单*/
@property (nonatomic,strong) NSString *userTodayOrderNum;
/** 用户今日收益*/
@property (nonatomic,strong) NSString *userTodayShouYi;
/** 用户今日里程*/
@property (nonatomic,strong) NSString *userTodayLiCheng;


#pragma mark -------------------------------------- 登录状态
/** 是否登录*/
@property(nonatomic,assign)BOOL isLogin;
#pragma mark -------------------------------------- 秋秋跑腿项目需求
/** 银行的名字*/
@property (nonatomic,strong) NSString *defaultBankName;
/** 绑定的银行卡*/
@property (nonatomic,strong) NSString *defaultBankCardNum;
/** 绑定的银行卡类型*/
@property (nonatomic,strong) NSString *defaultBankCardKind;

@end
