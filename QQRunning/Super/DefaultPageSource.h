//
//  DefaultPageSource.h
//  AdultStore
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIViewAdditions.h"
//#import "UIImage+Helper.h"
//#import "UIImageView+AFNetworking.h"
//#import "CCLocation.h"
#ifndef DefaultPageSource

#define ImgDuanKou        @"http://www.sdjs.top:1180/"

#pragma mark - 下线通知
#define orderLineKey  @"orderLine"
#define NoNet    @"NoNetKey"

#define Intergral  50
#define minYuE     200



/// 商品类型
typedef NS_ENUM(NSInteger,OrderType) {
    OrderTypeBuy,
    OrderTypeBring,
    OrderTypeTake,
    OrderTypeMotocycleTaxi,
    OrderTypeHelp,
    OrderTypeQueueUp,
    
    
};

//界面布局配置

/**界面间距*/
#define RM_Padding 10*self.scale

/**状态栏高度*/
#define RM_StateHeight 20
/**导航栏高度*/
#define RM_NavHeigth 64
/**底部菜单高度*/
#define RM_TabBarHeigth 49
/**默认高度高度*/
#define RM_CellHeigth 44*self.scale
/**屏幕的宽度*/
#define RM_VWidth [[UIScreen mainScreen] bounds].size.width
/**屏幕的高度*/
#define RM_VHeight [[UIScreen mainScreen] bounds].size.height
/** 大按钮的圆角*/
#define RM_CornerRadius 3*self.scale
/** 大按钮距离边距*/
#define RM_ButtonPadding 25*self.scale
/** 大按钮高度*/
#define RM_ButtonHeight 35*self.scale

/**数据分页*/
#define RM_FenYe  6

#pragma mark - 界面宏定义
#define RM_Scale ([[UIScreen mainScreen] bounds].size.height > 480)?[[UIScreen mainScreen] bounds].size.height / 568.0:1.0
/*
 * 界面颜色设置，基本不用修改
 */
/**黑色线颜色*/
#define blackLineColore [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]

/**白色*/
#define whiteLineColore [UIColor whiteColor]
/**界面背景颜色*/
#define superBackgroundColor [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]
/**底部TabBar背景颜色*/
#define tabBarBackgroundColor [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1]
/**灰色字体颜色*/
#define grayTextColor [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1]
/**黑色字体颜色*/
#define blackTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
/**透明色*/
#define clearColor [UIColor clearColor]

/*项目颜色
 *这些颜色需根据不同的项目要求进行调整
 *没有用到的颜色配置可以忽略不动
 */

/**项目主题颜色*/
#define mainColor [UIColor colorWithRed:246/255.0 green:76/255.0 blue:63/255.0 alpha:1]
/**项目配色颜色*/
#define matchColor [UIColor colorWithRed:255/255.0 green:151/255.0 blue:72/255.0 alpha:1]


/**下划线颜色*/
#define underLineColor [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]
/**粉色字体颜色*/
#define pinkTextColor [UIColor colorWithRed:229/255.0 green:0/255.0 blue:45/255.0 alpha:1]
/**红色字体颜色*/
#define redTextColor [UIColor colorWithRed:251/255.0 green:12/255.0 blue:55/255.0 alpha:1]
/**绿色字体颜色*/
#define greenTextColor [UIColor colorWithRed:38/255.0 green:180/255.0 blue:63/255.0 alpha:1]
/**橘色字体颜色*/
#define orangeTextColor [UIColor colorWithRed:255/255.0 green:90/255.0 blue:36/255.0 alpha:1]
/**蓝色字体颜色*/
#define blueTextColor [UIColor colorWithRed:0/255.0 green:208/255.0 blue:251/255.0 alpha:1]
#define lightBlueTextColor [UIColor colorWithRed:0/255.0 green:208/255.0 blue:251/255.0 alpha:0.2]


//项目的字体配置
//导航字体为17号加粗
#define Big17BoldFont(__scale) [UIFont fontWithName:@"Helvetica-Bold" size:17*__scale]
//默认字体颜色为13号
#define DefaultFont(__scale) [UIFont systemFontOfSize:13*__scale];
//默认次级字体为12号
#define SmallFont(__scale) [UIFont systemFontOfSize:12*__scale];
//默认大按钮按钮的字体为15号
#define Big15Font(__scale) [UIFont systemFontOfSize:15*__scale]
//默认滑动按钮的字体为14号
#define Big14Font(__scale) [UIFont systemFontOfSize:14*__scale]
//默认灰色小字11号
#define Small11Font(__scale) [UIFont systemFontOfSize:11*__scale];
#define Small10Font(__scale) [UIFont systemFontOfSize:10*__scale];

#define Small12BoldFont(__scale) [UIFont fontWithName:@"Helvetica-Bold" size:12*__scale]
#define Small11BoldFont(__scale) [UIFont fontWithName:@"Helvetica-Bold" size:11*__scale]
#define Big14BoldFont(__scale) [UIFont fontWithName:@"Helvetica-Bold" size:14*__scale]
#define Big16Font(__scale) [UIFont systemFontOfSize:16*__scale]
#define Big17Font(__scale) [UIFont systemFontOfSize:17*__scale]
#define SBigFont(__scale) [UIFont systemFontOfSize:18*__scale];

#pragma mark -  旋转角度
#define DegreesToRadians(x) ((x) * M_PI / -180.0)

//项目中文字长度限制

/** 姓名长度*/
#define RM_NameLength 8
/** 手机号码长度*/
#define RM_TelLength 11
/** 密码最大长度*/
#define RM_PwdMaxLength 20
/** 密码最小长度*/
#define RM_PwdMinLength 6
/** 验证码长度*/
#define RM_CodeLength 6
/** 邮编长度*/
#define RM_PostCodeLength 6
/** 标题长度*/
#define RM_TitleLength 20
/** 留言、意见反馈长度*/
#define RM_LeaveMessageLength 200
/** 评论长度*/
#define RM_CommentLength 200
/** 地址长度*/
#define RM_AddressLength 45
/** 银行卡长度*/
#define RM_BankCardLength 19
/** 身份证长度*/
#define RM_IDCardLength 18
/**
 *  买家留言
 */
#define RM_MarkLength 50

#pragma mark - DES加密
#define DESKey   @"CRsc123."
#define DESIV      @"@#$~^&*!"

/*
 public const string appkey = "p5tvi9dst0vz4";
 public const string appSecret = "8OWJWGElF6";
 */
#endif
