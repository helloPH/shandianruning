//
//  KeFuTableViewCell.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "KeFuTableViewCell.h"

@implementation KeFuTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
    
    _headImageView = [[UIImageView alloc] init];
    [self addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = blackTextColor;
    _nameLabel.font = DefaultFont(self.scale);
    [self addSubview:_nameLabel];
    
    _decLabel = [[UILabel alloc] init];
    _decLabel.textColor = blackTextColor;
    _decLabel.font = DefaultFont(self.scale);
    [self addSubview:_decLabel];
    
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
    _headImageView.frame = CGRectMake(RM_Padding, RM_Padding, self.height- 2*RM_Padding, self.height- 2*RM_Padding);
    _rightImage.frame = CGRectMake(self.width - 26*self.scale, self.height/2-8*self.scale, 16*self.scale, 16*self.scale);
    _nameLabel.frame = CGRectMake(_headImageView.right + RM_Padding, RM_Padding, _rightImage.left - _headImageView.right - 2*RM_Padding , 20*self.scale);
    _decLabel.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom, _nameLabel.width, _nameLabel.height);
    
    _topLine.frame = CGRectMake(0, 0, self.width, 0.5);
    _shortLine.frame = CGRectMake(RM_Padding, self.height-.5, self.width - 2*RM_Padding, 0.5);
    _bottomLine.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
}
@end
