//
//  FinishOrderTableViewCell.h
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface FinishOrderTableViewCell : SuperTableViewCell
@property (nonatomic,assign) OrderType orderType;


@property (nonatomic,strong) UILabel *orderTypeLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *beginPointLabel;
@property (nonatomic,strong) UILabel *endPointLabel;
@property (nonatomic,strong) UILabel *orderDecLabel;
@property (nonatomic,strong) UILabel *shouYiLabel;



@end
