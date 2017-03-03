//
//  ShouYiAndLiChengTableViewCell.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "ShouYiAndLiChengTableViewCell.h"

@implementation ShouYiAndLiChengTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupNewView];
    }
    return self;
}
-(void)setupNewView
{
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = SmallFont(self.scale);
    _timeLabel.textColor = grayTextColor;
    [self addSubview:_timeLabel];
    
    _orderNumLabel = [[UILabel alloc] init];
    _orderNumLabel.font = DefaultFont(self.scale);
    [self addSubview:_orderNumLabel];
    
    _orderDistanceLabel = [[UILabel alloc] init];
    _orderDistanceLabel.font = DefaultFont(self.scale);
    [self addSubview:_orderDistanceLabel];
    
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
    
    _timeLabel.frame = CGRectMake(RM_Padding, RM_Padding, self.width - RM_Padding*2, 20*self.scale);
    
    _orderNumLabel.frame = CGRectMake(_timeLabel.left, _timeLabel.bottom, _timeLabel.width , _timeLabel.height);
    
    _orderDistanceLabel.frame = CGRectMake(_timeLabel.left, _orderNumLabel.bottom, _timeLabel.width , _timeLabel.height);
    
    _shortLine.frame = CGRectMake(RM_Padding, self.height-.5, self.width - 2*RM_Padding, 0.5);
    
    _bottomLine.frame = CGRectMake(RM_Padding, self.height-0.5, self.width - 2*RM_Padding, 0.5);
}
@end
