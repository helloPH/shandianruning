//
//  SuperViewController.h
//  MissAndFound
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultPageSource.h"
#import "WPAttributedStyleAction.h"
#import "UIViewAdditions.h"
#import "Stockpile.h"
#import "AppDelegate.h"
#import "AnalyzeObject.h"
#import "MJRefresh.h"
#import "WPHotspotLabel.h"
#import "Masonry.h"
#import "CoreSVP.h"
#import "MBProgressHUD+Add.h"
//#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+Helper.h"
#import "NSString+WPAttributedMarkup.h"
#import "UIButton+AFNetworking.h"
#import "UIImage+Helper.h"
#import "UIView+MJExtension.h"
#import "NSNull+NullCast.h"
#import "UITextField+RYNumberKeyboard.h"
#import "UITextView+Placeholder.h"
#import "UIButton+Helper.h"

#import "PHPopBox.h"

#define CODE(__code)  [__code isEqualToString:@"1"]
//#import "UITextField+Helper.h"

/**
 *  各种情况弹出视图样式
 */
typedef NS_ENUM(NSUInteger, tanChuView) {
    //直营商品
    tanChuViewWithQiangDanFaile = 1,  //抢单失败
    tanChuViewWithQiangDanSucess,     //抢单成功
    tanChuViewWithTakePhoto,          //照相
    tanChuViewWithErWeiMa1,            //分享二维码
    tanChuViewWithErWeiMa2,            //分享二维码
    

    tanChuViewWithGetShouYi           //获得的收益
};

/**
 所完成的成就类型

 - ChengJiuTypeToday: 今日成就
 - ChengJiuTypeAll: 累计成就
 */
typedef NS_ENUM(NSUInteger,ChengJiuType) {
    ChengJiuTypeToday = 0,  //今日成就
    ChengJiuTypeAll         //累积成就
};




typedef void(^qiangDanSuccessBlock)();
typedef void(^AlertBlock)(NSInteger index);
typedef void(^OKAlertBlock)();
typedef void(^cancleAlertBlock)();
@interface SuperViewController : UIViewController
@property (nonatomic,assign) float scale;
@property (nonatomic,strong) UIImageView *NavImg;
@property (nonatomic,strong) UILabel *TitleLabel;
@property (nonatomic,strong) UIImageView *Navline;
@property (nonatomic,strong) AppDelegate *appdelegate;
@property (nonatomic,strong) MBProgressHUD *HUD;


@property (nonatomic,assign) OrderType  orderType;
@property (nonatomic,strong) NSArray <NSString *> * orderTitles;
/**
 显示提示语

 @param message 提示语
 */
-(void)showMessage:(NSString *)message;

/**
 开始加载数据

 @param message 提示语
 */
-(void)startDownloadDataWithMessage:(NSString *)message;

/**
 结束加载数据
 */
-(void)stopDownloadData;

/**
 弹出一个按钮对话框

 @param message 提示语
 @param title 按钮的标题
 @param okBlock 点击按钮事件
 */
-(void)ShowOKAlertWithTitle:(NSString *)title Message:(NSString *)message WithButtonTitle:(NSString *)btnTitle Blcok:(OKAlertBlock)okBlock;

/**
 弹出一个可选对话框

 @param title 标题
 @param message 提示语
 @param OKtitle 确定按钮title
 @param cancletitle 取消按钮title
 @param okBlock 点击确定事件
 @param cancleBlock 点击取消事件
 */
-(void)ShowOKAndCancleAlertWithTitle:(NSString *)title Message:(NSString *)message WithOKButtonTitle:(NSString *)OKtitle WithCancleButtonTitle:(NSString *)cancletitle OKBlcok:(OKAlertBlock)okBlock CanleBlock:(cancleAlertBlock)cancleBlock;

-(void)CancelOrderMessage:(NSString *)message Delegate:(id)delegate Block:(AlertBlock)block;
-(void)ShowAlertTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate Block:(AlertBlock)block;
-(void)ShowAlertTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate OKText:(NSString *)oktext CancelText:(NSString *)cancel Block:(AlertBlock)block;

-(void)setName:(NSString *)name;

-(CGSize)Text:(NSString *)text Size:(CGSize)size Font:(UIFont *)fone;
-(NSDictionary *)Style;
-(NSDateComponents *)SplitDate:(NSDate *)date;

/**
 弹出对话框

 @param message 消息
 @param code 返回码 0:抢单失败 1：抢单成功 2：拍照 3:分享二维码 4:输入验证码
 @param block block事件
 */
-(void)ShowQiangDanResultMessage:(NSString *)message WithCode:(tanChuView)code WithBlock:(qiangDanSuccessBlock)block;
/**
 *收工的弹出框
 *
 */
-(void)commitKnockOffBlock:(AlertBlock)shougongBlock;

#pragma mark -- 空数据
-(void)kongShuJuWithSuperView:(UIView *)view datas:(NSMutableArray *)datas;
@end
