//
//  OrderTableViewCell.h
//  QQRunning
//
//  Created by 软盟 on 2016/12/24.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "SuperTableViewCell.h"

@protocol OrderTableViewCellDelegate <NSObject>

-(void)OrderTableViewCellQiangDanWithIndex:(NSIndexPath *)indexPath;

@end

@interface OrderTableViewCell : SuperTableViewCell
@property (nonatomic,assign) OrderType orderType;


@property (nonatomic,strong) UILabel *orderTypeLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *beginPointLabel;
@property (nonatomic,strong) UILabel *endPointLabel;
@property (nonatomic,strong) UILabel *orderDecLabel;
@property (nonatomic,strong) UILabel *goodsLabel;
@property (nonatomic,strong) UILabel *beiZhuLabel;
@property (nonatomic,strong) UIButton *qiangDanButton;
@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) BOOL isQiangDan;
@property (nonatomic,weak) id <OrderTableViewCellDelegate> delegate;
@end
