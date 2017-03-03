//
//  TiXianJuLuViewController.m
//  QQRunning
//
//  Created by wdx on 2017/1/17.
//  Copyright © 2017年 软盟. All rights reserved.
//

#import "TiXianJuLuViewController.h"
#import "TiXianJiLuTableViewCell.h"

@interface TiXianJuLuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView   * tableView;
@property (nonatomic,strong)NSMutableArray* datas;
@property (nonatomic,assign)NSInteger       yeIndex;
@end

@implementation TiXianJuLuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    [self setupNewNavi];
    [self newView];
    [self reshData];
    
    // Do any additional setup after loading the view.
}
-(void)initData{
    _yeIndex=1;
    _datas=[NSMutableArray array];
}
-(void)reshData{
    NSDictionary * dic= @{@"index":@(_yeIndex),
                          @"PeiSongId":[Stockpile sharedStockpile].userID};
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getWithdrawRecordWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
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
        [self reshView];
    }];
}
-(void)reshView{
    [_tableView reloadData];
}
-(void)newView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight-self.NavImg.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [_tableView addHeardTarget:self Action:@selector(xiala)];
    [_tableView addFooterTarget:self Action:@selector(shangla)];
    
    [_tableView registerClass:[TiXianJiLuTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
}
-(void)xiala{
    _yeIndex=1;
    [self reshData];
}
-(void)shangla{
    _yeIndex++;
    [self reshData];
    
}

#pragma  mark -- tableView  delegate dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65*self.scale;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic=_datas[indexPath.row];
    TiXianJiLuTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.bottomLine.hidden=NO;
    cell.titleLabel.text=@"账户提现金额";
    cell.moneylabel.attributedText = [[NSString stringWithFormat:@"<orang20>%@</orang20><black13>元</black13>",dic[@"Money"]] attributedStringWithStyleBook:[self Style]];
    cell.timeLabel.text=[[NSString stringWithFormat:@"%@",dic[@"Time"]] getValiedString];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"账户余额";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
    //    UIButton *tiXianGuiZeButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_VWidth - self.TitleLabel.height*2, self.TitleLabel.top, self.TitleLabel.height*2, self.TitleLabel.height)];
    //    [tiXianGuiZeButton setTitleColor:blackTextColor forState:UIControlStateNormal];
    //    [tiXianGuiZeButton setTitle:@"提现规则" forState:UIControlStateNormal];
    //    tiXianGuiZeButton.titleLabel.font = Big15Font(self.scale);
    //    [tiXianGuiZeButton addTarget:self action:@selector(tiXianGuiZeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.NavImg addSubview:tiXianGuiZeButton];
}
-(void)PopVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
