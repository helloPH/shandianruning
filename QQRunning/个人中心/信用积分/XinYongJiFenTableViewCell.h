//
//  XinYongJiFenTableViewCell.h
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface XinYongJiFenTableViewCell : SuperTableViewCell
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *reasonLabel;
@property (nonatomic,strong) UILabel *jiFenLabel;

@property (nonatomic,strong) UIImageView *topLine;
@property (nonatomic,strong) UIImageView *shortLine;
@property (nonatomic,strong) UIImageView *bottomLine;

@property (nonatomic,assign) BOOL isGuiZe;
@end
