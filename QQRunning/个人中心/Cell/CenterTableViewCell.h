//
//  CenterTableViewCell.h
//  任务
//
//  Created by 软盟 on 16/1/26.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface CenterTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *HeaderImage;//左边icon
@property(nonatomic,strong)UILabel *NameLabel;//标题
@property(nonatomic,strong)UIImageView *StateImage;
@property(nonatomic,strong)UILabel *StateLabel;
@property(nonatomic,assign)BOOL ISOK;
@property(nonatomic,strong)UIImageView *TopLine;
@property (nonatomic,strong) UIImageView *shortLine;
@property(nonatomic,strong)UIImageView *BottomLine;
@property(nonatomic,strong)UIImageView *RigthImage;
@property(nonatomic,strong)UIImageView *RedPoint;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)UILabel     *spLabel;
@property(nonatomic,strong)UIImageView *topImage;
@property(nonatomic,assign)NSInteger biaoji;


@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,assign) BOOL isFenRun;
@end
