//
//  KuaiCheViewController.h
//  QQRunning
//
//  Created by wdx on 2017/2/9.
//  Copyright © 2017年 软盟. All rights reserved.
//

#import "SuperViewController.h"

@interface KuaiCheViewController : SuperViewController
@property (nonatomic,strong)NSString * orderId;

@property (nonatomic,strong)void(^block)();
@end
