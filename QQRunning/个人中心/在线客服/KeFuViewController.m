//
//  KeFuViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "KeFuViewController.h"
#import "KeFuTableViewCell.h"
@interface KeFuViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation KeFuViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupNewNavi];
    [self newTableView];
}
#pragma mark -- 界面
-(void)newTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight - self.NavImg.bottom)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = superBackgroundColor;
    [_tableView registerClass:[KeFuTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KeFuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.headImageView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"personal_touxiang"]];
    cell.nameLabel.text = @"我是客服小秋~";
    cell.decLabel.text = @"很高兴为您服务";
    cell.topLine.hidden = indexPath.row != 0;
    cell.shortLine.hidden = indexPath.row == 9;
    cell.bottomLine.hidden = !cell.shortLine.hidden;
    cell.selectionStyle = 0;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*self.scale;
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"在线客服";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
}
-(void)PopVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
