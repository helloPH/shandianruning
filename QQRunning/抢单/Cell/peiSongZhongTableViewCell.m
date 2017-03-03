//
//  peiSongZhongTableViewCell.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/26.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "peiSongZhongTableViewCell.h"
#import "UIImage+Helper.h"
@implementation peiSongZhongTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupNewView];
    }
    return self;
}
-(void)setupNewView{
    
    _stepLineUp  = [[UIImageView alloc] init];
    _stepLineUp.backgroundColor=blackLineColore;
    [self addSubview:_stepLineUp];
    
    _stepLineDown = [[UIImageView alloc] init];
    _stepLineDown.backgroundColor=blackLineColore;
    [self addSubview:_stepLineDown];

    _stepImageView = [[UIImageView alloc] init];
    [self addSubview:_stepImageView];
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = grayTextColor;
    _titleLabel.font = Big14Font(self.scale);
    [self addSubview:_titleLabel];
    
    _stepLabel = [[UILabel alloc] init];
    _stepLabel.textColor = grayTextColor;
    _stepLabel.font = DefaultFont(self.scale);
    [self addSubview:_stepLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = DefaultFont(self.scale);
    _contentLabel.textColor = grayTextColor;
    _contentLabel.numberOfLines = 2;
    [self addSubview:_contentLabel];
    
    _statusButton = [[UIButton alloc] init];
    [_statusButton setTitleColor:grayTextColor forState:UIControlStateNormal];
    _statusButton.titleLabel.font = DefaultFont(self.scale);
    [_statusButton addTarget:self action:@selector(statusButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_statusButton];
    
    _bottomLine = [[UIImageView alloc] init];
    _bottomLine.backgroundColor = blackLineColore;
    _bottomLine.hidden = YES;
    [self addSubview:_bottomLine];
    
    _shortLine = [[UIImageView alloc] init];
    _shortLine.backgroundColor = blackLineColore;
    _shortLine.hidden = YES;
    [self addSubview:_shortLine];
    
}
-(void)setStatusType:(NSInteger)statusType{
    _statusType = statusType;
    //当前状态
    if (statusType == 1) {
        [_statusButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
        [_statusButton setBackgroundImage:[UIImage ImageForColor:mainColor] forState:UIControlStateNormal];
        _statusButton.userInteractionEnabled = YES;
        
        _titleLabel.textColor = mainColor;
        _stepLabel.textColor = mainColor;
        _contentLabel.textColor = mainColor;
        _leftStepLabel.textColor = mainColor;
        _stepImageView.image = [UIImage imageNamed:@"dangqianzhuangtai"];
//        self.backgroundColor = mainColor;
    }
    //已完成状态
//    else if(statusType < 1){
//        [_statusButton setTitleColor:mainColor forState:UIControlStateNormal];
//        [_statusButton setBackgroundImage:[UIImage setImgNameBianShen:@"tanchuang_btn01"] forState:UIControlStateNormal];
//        
//        _statusButton.userInteractionEnabled = NO;
//        
//        
//        _titleLabel.textColor = mainColor;
//        _stepLabel.textColor = mainColor;
//        _contentLabel.textColor = mainColor;
//        _leftStepLabel.textColor = whiteLineColore;
//        _stepImageView.image = [UIImage imageNamed:@"chenggong"];
//        self.backgroundColor = whiteLineColore;
//    }
    //待完成状态
    else{
        _statusButton.userInteractionEnabled = NO;
        [_statusButton setTitleColor:grayTextColor forState:UIControlStateNormal];
        [_statusButton setBackgroundImage:[UIImage setImgNameBianShen:@"peisong_xianshi_btn02"] forState:UIControlStateNormal];
        _titleLabel.textColor = grayTextColor;
        _stepLabel.textColor = grayTextColor;
        _contentLabel.textColor = grayTextColor;
        _leftStepLabel.textColor = grayTextColor;
        _stepImageView.image = [UIImage imageNamed:@"weidaoda"];
        self.backgroundColor = whiteLineColore;
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    _statusButton.frame = CGRectMake(self.width - 180/2.25*self.scale -RM_Padding, self.height / 2 - 70/2.25*self.scale/2, 180/2.25*self.scale, 70/2.25*self.scale);
    _stepImageView.frame =CGRectMake(RM_Padding, RM_Padding, 30/2.25*self.scale, 30/2.25*self.scale);

//    _leftStepLabel.frame = CGRectMake(0, 0, _stepImageView.width, _stepImageView.height);
    _titleLabel.frame = CGRectMake(_stepImageView.right + RM_Padding, RM_Padding,_statusButton.left - 2*RM_Padding - _stepImageView.right, 20*self.scale);
    _stepImageView.centerY=_titleLabel.centerY;
    [_titleLabel sizeToFit];
    _stepLabel.frame = CGRectMake(_titleLabel.right + 5*self.scale, RM_Padding,_statusButton.left - 1.5*RM_Padding - _titleLabel.right, 20*self.scale);
    _contentLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom+5*self.scale, _statusButton.left - 2*RM_Padding - _stepImageView.right, _titleLabel.height*2);
    _bottomLine.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
    _shortLine.frame = CGRectMake(_titleLabel.left, self.height - 0.5, self.width - _titleLabel.left, 0.5);
    
    
    _stepLineUp.frame=CGRectMake(0, 0, 1, _stepImageView.top);
    _stepLineDown.frame=CGRectMake(0, _titleLabel.bottom, 1, self.height-_stepImageView.bottom);
    _stepLineUp.centerX=_stepLineDown.centerX=_stepImageView.centerX;
}
-(void)statusButtonEvent:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(peiSongZhongTableViewCellDelegateWithIndex:)]) {
        [_delegate peiSongZhongTableViewCellDelegateWithIndex:_indexPath];
    }
}
@end
