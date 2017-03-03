//
//  MessageTableViewCell.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
    
    _bluePoint = [[UIImageView alloc] init];
    _bluePoint.backgroundColor = mainColor;
//    [self addSubview:_bluePoint];
    
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = blackTextColor;
    _titleLabel.font = DefaultFont(self.scale);
    [self addSubview:_titleLabel];
    
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = grayTextColor;
    _contentLabel.font = Small11Font(self.scale);
    [self addSubview:_contentLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = blackTextColor;
    _timeLabel.font = Small11Font(self.scale);
    _timeLabel.textAlignment=NSTextAlignmentRight;
    [self addSubview:_timeLabel];
    
    
    _rightImage = [[UIImageView alloc] init];
    _rightImage.image = [UIImage imageNamed:@"personal_jinru"];
    _rightImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_rightImage];
    
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
-(void)layoutSubviews{
//    _rightImage.frame = CGRectMake(self.width - 26*self.scale, self.height/2-8*self.scale, 16*self.scale, 16*self.scale);
    _bluePoint.frame = CGRectMake(self.width - 6*self.scale- RM_Padding, self.height/2- 3*self.scale, 6*self.scale, 6*self.scale);
    _bluePoint.layer.cornerRadius = _bluePoint.width/2;
    _bluePoint.clipsToBounds = YES;
    _titleLabel.frame = CGRectMake(RM_Padding, RM_Padding, _bluePoint.left - 1.5*RM_Padding , 20*self.scale);
    _contentLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom, _titleLabel.width, _titleLabel.height);
    _timeLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.top, 100, _titleLabel.height);
    _timeLabel.right=self.width-RM_Padding;
    _topLine.frame = CGRectMake(0, 0, self.width, 0.5);
    _shortLine.frame = CGRectMake(RM_Padding, self.height-.5, self.width - 2*RM_Padding, 0.5);
    _bottomLine.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
}
@end
