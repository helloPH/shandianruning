//
//  FinishOrderViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "FinishOrderViewController.h"
//#import "FinishOrderTableViewCell.h"
#import "CellView.h"
#import "OrderTableViewCell.h"
#import "OrderDetailsViewController.h"

@interface FinishOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArray;


@property (nonatomic,strong) NSMutableArray * datas;
@property (nonatomic,assign) NSInteger yeIndex;
@property (nonatomic,assign) NSInteger typeIndex;
//选择分类视图
@property (nonatomic,strong) UIControl *maskControl;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,assign) BOOL isZhanKai;//是否显示展开的数据
@end

@implementation FinishOrderViewController
-(NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"全部订单",@"闪电买",@"闪电送",@"闪电取",@"闪电摩的",@"代排队",@"闪电帮"];
    }
    return _titleArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupNewNavi];
    [self newView];
    [self reshData];
}
#pragma mark -- 界面
-(void)initData{
    _yeIndex=1;
    _typeIndex=6;
    _datas=[NSMutableArray array];
}
-(void)reshData{
    NSDictionary * dic = @{@"PeiSongId":[Stockpile sharedStockpile].userID,
                           @"index":@(_yeIndex),
                           @"Type":@(_typeIndex)};
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getFinishOrderListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        
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
-(void)newView{
//    CellView *topView = [[CellView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, 40*self.scale)];
//    topView.bottomline.hidden = NO;
//    [self.view addSubview:topView];
//    //全部订单
//    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(RM_Padding, topView.height/2 - 31/2.25/2*self.scale, 27/2.25*self.scale, 31/2.25*self.scale)];
//    leftImageView.image = [UIImage imageNamed:@"personal_dingdan_icon01"];
//    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [topView addSubview:leftImageView];
//    
//    UILabel *allOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftImageView.right+RM_Padding, 0, 100*self.scale, topView.height)];
//    allOrderLabel.text = @"全部订单";
//    allOrderLabel.tag = 20;
//    allOrderLabel.font = Big14Font(self.scale);
//    [topView addSubview:allOrderLabel];
//    
//    UIButton *chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_VWidth - 70*self.scale, topView.height/2 - 15*self.scale, 60*self.scale, 30*self.scale)];
//    [chooseButton setImage:[UIImage imageNamed:@"personal_dingdan_icon02"] forState:UIControlStateNormal];
//    [chooseButton setImage:[UIImage imageNamed:@"personal_dingdan_icon02"] forState:UIControlStateHighlighted];
//    [chooseButton setTitle:@"筛选" forState:UIControlStateNormal];
//    chooseButton.titleLabel.font = Big14Font(self.scale);
//    [chooseButton TiaoZhengButtonWithOffsit:7*self.scale TextImageSite:0];
//    [chooseButton addTarget:self action:@selector(chooseButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [chooseButton setTitleColor:blackTextColor forState:UIControlStateNormal];
//    [topView addSubview:chooseButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom , RM_VWidth, RM_VHeight-self.NavImg.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = superBackgroundColor;
    [_tableView registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"cell"];
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
#pragma mark -- TableView的代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = _datas[indexPath.section];
    
    OrderTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = superBackgroundColor;
//    cell.orderTypeLabel.text = @"代我送";
    cell.timeLabel.text = [[NSString stringWithFormat:@"%@",dic[@"QiangTime"]] getValiedString];
    cell.beginPointLabel.text = [[NSString stringWithFormat:@"%@",dic[@"QIAddress"]] getValiedString];
    cell.endPointLabel.text = [[NSString stringWithFormat:@"%@",dic[@"ZhongAddress"]] getValiedString];
    
    
    
    NSInteger  orderTypeIndex = [[[NSString stringWithFormat:@"%@",dic[@"Type"]] getValiedString] integerValue];
    NSString * xingCheng = @"";
    NSString * price = [[NSString stringWithFormat:@"%@",dic[@"Money"]] getValiedString];
    NSString * addPrice = [[NSString stringWithFormat:@"%@",dic[@"AddMoney"]] getValiedString];
    if (orderTypeIndex==0 || orderTypeIndex==1 || orderTypeIndex==2 || orderTypeIndex==3) {  /// 买送取 摩的
        xingCheng = [[NSString stringWithFormat:@"%@",dic[@"SongJuLi"]] getValiedString];
    }else{
        xingCheng = [[NSString stringWithFormat:@"%@",dic[@"QuJuLi"]] getValiedString];
    }
    if (orderTypeIndex==5 || orderTypeIndex==4) {
        cell.beginPointLabel.text = [[NSString stringWithFormat:@"%@",dic[@"BangXinxi"]] getValiedString];
        cell.endPointLabel.text = [[NSString stringWithFormat:@"%@",dic[@"QIAddress"]] getValiedString];
    }
    
    cell.orderDecLabel.attributedText =[[NSString stringWithFormat:@"<gray12>路程大约%@公里，费用</gray12><orang14>%@</orang14><gray12>元，加价</gray12><orang14>%@</orang14><gray12>元</gray12>",xingCheng,price,addPrice] attributedStringWithStyleBook:[self Style]];
    cell.goodsLabel.attributedText = [[NSString stringWithFormat:@"<gray12>获得收益：</gray12><orang14>%@</orang14><gray12>元</gray12>",[[NSString stringWithFormat:@"%@",dic[@"Money"]] getValiedString]] attributedStringWithStyleBook:[self Style]];
    
//    cell.beiZhuLabel.text = @"备注：";
    
    cell.orderType=[[NSString stringWithFormat:@"%@",dic[@"Type"]] integerValue];
    cell.selectionStyle = 0;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170*self.scale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return RM_Padding;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RM_VWidth, RM_Padding)];
    bgView.backgroundColor = superBackgroundColor;
    return bgView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = _datas[indexPath.section];
    
    OrderDetailsViewController *orderDetailsVC = [OrderDetailsViewController new];
    orderDetailsVC.orderType=[[NSString stringWithFormat:@"%@",dic[@"Type"]]integerValue];
    orderDetailsVC.orderId=[NSString stringWithFormat:@"%@",dic[@"OrderId"]];
