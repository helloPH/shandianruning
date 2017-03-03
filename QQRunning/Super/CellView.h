//
//  CellView.h
//  BaoJiaHuHang
//
//  Created by apple on 15/5/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellViewDelegate <NSObject>

/**这两个协议只是针对和和寓项目  不用的话可以删除*/
@optional
-(void)CellViewDelegateDeleteButtonEvent:(NSInteger)index;
-(void)CellViewDelegateStateButtonEvent:(NSInteger)index;

@end

@interface CellView : UIView
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *RightImg;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,assign)BOOL shotLine;
@property(nonatomic,strong)UIImageView *topline;
@property(nonatomic,strong)UIImageView *bottomline;
@property(nonatomic,strong)UIButton *btn;
-(void)ShowRight:(BOOL)show;
//-(void)setHiddenLine:(BOOL)hidden;

/**一下属性只是针对和和寓项目  不用的话可以删除*/
@property (nonatomic,strong) UILabel *qianYueTimeLabel;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UIButton *stateButton;
@property (nonatomic,weak) id<CellViewDelegate> delegate;
@end
