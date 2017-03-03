//
//  SettingTableViewCell.h
//  BaoJiaHuHang2
//
//  Created by apple on 15/9/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"
@protocol SettingTableViewCellDelegate <NSObject>
@optional
-(void)SettingTableViewCellSwitchIndexPath:(NSIndexPath *)indexPath;
-(void)SettingTableViewCellSwitch:(BOOL)ONOrOFF IndexPath:(NSIndexPath *)indexPath;
@end
@interface SettingTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UILabel *TitleLabel;
@property(nonatomic,strong)UILabel *ValueLabel;
@property(nonatomic,strong)UIImageView *RigthImage;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)UISwitch * kaiGuan;

@property (nonatomic,strong) UIImageView *topLine;
@property (nonatomic,strong) UIImageView *shortLine;
@property (nonatomic,strong) UIImageView *bottomLine;
@property(nonatomic,assign)id<SettingTableViewCellDelegate>delegate;
@end
