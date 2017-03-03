//
//  XinYongJiFenTableViewCell.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "XinYongJiFenTableViewCell.h"

@implementation XinYongJiFenTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = grayTextColor;
    _timeLabel.font = DefaultFont(self.scale);
    [self addSubview:_timeLabel];
    
    _reasonLabel = [[UILabel alloc] init];
    _reasonLabel.textColor = blackTextColor;
    _reasonLabel.font = DefaultFont(self.scale);
    [self addSubview:_reasonLabel];
    
    _jiFenLabel = [[UILabel alloc] init];
    _jiFenLabel.textColor = matchColor;
    _jiFenLabel.font = Big14Font(self.scale);
    _jiFenLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_jiFenLabel];
    
    
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
    _jiFenLabel.frame = CGRectMake(self.width - 60*self.scale, self.height/2-10*self.scale, 50*self.scale, 20*self.scale);
    _timeLabel.frame = CGRectMake(RM_Padding, RM_Padding, _jiFenLabel.left - 2*RM_Padding , 20*self.scale);

    if (_isGuiZe) {
        _reasonLabel.frame = CGRectMake(_timeLabel.left, _timeLabel.bottom, _timeLabel.width, _timeLabel.height);
        _reasonLabel.centerY=self.height/2;
        _jiFenLabel.centerY=_reasonLabel.centerY;
        _timeLabel.hidden=YES;
        
    }else{
        _reasonLabel.frame = CGRectMake(_timeLabel.left, _timeLabel.bottom, _timeLabel.width, _timeLabel.height);
        _timeLabel.hidden=NO;
    }
    _topLine.frame = CGRectMake(0, 0, self.width, 0.5);
    _shortLine.frame = CGRectMake(RM_Padding, self.height-.5, self.width - 2*RM_Padding, 0.5);
    _bottomLine.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
    

}

@end
