//
//  RongYuBangTableViewCell.h
//  SJSD
//
//  Created by 软盟 on 16/4/27.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface RongYuBangTableViewCell : SuperTableViewCell
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *nickNamelabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *rankLabel;
@property (nonatomic,strong) UILabel *moneyLabel;

@property (nonatomic,strong) UIImageView *topLine;
@property (nonatomic,strong) UIImageView *shortLine;
@property (nonatomic,strong) UIImageView *bottomLine;
@end
