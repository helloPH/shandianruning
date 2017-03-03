//
//  CustomUnFinishView.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/24.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "CustomUnFinishView.h"

@interface CustomUnFinishView ()
@property(nonatomic,assign) float scale;

@end

@implementation CustomUnFinishView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupNewView];
        if ([[UIScreen mainScreen] bounds].size.height > 480)
        {
            _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
        }
        self.backgroundColor=whiteLineColore;
    }
    return self;
}
-(void)setupNewView{
    _stepImageView = [[UIImageView alloc] init];
    _stepImageView.image = [UIImage imageNamed:@"peisong_xianshi_dian02"];
    _stepImageView.highlightedImage = [UIImage imageNamed:@"peisong_xianshi_dian01"];
    [self addSubview:_stepImageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = grayTextColor;
    [self addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = DefaultFont(self.scale);
    _contentLabel.textColor = grayTextColor;
    [self addSubview:_contentLabel];
    
    _bottomLine = [[UIImageView alloc] init];
    _bottomLine.backgroundColor = blackLineColore;
    [self addSubview:_bottomLine];
    
    _shortLine = [[UIImageView alloc] init];
    _shortLine.backgroundColor = blackLineColore;
    [self addSubview:_shortLine];
    
}
-(void)layoutSubviews{
    _stepImageView.frame =CGRectMake(RM_Padding, RM_Padding, 60/2.25*self.scale, 60/2.25*self.scale);
    _titleLabel.frame = CGRectMake(_stepImageView.right + RM_Padding, RM_Padding, 100*self.scale, 30*self.scale);
    
}
@end
