//
//  OrderTableViewCell.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/24.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "CellView.h"
@interface OrderTableViewCell()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) CellView *cellView;
@property (nonatomic,strong) UIImageView *startPointImageView;
@property (nonatomic,strong) UIImageView *endPointImageView;
@property (nonatomic,strong) UILabel *startLabel;
@property (nonatomic,strong) UILabel *endLabel;
@property (nonatomic,strong) NSArray<NSString *> * orderTitles;
@end

@implementation OrderTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
        self.orderTitles=@[@"闪电买",@"闪电送",@"闪电取",@"闪电摩的",@"闪电帮",@"闪电排队"];
    }
    return self;
}
-(void)setOrderType:(OrderType)orderType{
    _orderType=orderType;
    self.orderTypeLabel.text=self.orderTitles[_orderType];
    
    
    
    _startPointImageView.image=[UIImage imageNamed:@"qidian"];
    _endPointImageView.image=[UIImage imageNamed:@"zhongdian"];
    _startLabel.text=@"起";
    _endLabel.text=@"终";
    _timeLabel.textColor= _orderType==OrderTypeBring?matchColor:grayTextColor;
    _timeLabel.text=_orderType==OrderTypeBring?@"立即送货":[self transFromDate:_timeLabel.text];
    
    
    
    if (_orderType==OrderTypeQueueUp || _orderType==OrderTypeHelp) {
        _startPointImageView.image=[UIImage imageNamed:@"paiduixinxi"];
        _endPointImageView.image=[UIImage imageNamed:@"paiduididian"];
        _startLabel.text=@"";
        _endLabel.text=@"";
    }
    if (_orderType==OrderTypeBuy) {
        _startLabel.text=@"购";
        _endLabel.text=@"收";
    }
}
-(NSString *)transFromDate:(NSString *)dateString{
    
    NSDateFormatter * formart = [NSDateFormatter new];
    formart.dateFormat=@"yyyy-MM-dd";
    NSArray * dateArr = [dateString componentsSeparatedByString:@" "];
    NSString * dateFirst = [dateArr firstObject];
    
    
    NSDate * nowDate = [NSDate date];
    NSString * nowDateString = [formart stringFromDate:nowDate];
    NSArray * nowDateArr  = [nowDateString componentsSeparatedByString:@" "];
    NSString * nowDateFirst = [nowDateArr firstObject];
    
    
    if ([dateFirst isEqualToString:nowDateFirst]) {
        NSString * String = [NSString stringWithFormat:@"今天：%@",[dateArr lastObject]];
        return String;
    }
    return dateString;
}

-(void)newView{
    _bgView = [UIView new];
    _bgView.backgroundColor = whiteLineColore;
    [self addSubview:_bgView];
    
    _orderTypeLabel = [UILabel new];
    _orderTypeLabel.textColor = mainColor;
    _orderTypeLabel.font = SmallFont(self.scale);
    [_bgView addSubview:_orderTypeLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = mainColor;
    _timeLabel.font = SmallFont(self.scale);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_timeLabel];
    
    _cellView = [[CellView alloc] init];
    _cellView.topline.hidden = NO;
    _cellView.bottomline.hidden = NO;
    [_cellView.btn removeFromSuperview];
    [_bgView addSubview:_cellView];
    
    _startPointImageView = [UIImageView new];
    _startPointImageView.image = [UIImage imageNamed:@"qidian"];
    _startPointImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_cellView addSubview:_startPointImageView];
    _startLabel = [UILabel new];
//    _startLabel.text = @"起";
    _startLabel.textAlignment = 1;
    _startLabel.textColor = whiteLineColore;
    _startLabel.font = DefaultFont(self.scale);
    [_startPointImageView addSubview:_startLabel];
    
    _endPointImageView = [UIImageView new];
    _endPointImageView.image = [UIImage imageNamed:@"zhongdian"];
    _endPointImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_cellView addSubview:_endPointImageView];
    _endLabel = [UILabel new];
