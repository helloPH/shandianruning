//
//  QieHuanRegionViewController.m
//  SJSD
//
//  Created by 软盟 on 16/4/26.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "QieHuanRegionViewController.h"

static NSString *regionIdentifier = @"regionIdentifier";
@interface QieHuanRegionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *regionArray;
@end

@implementation QieHuanRegionViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.NavImg.hidden = YES;
    _regionArray = [[NSMutableArray alloc] init];
    [self setupTableView];
    [self downloadRegionData];
}
#pragma mark -- 加载数据
-(void)downloadRegionData
{
    NSDictionary * dic=@{@"pid":_ID};
    
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getCityListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        [_regionArray removeAllObjects];
        if (CODE(ret)) {
            [_regionArray addObjectsFromArray:model];
            [_tableView reloadData];
        }else{
            [CoreSVP showMessageInBottomWithMessage:msg];
        }
    }];
    
}
-(void)setupTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height-20)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _regionArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _regionArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:regionIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:regionIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    cell.textLabel.font = DefaultFont(self.scale);
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNotification *notification =[NSNotification notificationWithName:@"QuYuTongZhi" object:self.dic userInfo:_regionArray[indexPath.row]];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    
}
@end
