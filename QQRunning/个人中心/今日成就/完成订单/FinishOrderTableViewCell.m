//
//  FinishOrderTableViewCell.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "FinishOrderTableViewCell.h"
#import "CellView.h"
@interface FinishOrderTableViewCell()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) CellView *cellView;
@property (nonatomic,strong) UIButton *beginButton;
@property (nonatomic,strong) UIButton *endButton;
@property (nonatomic,strong) NSArray <NSString *>* orderTitles;
@end

@implementation FinishOrderTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.orderTitles=@[@"闪电买",@"闪电送",@"闪电取",@"代排队",@"闪电帮",@"闪电摩的"];
        [self setupNewView];
    }
    return self;
}
-(void)setOrderType:(OrderType)orderType{
    _orderType=orderType;
    self.orderTypeLabel.text=self.orderTitles[_orderType];
    
    
    
    [_beginButton setBackgroundImage:[UIImage imageNamed:@"qidian"] forState:UIControlStateNormal];
    [_endButton setBackgroundImage:[UIImage imageNamed:@"zhongdian"] forState:UIControlStateNormal];
    _beginPointLabel.text=@"起";
    _endPointLabel.text=@"终";
    _timeLabel.textColor= blackTextColor;
    
    
    
    
    if (_orderType==OrderTypeQueueUp || _orderType==OrderTypeHelp) {
        [_beginButton setBackgroundImage:[UIImage imageNamed:@"paiduixinxi"] forState:UIControlStateNormal];
        [_endButton setBackgroundImage:[UIImage imageNamed:@"paiduididian"] forState:UIControlStateNormal];
        _beginPointLabel.text=@"";
        _endPointLabel.text=@"";

    }
    if (_orderType==OrderTypeBuy) {
        _beginPointLabel.text=@"购";
        _endPointLabel.text=@"收";
    }
    
    
}

-(void)setupNewView{
    _bgView = [UIView new];
    _bgView.backgroundColor = whiteLineColore;
    [self addSubview:_bgView];
    
    _orderTypeLabel = [UILabel new];
    _orderTypeLabel.textColor = mainColor;
    _orderTypeLabel.font = SmallFont(self.scale);
    [_bgView addSubview:_orderTypeLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = blackTextColor;
    _timeLabel.font = SmallFont(self.scale);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_timeLabel];
    
    _cellView = [[CellView alloc] init];
    _cellView.topline.hidden = NO;
    _cellView.bottomline.hidden = NO;
    [_bgView addSubview:_cellView];
    
    _beginButton = [UIButton new];
    [_beginButton setTitle:@"起" forState:UIControlStateNormal];
    _beginButton.titleLabel.font = Big14Font(self.scale);
    [_beginButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
    _beginButton.userInteractionEnabled = NO;
    [_beginButton setBackgroundImage:[UIImage imageNamed:@"tingdan_qidian"] forState:UIControlStateNormal];
    [_cellView addSubview:_beginButton];

    _beginPointLabel = [UILabel new];
    _beginPointLabel.textColor = blackTextColor;
    _beginPointLabel.font = DefaultFont(self.scale);
    [_cellView addSubview:_beginPointLabel];
    
    _endButton = [UIButton new];
    [_endButton setTitle:@"终" forState:UIControlStateNormal];
    [_endButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
    _endButton.titleLabel.font = Big14Font(self.scale);
    _endButton.userInteractionEnabled = NO;
    [_endButton setBackgroundImage:[UIImage imageNamed:@"tingdan_qidian"] forState:UIControlStateNormal];
    [_cellView addSubview:_endButton];
    
    _endPointLabel = [UILabel new];
    _endPointLabel.textColor = blackTextColor;
    _endPointLabel.font = DefaultFont(self.scale);
    [_cellView addSubview:_endPointLabel];
    
    _orderDecLabel = [UILabel new];
    [_bgView addSubview:_orderDecLabel];
    
    _shouYiLabel = [UILabel new];
    [_bgView addSubview:_shouYiLabel];
}
-(void)layoutSubviews{
    
    _bgView.frame = CGRectMake(RM_Padding, 0, self.width - 2*RM_Padding, self.height);
    _bgView.layer.borderWidth = 0.5;
    _bgView.layer.borderColor = blackLineColore.CGColor;
    _bgView.layer.cornerRadius = 5*self.scale;
    _bgView.clipsToBounds = YES;
    
    _orderTypeLabel.frame = CGRectMake(RM_Padding, 0, (_bgView.width-2*RM_Padding)/3, 30*self.scale);
    
    _timeLabel.frame = CGRectMake(_orderTypeLabel.right, _orderTypeLabel.top, _orderTypeLabel.width*2, _orderTypeLabel.height);
    
    _cellView.frame = CGRectMake(0, _orderTypeLabel.bottom, _bgView.width, 80*self.scale);
    
    _beginButton.frame = CGRectMake(RM_Padding, RM_Padding, 30*self.scale, 30*self.scale);
    _beginPointLabel.frame = CGRectMake(_beginButton.right, 0, _bgView.width - _beginButton.right-RM_Padding, 30*self.scale);
    
    _endButton.frame = CGRectMake(_beginButton.left, _beginButton.bottom, _beginButton.width, _beginButton.height);
    _endPointLabel.frame = CGRectMake(_endButton.right, _endButton.top, _bgView.width - _endButton.right-RM_Padding, 30*self.scale);
    
    
    _orderDecLabel.frame = CGRectMake(RM_Padding, _cellView.bottom+RM_Padding, _bgView.width - 2*RM_Padding, 20*self.scale);
    _shouYiLabel.frame = CGRectMake(_orderDecLabel.left, _orderDecLabel.bottom, _orderDecLabel.width, _orderDecLabel.height);
    
}
@end