//    orderDetailsVC.dataDic=dic;
    [self.navigationController pushViewController:orderDetailsVC animated:YES];
    
}
#pragma mark -- 筛选事件
-(void)chooseButtonEvent:(UIButton *)button{
    if (_isZhanKai) {
        [self dismissViewEvent];
        return;
    }
    _maskControl = [[UIControl alloc] initWithFrame:CGRectMake(0,self.NavImg.bottom , RM_VWidth, RM_VHeight - (self.NavImg.bottom))];
    _maskControl.clipsToBounds = YES;
    _maskControl.backgroundColor = clearColor;
    [_maskControl addTarget:self action:@selector(dismissViewEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_maskControl];
 
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, -40*self.scale*self.titleArray.count, _maskControl.width, 40*self.scale*self.titleArray.count)];
    [_maskControl addSubview:_maskView];
    float setY = 0;
    for (int i = 0; i < self.titleArray.count; i ++ ) {
        //完成订单的类型
        CellView *cellView = [[CellView alloc] initWithFrame:CGRectMake(0, setY, _maskControl.width, 40*self.scale)];
        cellView.titleLabel.text = self.titleArray[i];
        [cellView setShotLine:i != self.titleArray.count - 1 ];
        [_maskView addSubview:cellView];
        cellView.titleLabel.textColor=i==[self serverToViewType:_typeIndex]?mainColor:blackTextColor;
//        cellView.titleLabel.textColor=i==_typeIndex-1?mainColor:blackTextColor;
    
        
        UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, cellView.width, cellView.height)];
        button.backgroundColor = clearColor;
        button.tag = 10 + i;
        [button addTarget:self action:@selector(chooseOrderTypeEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:button];
        setY = cellView.bottom;
    }
    _isZhanKai = YES;
    [UIView animateWithDuration:.3 animations:^{
        _maskControl.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _maskView.frame = CGRectMake(0, 0, _maskControl.width, setY);
    }];

}



-(NSInteger)serverToViewType:(NSInteger)typeIndex{
    NSInteger afterIndex = 0;
    if (typeIndex==6) {// 把  服务器的接口的 与 界面的显示顺序相对应
        afterIndex=0;
    }else{
        afterIndex=typeIndex+1;
    }
    return afterIndex;
}
-(NSInteger)viewToServerType:(NSInteger)typeIndex{
    NSInteger afterIndex = 6;
    if (typeIndex==0) {// 把  界面现实的顺序 与 服务器接口类型的表示相一致
        afterIndex=6;
    }else{
        afterIndex=typeIndex-1;
    }
    return afterIndex;
}
-(void)dismissViewEvent{
    if (!_isZhanKai) {
        return;
    }
    _isZhanKai = !_isZhanKai;
    [UIView animateWithDuration:.3 animations:^{
        _maskView.frame = CGRectMake(0, -40*self.scale*self.titleArray.count, _maskControl.width, 0);
        _maskControl.backgroundColor=clearColor;
    }completion:^(BOOL finished) {
        
        [_maskControl removeFromSuperview];
        _maskControl=nil;
        
    }];
}
#pragma mark -- 选择订单类型事件
-(void)chooseOrderTypeEvent:(UIButton *)button{
    [self dismissViewEvent];
    UILabel *orderLabel = (UILabel *)[self.view viewWithTag:300];
    orderLabel.text = self.titleArray[button.tag - 10];
    _typeIndex=[self viewToServerType:button.tag-10];
    _yeIndex=1;
    [self reshData];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewEvent];
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"完成订单";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
    UIButton *saiButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_VWidth - self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [saiButton setTitle:@"筛选" forState:UIControlStateNormal];
    [saiButton setTitleColor:blackTextColor forState:UIControlStateNormal];
    saiButton.titleLabel.font = Big15Font(self.scale);
    [saiButton addTarget:self action:@selector(chooseButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:saiButton];
}
-(void)PopVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
