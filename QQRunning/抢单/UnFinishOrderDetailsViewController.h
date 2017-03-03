//
//  UnFinishOrderDetailsViewController.h
//  QQRunning
//
//  Created by 软盟 on 2016/12/24.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "SuperViewController.h"

@interface UnFinishOrderDetailsViewController : SuperViewController
@property(nonatomic,assign)NSInteger step;
@property(nonatomic,strong)NSString * shouYi;
@property(nonatomic,strong)NSString * orderId;

@property (nonatomic,strong) void (^block)();
@end
