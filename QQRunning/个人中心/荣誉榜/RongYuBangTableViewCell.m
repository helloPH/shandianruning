//
//  RongYuBangTableViewCell.m
//  SJSD
//
//  Created by 软盟 on 16/4/27.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "RongYuBangTableViewCell.h"

@implementation RongYuBangTableViewCell
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
    _leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:_leftImageView];
    
    _headImageView = [[UIImageView alloc] init];
    [self addSubview:_headImageView];
    
    _nickNamelabel = [[UILabel alloc] init];
    _nickNamelabel.font = DefaultFont(self.scale);
    _nickNamelabel.textColor = blackTextColor;
    [self addSubview:_nickNamelabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = SmallFont(self.scale);
    _contentLabel.textColor = grayTextColor;
    [self addSubview:_contentLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textAlignment = 2;
    [self addSubview:_moneyLabel];
    
    _rankLabel = [[UILabel alloc] init];
    _rankLabel.textAlignment = 1;
    _rankLabel.font = Small10Font(self.scale);
    [self addSubview:_rankLabel];
    
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
    _topLine.hidden = YES;
    [self addSubview:_bottomLine];
    
    
}
-(void)layoutSubviews
{
    _leftImageView.frame = CGRectMake(10*self.scale, self.height/2-12.5*self.scale, 25*self.scale, 25*self.scale);
    _rankLabel.frame = CGRectMake(_leftImageView.left, _leftImageView.top+6*self.scale, _leftImageView.width, 10*self.scale);
    
    _headImageView.frame = CGRectMake(_leftImageView.right+10*self.scale, RM_Padding, self.height-RM_Padding*2, self.height-RM_Padding*2);
    _headImageView.layer.borderWidth = self.scale;
    _headImageView.layer.borderColor = [UIColor orangeColor].CGColor;
    _headImageView.layer.cornerRadius = _headImageView.width/2.0;
    _headImageView.clipsToBounds = YES;
//
    _nickNamelabel.frame = CGRectMake(_headImageView.right+10*self.scale, _headImageView.top, 100*self.scale, _headImageView.height/2.0);
    
    _contentLabel.frame = CGRectMake(_nickNamelabel.left, _nickNamelabel.bottom, self.width - _nickNamelabel.left, _nickNamelabel.height);
    _moneyLabel.frame = CGRectMake(self.width - 110*self.scale, self.height/2-15*self.scale, 100*self.scale, 30*self.scale);
    
    _topLine.frame = CGRectMake(0, 0, self.width, 0.5);
    _shortLine.frame = CGRectMake(RM_Padding, self.height-.5, self.width - 2*RM_Padding, 0.5);
    _bottomLine.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
    
}
@end
