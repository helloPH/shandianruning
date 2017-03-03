//
//  MessageViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "MessageDetailsViewController.h"
@interface MessageViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong)NSMutableArray * datas;
@property (nonatomic,assign)NSInteger yeIndex;
@end

@implementation MessageViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    [self setupNewNavi];
    [self newTableView];
    [self reshData];
}
#pragma mark -- 界面
-(void)initData{
    _yeIndex=1;
    _datas=[NSMutableArray array];
}
-(void)reshData{
    NSDictionary  * dic = @{@"index":@(_yeIndex),
                            @"Flag":@"0"};
    
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getMessageListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        [_tableView.mj_header endRefreshing];
        if ([model count]==0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer endRefreshing];
        }
        
        if (_yeIndex==1) {
            [_datas removeAllObjects];
        }
        if (CODE(ret)) {
            [_datas addObjectsFromArray:model];
            
        }else{
            [CoreSVP showMessageInCenterWithMessage:msg];
        }
        [self kongShuJuWithSuperView:_tableView datas:_datas];
        [_tableView reloadData];
    }];
    
}
-(void)newTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight - self.NavImg.bottom)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = superBackgroundColor;
    [_tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    [_tableView addHeardTarget:self Action:@selector(xiala)];
    [_tableView addFooterTarget:self Action:@selector(shangla)];
}
-(void)xiala{
    _yeIndex=1;
    [self reshData];
}
-(void)shangla{
    _yeIndex++;
    [self reshData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = _datas[indexPath.row];
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.topLine.hidden = indexPath.row != 0;
    cell.shortLine.hidden = indexPath.row == _datas.count-1;
    cell.bottomLine.hidden = !cell.shortLine.hidden;
    cell.selectionStyle = 0;
    
    
    
    cell.titleLabel.text = [[NSString stringWithFormat:@"%@",dic[@"Title"]] getValiedString];
    cell.contentLabel.text = [[NSString stringWithFormat:@"%@",dic[@"ContentSub"]] getValiedString];
    cell.timeLabel.text = [[NSString stringWithFormat:@"%@",dic[@"Time"]] getValiedString];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = _datas[indexPath.row];
    
    MessageDetailsViewController *detailsVC = [MessageDetailsViewController new];
    detailsVC.msgId=[NSString stringWithFormat:@"%@",dic[@"Id"]];
    [self.navigationController pushViewController:detailsVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*self.scale;
}
#pragma mark -- 左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self ShowOKAndCancleAlertWithTitle:nil Message:@"是否要删除该条消息" WithOKButtonTitle:@"确定" WithCancleButtonTitle:@"取消" OKBlcok:^{
        [CoreSVP showMessageInCenterWithMessage:@"点击了确定"];
    } CanleBlock:^{
        [CoreSVP showMessageInCenterWithMessage:@"点击了取消"];
    }];
}

#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"消息通知";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
}
-(void)PopVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    if (_block) {
        _block();
    }
    
}

@end
