//
//  MessageTableViewCell.h
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface MessageTableViewCell : SuperTableViewCell
@property (nonatomic,strong) UIImageView *bluePoint;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *timeLabel;


@property (nonatomic,strong) UIImageView *rightImage;

@property (nonatomic,strong) UIImageView *topLine;
@property (nonatomic,strong) UIImageView *shortLine;
@property (nonatomic,strong) UIImageView *bottomLine;
@end
