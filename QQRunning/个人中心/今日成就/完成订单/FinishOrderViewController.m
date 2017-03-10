//
//  FinishOrderViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "FinishOrderViewController.h"
#import "FinishOrderTableViewCell.h"
#import "CellView.h"
//#import "OrderTableViewCell.h"
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
                           @"Type":@(_typeIndex),
                           };
    if (_chengJiutype==ChengJiuTypeToday) {
        [self startDownloadDataWithMessage:nil];
        [AnalyzeObject getTodayFinishOrderListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            
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

    }else{
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
    
    
   
    
}
-(void)newView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom , RM_VWidth, RM_VHeight-self.NavImg.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = superBackgroundColor;
    [_tableView registerClass:[FinishOrderTableViewCell class] forCellReuseIdentifier:@"cell"];
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
    NSDictionary * dic=_datas[indexPath.section];
    
    FinishOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
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
    cell.orderType=[[NSString stringWithFormat:@"%@",dic[@"Type"]] integerValue];

    
    
    cell.orderDecLabel.attributedText = [[NSString stringWithFormat:@"<gray13>路程大约</gray13><orang14>%.2f</orang14><gray13>公里，费用</gray13><orang14>%.2f</orang14><gray13>元，加价</gray13><orang14>%.2f</orang14><gray13>元</gray13>",
                                          [xingCheng floatValue],
                                          [price floatValue],
                                          [addPrice floatValue]]
                                         attributedStringWithStyleBook:[self Style]];
    
    
    cell.goodsLabel.attributedText = [[NSString stringWithFormat:@"<gray12>购买商品：</gray12><blue12>%@</blue12>",[[NSString stringWithFormat:@"%@",dic[@"GoodsName"]] getValiedString]] attributedStringWithStyleBook:[self Style]];
    if (orderTypeIndex==OrderTypeHelp || orderTypeIndex==OrderTypeQueueUp) {
        cell.goodsLabel.attributedText =  [[NSString stringWithFormat:@"<gray12>预约时间：</gray12><blue12>%@</blue12>",[[NSString stringWithFormat:@"%@",dic[@"YuYueTime"]] getValiedString]] attributedStringWithStyleBook:[self Style]];
    }
    
    
    cell.beiZhuLabel.text =[[NSString stringWithFormat:@"%@",dic[@"Desc"]] getValiedString];
    cell.beiZhuLabel.text=[NSString stringWithFormat:@"备注：%@",cell.beiZhuLabel.text];
    
    cell.backgroundColor = superBackgroundColor;
    cell.selectionStyle = 0;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = _datas[indexPath.section];
    float baseH = 190*self.scale;
    NSInteger typeIndex;
    typeIndex = [[NSString stringWithFormat:@"%@",dic[@"Type"]] integerValue];
    switch (typeIndex) {
        case 0:// 买
            baseH = 190*self.scale;
            break;
        case 1:// 送
            baseH = 165*self.scale;
            break;
        case 2:// 取
            baseH = 165*self.scale;
            break;
        case 3:// 车
            baseH = 140*self.scale;
            break;
        case 4:// 帮
            baseH = 190*self.scale;
            break;
        case 5:// 排
            baseH = 190*self.scale;
            break;
        default:
            break;
    }
    
    return baseH;
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
