//
//  SettingTableViewCell.m
//  BaoJiaHuHang2
//
//  Created by apple on 15/9/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
    _TitleLabel=[[UILabel alloc]init];
    _TitleLabel.font=DefaultFont(self.scale);
    _TitleLabel.textColor = blackTextColor;
    [self addSubview:_TitleLabel];
    
    _ValueLabel=[[UILabel alloc]init];
    _ValueLabel.font=DefaultFont(self.scale);
    _ValueLabel.textColor=grayTextColor;
    _ValueLabel.textAlignment=NSTextAlignmentRight;
    [self addSubview:_ValueLabel];
    
    _RigthImage=[[UIImageView alloc]init];
    _RigthImage.image=[UIImage imageNamed:@"personal_jinru"];
    _RigthImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_RigthImage];
    
    _kaiGuan=[[UISwitch alloc]init];
    _kaiGuan.hidden = YES;
    _kaiGuan.onTintColor = mainColor;
    [_kaiGuan addTarget:self action:@selector(KaiGuanEvent:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_kaiGuan];
    
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
    _topLine.frame = CGRectMake(0, 0, self.width, 0.5);
    _TitleLabel.frame=CGRectMake(10*self.scale, self.height/2-10*self.scale, self.width/2-15*self.scale, 20*self.scale);
    _ValueLabel.frame=CGRectMake(_TitleLabel.right+5*self.scale, _TitleLabel.top, _TitleLabel.width-10*self.scale, _TitleLabel.height);
    _RigthImage.frame=CGRectMake(self.width-25*self.scale, self.height/2-8*self.scale, 16*self.scale, 16*self.scale);
    _kaiGuan.frame=CGRectMake(self.width-50*self.scale-10*self.scale, self.height/2-14, 50, 28);
    _shortLine.frame = CGRectMake(RM_Padding, self.height-.5, self.width - 2*RM_Padding, 0.5);
    _bottomLine.frame=CGRectMake(0, self.height-.5, self.width, .5);
}
-(void)KaiGuanEvent:(UISwitch *)kaiGuan{
    if (_delegate && [_delegate respondsToSelector:@selector(SettingTableViewCellSwitch:IndexPath:)]) {
        [_delegate SettingTableViewCellSwitch:kaiGuan.on IndexPath:_indexPath];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
