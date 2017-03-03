//
//  CoreSVP.h
//
//  Created by muxi on 14/10/22.
//  Copyright (c) 2014年 muxi. All rights reserved.
//  提示工具类



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

#define kDuration 1.5

typedef enum {
    
    CoreSVPTypeCenterMsg=0,                                                                 //无图片普通提示，显示在屏幕正中间
    
    CoreSVPTypeBottomMsg,                                                                   //无图片普通提示，显示在屏幕下方，tabbar之上
    
    CoreSVPTypeInfo,                                                                        //Info
    
    CoreSVPTypeLoadingInterface,                                                            //Progress,可以互
    
    CoreSVPTypeError,                                                                       //error
    
    CoreSVPTypeSuccess                                                                      //success

}CoreSVPType;





@interface CoreSVP : NSObject

/**
*  展示提示框
*
*  @param type          类型
*  @param msg           文字
*  @param duration      时间（当type=CoreSVPTypeLoadingInterface时无效）
*  @param allowEdit     否允许编辑
*  @param beginBlock    提示开始时的回调
*  @param completeBlock 提示结束时的回调
*/
+(void)showSVPWithType:(CoreSVPType)type Msg:(NSString *)msg duration:(CGFloat)duration allowEdit:(BOOL)allowEdit beginBlock:(void(^)())beginBlock completeBlock:(void(^)())completeBlock;


/*
 *  进度
 */
+(void)showProgess:(CGFloat)progress Msg:(NSString *)msg maskType:(SVProgressHUDMaskType)maskType;

/**
 *  隐藏提示框
 */
+(void)dismiss;


#pragma mark -- 自己写的
/**
 *  只显示文字在中间
 *
 *  @param message 提示内容
 */
+(void)showMessageInCenterWithMessage:(NSString *)message;
/**
 *  只显示文字在底部
 *
 *  @param message 提示内容
 */
+(void)showMessageInBottomWithMessage:(NSString *)message;
/**
 *  显示图文并存提示框
 *
 *  @param message           提示内容
 *  @param code              接口返回code码   0:失败  1:成功
 */
+(void)showMessage:(NSString *)message WithCode:(NSString *)code;

/**
 *  开始加载数据
 */
+(void)startDownloadDataWithMessage:(NSString *)message;

/**
 * 结束加载数据
 */
+(void)stopDownloadData;
/**
 *  结束加载数据能回调
 *
 *  @param message    提示内容
 *  @param code       code码 0：失败  1：成功
 *  @param failBlock  失败回调
 *  @param suceedBlok 成功回调
 */
+(void)stopDownloadDataWithMessage:(NSString *)message WithCode:(NSString *)code FailBlock:(void(^)())failBlock SuceedBlock:(void(^)())suceedBlok;
@end
