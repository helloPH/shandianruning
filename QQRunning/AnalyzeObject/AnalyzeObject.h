//
//  AnalyzeObject.h
//  BaseProject
//
//  Created by 软盟 on 2016/11/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^Blocks)(id model, NSString *ret, NSString *msg);
@interface AnalyzeObject : NSObject
#pragma mark -- 登录注册
/*
 *获取验证码
 */
+(void)getVerifyCodeWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *加载省份
 */
+(void)getProvinceListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *加载市
 */
+(void)getCityListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *注册
 */
+(void)registWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *登录
 */
+(void)loginWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *配送人员提交申请
 */
+(void)commitPeiSongDataWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

#pragma  mark -- 首页
/*
 *实时订单
 */
+(void)getRealTimeOrderWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *收工/开工
 */
+(void)changeToShougongOrKaigongWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *抢单
 */
+(void)qingdanWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *完成订单
 */
+(void)getFinishOrderListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *未抢订单
 */
+(void)getunQiangOrderListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *待完成订单
 */
+(void)getunFinishOrderListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *待完成订单详情
 */
+(void)getUnFinishOrderDetailWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

/*
 *待完成订单 进行中 的操作
 */ //买送取
+(void)changeOrderStateBuyBringTakeWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
+(void)changeOrderStateMotorcycleWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
+(void)changeOrderStateHelpWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *快车
 */
+(void)kuaiCheShangCheWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
+(void)kuaiCheDaoDaWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *上传位置
 */
+(void)uploadLocationWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *二维码
 */
+(void)getErWeiMaWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

#pragma mark  --   个人中心
/*
 *获得奔跑里程里程  和 收益
 */
+(void)getBenPaoLiChengAndShouYiWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

/*
 *信用积分
 */
+(void)getJiFenDicWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *获取银行卡信息
 */
+(void)getBankCardInfoWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

/*
 *绑定银行卡
 */
+(void)bandingBankCardWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *提现明细
 */
+(void)getWithdrawRecordWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

/*
 *APP文本设置
 */
+(void)getAppTextWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *APP设置文本
 */
+(void)getAppSetParamterWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *消息通知
 */
+(void)getMessageListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *消息通知详情
 */
+(void)getMessageDetailWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *账户提现
 */
+(void)withdrawWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *更换银行卡
 */
+(void)changeBankCardWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *删除银行卡
 */
+(void)deleBankCardWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *荣誉榜
 */
+(void)getRongYuBangListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *意见反馈
 */
+(void)feedBackWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *修改密码
 */
+(void)updatePasswordWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;
/*
 *找回密码
 */
+(void)findPassWordWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;

/*
 *版本更新
 */
+(void)getVersionWithDic:(NSDictionary *)dic WithBlock:(Blocks)block;



@end
