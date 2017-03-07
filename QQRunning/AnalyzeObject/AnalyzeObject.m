//
//  AnalyzeObject.m
//  BaseProject
//
//  Created by 软盟 on 2016/11/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "AnalyzeObject.h"
#import "AFAppDotNetAPIClient.h"
#import "NSError+Helper.h"

@implementation AnalyzeObject
-(void)loadData:(NSDictionary *)dic withUrl:(NSString *)url WithBlock:(void (^)(id, NSString *, NSString *))block{
    
    [[AFAppDotNetAPIClient sharedClient]POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *retn = [responseObject objectForKey:@"msgcode"];
        NSString *ret = [NSString stringWithFormat:@"%@",retn];
        
        NSString *msg =[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
        
        if ([ret isEqualToString:@"1"]) {
            
            block([responseObject objectForKey:@"data"],ret,msg);
        }else{
            block(nil,ret,msg);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,nil,@"当前无网络环境、请检查网络连接.");
        
    }];
    
    
}
#pragma mark -- 登录注册
/*
 *获取验证码
 */
+(void)getVerifyCodeWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"get_phoneCode"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}

/*
 *加载省份
 */
+(void)getProvinceListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"get_province"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *加载市
 */
+(void)getCityListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"get_city"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *注册
 */
+(void)registWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"user_register"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *登录
 */
+(void)loginWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"user_login"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *配送人员提交申请
 */
+(void)commitPeiSongDataWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Inser_PeiSongData"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}

#pragma  mark -- 首页
/*
 *实时订单
 */
+(void)getRealTimeOrderWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_Order"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *收工/开工
 */
+(void)changeToShougongOrKaigongWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"UpdateStatus"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *抢单
 */
+(void)qingdanWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_QiangOrder"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *完成订单
 */
+(void)getFinishOrderListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_FishOrder"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}

/*
 *未抢订单
 */
+(void)getunQiangOrderListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_NoLotOrder"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *待完成订单
 */
+(void)getunFinishOrderListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_DaiWanChengOrder"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *待完成订单详情
 */
+(void)getUnFinishOrderDetailWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_OrderDetail"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *待完成订单 进行中 的操作
 */////买送取
+(void)changeOrderStateBuyBringTakeWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Inser_OrderStatus"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
// 快车
+(void)changeOrderStateMotorcycleWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Insert_KuaiCheStatus"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
//  代排队 帮吗
+(void)changeOrderStateHelpWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Inser_DaiPaiDuiB"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
     }];
}
/*
 *快车
 */
/*
 * 上车
 */
+(void)kuaiCheShangCheWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Update_UpCar"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 * 到达
 */
+(void)kuaiCheDaoDaWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Update_KuaiCheFishion"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *上传位置
 */
+(void)uploadLocationWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Confirm_PeiSongGPS"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *二维码
 */
+(void)getErWeiMaWithDic:(NSDictionary *)dic WithBlock:(Blocks)block
{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_QRCode"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
    
}
#pragma mark  --   个人中心
/*
 *获得奔跑里程里程  和 收益
 */
+(void)getBenPaoLiChengAndShouYiWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_BenPaoLiCheng"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}

/*
 *信用积分
 */
+(void)getJiFenDicWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_XinYong"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *获取银行卡信息
 */
+(void)getBankCardInfoWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_ZhangHuTiXian"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *绑定银行卡
 */
+(void)bandingBankCardWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Add_Bank"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *提现明细
 */
+(void)getWithdrawRecordWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_TiXianDetail"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}

/*
 *APP文本设置
 */
+(void)getAppTextWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_AppText"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *APP设置文本
 */
+(void)getAppSetParamterWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_APPSetParamter"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *消息通知
 */
+(void)getMessageListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_Informatica"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *消息通知详情
 */
+(void)getMessageDetailWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_InfoDetail"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *账户提现
 */
+(void)withdrawWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Inser_TiXianShen"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *更换银行卡
 */
+(void)changeBankCardWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Update_Bank"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *删除银行卡
 */
+(void)deleBankCardWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Delete_Bank"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *荣誉榜
 */
+(void)getRongYuBangListWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_RongYuBang"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *意见反馈
 */
+(void)feedBackWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Add_Suggest"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *修改密码
 */
+(void)updatePasswordWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Update_Pwd"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *找回密码
 */
+(void)findPassWordWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_Pwd"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}
/*
 *版本更新
 */
+(void)getVersionWithDic:(NSDictionary *)dic WithBlock:(Blocks)block{
    NSMutableDictionary * dicM=[NSMutableDictionary dictionaryWithDictionary:@{@"action":@"Get_Version"}];
    [dicM addEntriesFromDictionary:dic];
    AnalyzeObject * ana=[AnalyzeObject new];
    [ana loadData:dicM withUrl:@"interfaceDOC/firstProject/PerSongs.ashx?" WithBlock:^(id model, NSString *ret, NSString *msg) {
        block(model,ret,msg);
    }];
}

@end
