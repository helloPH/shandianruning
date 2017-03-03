//
//  QieHuanCityViewController.m
//  SJSD
//
//  Created by 软盟 on 16/4/26.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "QieHuanCityViewController.h"
#import "QieHuanRegionViewController.h"



static NSString *cityIdentifier = @"cityIdentifier";
@interface QieHuanCityViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *cityArray;

@property (nonatomic,strong) QieHuanRegionViewController *regionVC;

@end

@implementation QieHuanCityViewController
-(void)viewDidLoad
{
    [super viewDidLoad];

    _cityArray = [NSMutableArray array];
    [self setupNavi];
    [self setupTableView];
    
    [self downloadCityData];
}
#pragma mark -- 加载数据
-(void)downloadCityData

{
    NSDictionary * dic=@{};
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getProvinceListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        
         [_cityArray removeAllObjects];
        if (CODE(ret)) {
            [_cityArray addObjectsFromArray:model];
            [_tableView reloadData];
        }else{
            [CoreSVP showMessageInCenterWithMessage:@"获取失败"];
        }
    }];
    

}
-(void)setupNavi{
    self.NavImg.width=self.view.width-44*self.scale;
    self.TitleLabel.centerX=self.NavImg.width/2;
    self.TitleLabel.text=@"开通省份";
}

-(void)setupTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale, self.view.width, self.view.height-self.NavImg.height-10*self.scale)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cityIdentifier];
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cityArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _cityArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    cell.textLabel.font = DefaultFont(self.scale);
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//       NSDictionary *dic = _cityArray[indexPath.row];
//       NSString * city = dic[@"name"];

//        [self.view removeFromSuperview];
//        if (_block) {
//            _block(city);
//        }
    
        
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_regionVC) {
            
            _regionVC.view.left = self.view.width;
            
        }else{
            
            _regionVC = [[QieHuanRegionViewController alloc] init];
            _regionVC.ID = [NSString stringWithFormat:@"%@",_cityArray[indexPath.row][@"id"]];
            _regionVC.dic = _cityArray[indexPath.row];
            [self.view addSubview:_regionVC.view];
            _regionVC.view.left = self.view.width;
            
        }
        
        [UIView animateWithDuration:.3 animations:^{
            
            _regionVC.view.left = 0;
            
            
        }];
        
        
    });
}
@end