//    _endLabel.text = @"终";
    _endLabel.textAlignment = 1;
    _endLabel.textColor = whiteLineColore;
    _endLabel.font = DefaultFont(self.scale);
    [_endPointImageView addSubview:_endLabel];
    
    _beginPointLabel = [UILabel new];
    _beginPointLabel.textColor = blackTextColor;
    _beginPointLabel.numberOfLines = 0;
    _beginPointLabel.font = DefaultFont(self.scale);
    [_cellView addSubview:_beginPointLabel];
    _endPointLabel = [UILabel new];
    _endPointLabel.textColor = blackTextColor;
    _endPointLabel.numberOfLines = 0;
    _endPointLabel.font = DefaultFont(self.scale);
    [_cellView addSubview:_endPointLabel];
    
    _orderDecLabel = [UILabel new];
    [_bgView addSubview:_orderDecLabel];
    
    _goodsLabel = [UILabel new];
    [_bgView addSubview:_goodsLabel];
    
    _beiZhuLabel = [UILabel new];
    _beiZhuLabel.textColor = grayTextColor;
    _beiZhuLabel.font = SmallFont(self.scale);
    [_bgView addSubview:_beiZhuLabel];
    
    _qiangDanButton = [UIButton new];
    [_qiangDanButton setTitle:@"抢单" forState:UIControlStateNormal];
    [_qiangDanButton setBackgroundColor:mainColor];
    _qiangDanButton.titleLabel.font = Big15Font(self.scale);
    [_qiangDanButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
    _qiangDanButton.layer.cornerRadius = RM_CornerRadius;
    _qiangDanButton.clipsToBounds = YES;
    [_qiangDanButton addTarget:self action:@selector(qiangDanButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_qiangDanButton];
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
    _startPointImageView.frame = CGRectMake(RM_Padding, RM_Padding, 23*self.scale, 26.5*self.scale);
    _startLabel.frame = CGRectMake(0, 2*self.scale, _startPointImageView.width, 15*self.scale);
    _beginPointLabel.frame = CGRectMake(_startPointImageView.right+RM_Padding, 0, _bgView.width - _startPointImageView.right - 2*RM_Padding, 30*self.scale);
     [_beginPointLabel sizeToFit];
    if (_beginPointLabel.height != 40*self.scale) {
        _beginPointLabel.height = 40*self.scale;
    }


    
    _endPointImageView.frame = CGRectMake(RM_Padding, _startPointImageView.bottom, _startPointImageView.width, _startPointImageView.height);
    _endLabel.frame = CGRectMake(0, _endPointImageView.height - _startLabel.height - 2*self.scale, _endPointImageView.width, _startLabel.height);
    _endPointLabel.frame = CGRectMake(_beginPointLabel.left, _beginPointLabel.bottom, _bgView.width - _endPointImageView.right - 2*RM_Padding, _beginPointLabel.height);
    [_endPointLabel sizeToFit];
    if (_endPointLabel.height != 40*self.scale) {
        _endPointLabel.height = 40*self.scale;
    }
    
    _orderDecLabel.frame = CGRectMake(RM_Padding, _cellView.bottom + RM_Padding/2, _bgView.width - RM_Padding*2, 20*self.scale);
    _goodsLabel.frame = CGRectMake(_orderDecLabel.left, _orderDecLabel.bottom, _orderDecLabel.width ,_orderDecLabel.height);
    _beiZhuLabel.frame = _goodsLabel.frame;
    
    
    if (_isQiangDan) {
        _qiangDanButton.frame = CGRectMake(_beiZhuLabel.left, _beiZhuLabel.bottom+RM_Padding/2, _beiZhuLabel.width , RM_ButtonHeight);
    }else{
        _qiangDanButton.frame = CGRectZero;
    }
    
    CGFloat setY=_orderDecLabel.bottom;
    _goodsLabel.hidden=NO;
    _beiZhuLabel.hidden=NO;
    
    if (_orderType==OrderTypeMotocycleTaxi) {
//        _qiangDanButton.top=_orderDecLabel.bottom+5*self.scale;
        _goodsLabel.hidden=YES;
        _beiZhuLabel.hidden=YES;
    }
    
    if (_orderType==OrderTypeBuy || _orderType==OrderTypeHelp || _orderType==OrderTypeQueueUp) {
        _goodsLabel.top=_orderDecLabel.bottom+RM_Padding/2;
        _beiZhuLabel.top=_goodsLabel.bottom+RM_Padding/2;
        setY=_beiZhuLabel.bottom;
    }
    if (_orderType==OrderTypeBring||_orderType==OrderTypeTake) {
        _goodsLabel.hidden=YES;
        _beiZhuLabel.top=_orderDecLabel.bottom+RM_Padding/2;
        setY=_beiZhuLabel.bottom;
    }
    _qiangDanButton.top=setY+RM_Padding;
}
-(void)qiangDanButtonEvent:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(OrderTableViewCellQiangDanWithIndex:)]) {
        [_delegate OrderTableViewCellQiangDanWithIndex:_indexPath];
    }
}
@end
