//
//  TiXianJiLuTableViewCell.h
//  QQRunning
//
//  Created by 软盟 on 2016/12/21.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface TiXianJiLuTableViewCell : SuperTableViewCell
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *moneylabel;

@property (nonatomic,strong) UIImageView *topLine;
@property (nonatomic,strong) UIImageView *shortLine;
@property (nonatomic,strong) UIImageView *bottomLine;
@end
