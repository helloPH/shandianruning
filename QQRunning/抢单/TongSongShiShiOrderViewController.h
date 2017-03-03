//
/**
 *  实时订单弹出界面
 */
//  TongSongShiShiOrderViewController.h
//  QQRunning
//
//  Created by 软盟 on 2016/12/27.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "SuperViewController.h"

@class TongSongShiShiOrderViewController;
@protocol TongSongShiShiOrderViewControllerDelegate <NSObject>

/**
 关闭弹出的订单视图
 */
-(void)TongSongShiShiOrderViewControllerDelete;

/**
 抢单结果

 @param orderId 订单ID
 */
-(void)TongSongShiShiOrderViewControllerQiangDanResultWithOrderId:(NSString *)orderId isTexi:(BOOL)isTexi;
@end

@interface TongSongShiShiOrderViewController : SuperViewController
@property (nonatomic,strong) NSDictionary * dataDic;
@property (nonatomic,strong) NSString * orderId;
@property (nonatomic,strong) id <TongSongShiShiOrderViewControllerDelegate> delegate;
@end
