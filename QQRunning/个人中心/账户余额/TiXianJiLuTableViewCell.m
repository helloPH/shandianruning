//
//  TiXianJiLuTableViewCell.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/21.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "TiXianJiLuTableViewCell.h"

@implementation TiXianJiLuTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupNewView];
    }
    return self;
}
-(void)setupNewView
{
    _leftImageView = [[UIImageView alloc] init];
    _leftImageView.image = [UIImage imageNamed:@"yue_icon02"];
    [self addSubview:_leftImageView];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = SmallFont(self.scale);
    _timeLabel.textColor = grayTextColor;
    [self addSubview:_timeLabel];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = DefaultFont(self.scale);
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    
    _moneylabel = [[UILabel alloc] init];
    _moneylabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_moneylabel];
    
    _topLine = [[UIImageView alloc] init];
    _topLine.backgroundColor = blackLineColore;
    _topLine.hidden = YES;
    [self addSubview:_topLine];
    
    _shortLine = [[UIImageView alloc] init];
    _shortLine.backgroundColor = blackLineColore;
    _shortLine.hidden = YES;
    [self addSubview:_shortLine];
    
    _bottomLine = [[UIImageView alloc] init];
    _bottomLine.backgroundColor = blackLineColore;
    _bottomLine.hidden = YES;
    [self addSubview:_bottomLine];
}
-(void)layoutSubviews
{
     _topLine.frame = CGRectMake(0, 0, self.width, 0.5);
    
    _leftImageView.frame = CGRectMake(10*self.scale, 10*self.scale, 15*self.scale, 15*self.scale);
    
    _timeLabel.frame = CGRectMake(_leftImageView.right + 10*self.scale, _leftImageView.top, self.width - 45*self.scale, _leftImageView.height);
    
    _titleLabel.frame = CGRectMake(_leftImageView.left, _leftImageView.bottom+10*self.scale, self.width - 20*self.scale, 20*self.scale);
    [_timeLabel sizeToFit];
    
    _moneylabel.frame = CGRectMake(self.width - 90*self.scale, _titleLabel.top, 80*self.scale, 20*self.scale);
    
    _shortLine.frame = CGRectMake(RM_Padding, self.height-.5, self.width - 2*RM_Padding, 0.5);
    
    _bottomLine.frame = CGRectMake(RM_Padding, self.height-0.5, self.width - 2*RM_Padding, 0.5);
}

@end
