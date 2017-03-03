//
//  KeFuTableViewCell.h
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface KeFuTableViewCell : SuperTableViewCell
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *decLabel;
@property (nonatomic,strong) UIImageView *rightImage;

@property (nonatomic,strong) UIImageView *topLine;
@property (nonatomic,strong) UIImageView *shortLine;
@property (nonatomic,strong) UIImageView *bottomLine;
@end
