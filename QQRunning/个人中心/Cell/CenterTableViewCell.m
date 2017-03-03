//
//  CenterTableViewCell.m
//  任务
//
//  Created by 软盟 on 16/1/26.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "CenterTableViewCell.h"
#import "UIViewAdditions.h"
#import "DefaultPageSource.h"
#import "UIImage+Helper.h"

@implementation CenterTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
    _ISOK = NO;
    _HeaderImage=[[UIImageView alloc]init];
    _HeaderImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_HeaderImage];
    
    _NameLabel=[[UILabel alloc]init];
    _NameLabel.font=DefaultFont(self.scale);
    _NameLabel.backgroundColor=clearColor;
    _NameLabel.textColor = blackTextColor;
    [self addSubview:_NameLabel];
    
    _StateImage=[[UIImageView alloc]init];
    _StateImage.image=[UIImage imageNamed:@"wei_rz"];
    [self addSubview:_StateImage];
    
    _StateLabel=[[UILabel alloc]init];
    _StateLabel.backgroundColor=clearColor;
    _StateLabel.font=SmallFont(self.scale);
    _StateLabel.textColor=grayTextColor;
    [self addSubview:_StateLabel];
    
    _RigthImage=[[UIImageView alloc]init];
    _RigthImage.image=[UIImage ImageForColor:mainColor];
    _RigthImage.image=[UIImage imageNamed:@"personal_jinru"];
    _RigthImage.hidden = NO;
//    _RigthImage.backgroundColor=mainColor;
    _RigthImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_RigthImage];
    
    _RedPoint=[[UIImageView alloc]init];
    _RedPoint.backgroundColor = [UIColor redColor];
    _RedPoint.hidden=YES;
    [self addSubview:_RedPoint];
    
    _TopLine=[[UIImageView alloc]init];
    _TopLine.backgroundColor=blackLineColore;
    _TopLine.hidden = YES;
    [self addSubview:_TopLine];
    
    _BottomLine=[[UIImageView alloc]init];
    _BottomLine.backgroundColor=blackLineColore;
    _BottomLine.hidden = YES;
    [self addSubview:_BottomLine];
    
    _shortLine = [[UIImageView alloc] init];
    _shortLine.backgroundColor = blackLineColore;
    _shortLine.hidden = YES;
    [self addSubview:_shortLine];
    
    _spLabel = [[UILabel alloc]init];
    _spLabel.backgroundColor = clearColor;
    _spLabel.font = SmallFont(self.scale);
    _spLabel.textColor = grayTextColor;
    [self addSubview:_spLabel];
    
    
    
    
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    
    _rightLabel = [[UILabel alloc] init];
    _rightLabel.textAlignment = 0;
    [self addSubview:_rightLabel];
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    _TopLine.frame=CGRectMake(0, 0, self.width, 0.5);
    _HeaderImage.frame=CGRectMake(10*self.scale, self.height/2-11*self.scale, 22*self.scale, 22*self.scale);
    _NameLabel.frame=CGRectMake(_HeaderImage.right+10*self.scale, _HeaderImage.top, self.width/2, _HeaderImage.height);
    _StateImage.frame=CGRectMake(self.width-83*self.scale, self.height/2-7*self.scale, 14*self.scale, 14*self.scale);
    _StateLabel.frame=CGRectMake(_StateImage.right-50*self.scale, _StateImage.top, 100*self.scale, _StateImage.height);
    _RedPoint.frame=CGRectMake(self.width-35*self.scale, self.height/2-3*self.scale, 6*self.scale, 6*self.scale);
    _RedPoint.layer.cornerRadius = 3*self.scale;
    _RedPoint.clipsToBounds = YES;
    // if (_ISOK) {
    // _RigthImage.frame=CGRectMake(self.width-20*self.scale, self.height/2-8*self.scale, 30*self.scale, 30*self.scale);
    //}
    //else{
    _RigthImage.frame=CGRectMake(self.width-25*self.scale, self.height/2-8*self.scale, 16*self.scale, 16*self.scale);
    //}
    //_RigthImage.frame=CGRectMake(self.width-20*self.scale, self.height/2-8*self.scale, 10*self.scale, 16*self.scale);
    _shortLine.frame = CGRectMake(RM_Padding, self.height-.5, self.width - 2*RM_Padding, 0.5);
    _BottomLine.frame=CGRectMake(0, self.height-.5, self.width, .5);
    _spLabel.frame =CGRectMake(10*self.scale, self.height/2-11*self.scale, self.width/2, _HeaderImage.height);
    
    _titleLabel.frame = CGRectMake(10*self.scale, 0, self.width/2-30*self.scale, self.height);
    _rightLabel.frame = CGRectMake(_titleLabel.right+10*self.scale, 0, self.width - _titleLabel.right - 40*self.scale, self.height);
    if (_isFenRun) {
        _rightLabel.frame = CGRectMake(_titleLabel.right+40*self.scale, 0, self.width - _titleLabel.right - 40*self.scale, self.height);
    }
}
-(void)setISOK:(BOOL)ISOK{
    if (ISOK) {
        _StateImage.image=[UIImage imageNamed:@"yi_rz"];
        _StateLabel.textColor=[UIColor colorWithRed:0 green:153/255.0 blue:0 alpha:1];
        _spLabel.textColor =[UIColor colorWithRed:0 green:153/255.0 blue:0 alpha:1];
        
    }else{
        _StateImage.image=[UIImage imageNamed:@"wei_rz"];
        _StateLabel.textColor=[UIColor grayColor];
        _spLabel.textColor = [UIColor grayColor];
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
