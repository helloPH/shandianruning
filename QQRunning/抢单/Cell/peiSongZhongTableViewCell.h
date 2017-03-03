//
//  peiSongZhongTableViewCell.h
//  QQRunning
//
//  Created by 软盟 on 2016/12/26.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "SuperTableViewCell.h"

@protocol peiSongZhongTableViewCellDelegate <NSObject>
@optional
-(void)peiSongZhongTableViewCellDelegateWithIndex:(NSIndexPath *)indexpath;
@end

@interface peiSongZhongTableViewCell : SuperTableViewCell


@property (nonatomic,strong) UIImageView * stepLineUp;
@property (nonatomic,strong) UIImageView * stepLineDown;
@property (nonatomic,strong) UIImageView *stepImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *leftStepLabel;
@property (nonatomic,strong) UILabel *stepLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIImageView *bottomLine;
@property (nonatomic,strong) UIImageView *shortLine;
@property (nonatomic,strong) UIButton *statusButton;

@property (nonatomic,assign) NSInteger statusType;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id <peiSongZhongTableViewCellDelegate> delegate;
@end
