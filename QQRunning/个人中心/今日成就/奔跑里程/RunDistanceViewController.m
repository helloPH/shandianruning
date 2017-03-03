//
//  RunDistanceViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "RunDistanceViewController.h"
#import "ShouYiAndLiChengTableViewCell.h"
#import "CellView.h"
#import "OrderDetailsViewController.h"

@interface RunDistanceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *starTimeButton;
@property (nonatomic,strong) UIButton *endTimeButton;
@property (nonatomic,assign) BOOL isStartTime;
//选择日期
@property (nonatomic,strong) UIControl *dateControl;
@property (nonatomic,strong) UIView *dateBgView;
@property (nonatomic,strong) UIDatePicker *datePicker;


@property (nonatomic,assign) NSInteger yeIndex;
@property (nonatomic,strong) NSMutableArray * datas;

@end

@implementation RunDistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupNewNavi];
    [self setupTopView];
    [self setupNewTableView];
    
    [self reshData];
    
}
-(void)setupTopView{
    //获取当前时间
    //指定时间的输出格式
    
    /// 今天
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *strDate = [formatter stringFromDate:date];
    
    //  昨天
    NSDate * yestoday = [date dateByAddingTimeInterval:-60*60*24];
    NSString * strDateYestoday = [formatter stringFromDate:yestoday];
    
    // 2000
    NSString * strDateLongago = @"2000-01-01";
    
    
    
    
    CellView *topView = [[CellView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, 40*self.scale)];
    topView.backgroundColor = superBackgroundColor;
    [self.view addSubview:topView];
    //开始时间
    _starTimeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100*self.scale, topView.height)];
    [_starTimeButton setTitle:strDateYestoday forState:UIControlStateNormal];
    [_starTimeButton setTitleColor:blackTextColor forState:UIControlStateNormal];
    _starTimeButton.titleLabel.font = Big15Font(self.scale);
    _starTimeButton.tag = 10;
    [_starTimeButton addTarget:self action:@selector(chooseTimeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_starTimeButton];
    
    
    //结束时间
    _endTimeButton = [[UIButton alloc] initWithFrame:CGRectMake(topView.right - _starTimeButton.width, 0,_starTimeButton.width, topView.height)];
    _endTimeButton.tag = 11;
    [_endTimeButton setTitle:strDate forState:UIControlStateNormal];
    [_endTimeButton setTitleColor:blackTextColor forState:UIControlStateNormal];
    _endTimeButton.titleLabel.font = Big15Font(self.scale);
    [_endTimeButton addTarget:self action:@selector(chooseTimeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_endTimeButton];
    //描述Label
    UILabel *decLabel = [[UILabel alloc] initWithFrame:CGRectMake(_starTimeButton.right, 0, _endTimeButton.left - _starTimeButton.right, topView.height)];
    decLabel.text = @"至";
    decLabel.font = DefaultFont(self.scale);
    decLabel.textColor = grayTextColor;
    decLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:decLabel];
}

#pragma mark -- 数据
-(void)initData{
    _yeIndex=1;
    _datas=[NSMutableArray array];
}
-(void)reshData{
    NSDictionary * dic = @{@"index":@(_yeIndex),
                           @"Type":@"6",
                           @"StartTime":[[NSString stringWithFormat:@"%@",_starTimeButton.titleLabel.text]getValiedString],
                           @"EndTime":[[NSString stringWithFormat:@"%@",_endTimeButton.titleLabel.text] getValiedString]};
   
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getBenPaoLiChengAndShouYiWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
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
#pragma mark -- 界面
-(void)setupNewTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.NavImg.bottom+40*self.scale , RM_VWidth, RM_VHeight - RM_NavHeigth-40*self.scale)];
 
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.NavImg.bottom , RM_VWidth, RM_VHeight - RM_NavHeigth)];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = superBackgroundColor;
    [_tableView registerClass:[ShouYiAndLiChengTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView addHeardTarget:self Action:@selector(xiala)];
    [_tableView addFooterTarget:self Action:@selector(shangla)];

    [self.view addSubview:_tableView];
//    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth, 40*self.scale)];
//    _tableView.tableHeaderView=label;
//    label.text=@"2016-11-30";
    
    
}
-(void)xiala{
    _yeIndex=1;
    [self reshData];
}
-(void)shangla{
    _yeIndex++;
    [self reshData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = _datas[indexPath.row];
    
    ShouYiAndLiChengTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.timeLabel.text = [[NSString stringWithFormat:@"%@",dic[@"QiangTime"]] getValiedString];
    NSString * orderNum=[NSString stringWithFormat:@"%@",dic[@"OrderId"]];
    cell.orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@",orderNum];
    
    NSString * liCheng=[NSString stringWithFormat:@"%@",dic[@"QuJuLi"]];
    liCheng = [liCheng stringByReplacingOccurrencesOfString:@"km" withString:@""];
    cell.orderDistanceLabel.attributedText = [[NSString stringWithFormat:@"<black13>订单里程</black13><orang15>%@</orang15><black13>公里</black13>",[NSString stringWithFormat:@"%@",liCheng]] attributedStringWithStyleBook:[self Style]];
    
    
    
    cell.topLine.hidden = indexPath.row != 0;
    cell.shortLine.hidden = indexPath.row == _datas.count-1;
    cell.bottomLine.hidden = !cell.shortLine.hidden;
    cell.selectionStyle = 0;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*self.scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = _datas[indexPath.row];
    
    OrderDetailsViewController *orderDetailsVC = [OrderDetailsViewController new];
    orderDetailsVC.orderType=[[NSString stringWithFormat:@"%@",dic[@"Type"]]integerValue];
    orderDetailsVC.orderId=[NSString stringWithFormat:@"%@",dic[@"OrderId"]];
    [self.navigationController pushViewController:orderDetailsVC animated:YES];
    
}
#pragma mark -- 点击事件
//选择时间
-(void)chooseTimeButtonEvent:(UIButton *)button{
    _isStartTime = button.tag == 10;
    _dateControl = [[UIControl alloc]initWithFrame:self.view.bounds];
    _dateControl.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [_dateControl addTarget:self action:@selector(dismissViewEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dateControl];
    [self datePickerView];
    [UIView animateWithDuration:.3 animations:^{
        _dateControl.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _dateBgView.bottom=RM_VHeight;
    }];
}
#pragma mark -- 选择日期
-(void)datePickerView{
    _dateBgView=[[UIView alloc]initWithFrame:CGRectMake(0, RM_VHeight, RM_VWidth, 300*self.scale)];
    _dateBgView.backgroundColor = whiteLineColore;
    
    CellView *topMenueBgView = [[CellView alloc] initWithFrame:CGRectMake(0, 0, _dateBgView.width, 40*self.scale)];
    topMenueBgView.backgroundColor = whiteLineColore;
    topMenueBgView.topline.hidden = NO;
    topMenueBgView.bottomline.hidden = YES;
    [_dateBgView addSubview:topMenueBgView];
    
    //取消按钮
    UIButton *cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_Padding, 0, 50*self.scale, topMenueBgView.height)];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:grayTextColor forState:UIControlStateNormal];
    cancleButton.titleLabel.font=DefaultFont(self.scale);
    [cancleButton addTarget:self action:@selector(dismissViewEvent) forControlEvents:UIControlEventTouchUpInside];
    [topMenueBgView addSubview:cancleButton];
    //确定按钮
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(topMenueBgView.width - cancleButton.width - RM_Padding, 0, cancleButton.width , topMenueBgView.height)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    confirmButton.tag = 20;
    [confirmButton setTitleColor:mainColor forState:UIControlStateNormal];
    confirmButton.titleLabel.font=DefaultFont(self.scale);
    [confirmButton addTarget:self action:@selector(confirmButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [topMenueBgView addSubview:confirmButton];
    //描述Label
    UILabel *decLabel = [[UILabel alloc] initWithFrame:CGRectMake(cancleButton.right, 0, confirmButton.left - cancleButton.right, topMenueBgView.height)];
    decLabel.text = @"选择日期";
    decLabel.font = DefaultFont(self.scale);
    decLabel.textColor = grayTextColor;
    decLabel.textAlignment = NSTextAlignmentCenter;
    [topMenueBgView addSubview:decLabel];
    //日期选择视图
    _datePicker = [ [ UIDatePicker alloc]initWithFrame:CGRectMake(0, topMenueBgView.height, _dateBgView.width, 200*self.scale)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    _datePicker.date = [NSDate date];
    _datePicker.backgroundColor=whiteLineColore;
    _datePicker.maximumDate = [NSDate date];
    [_dateBgView addSubview:_datePicker];
    _dateBgView.height = _datePicker.height + topMenueBgView.height;
    [_dateControl addSubview:_dateBgView];
}
-(void)dismissViewEvent{
    [UIView animateWithDuration:.3 animations:^{
        _dateControl.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _dateBgView.top=RM_VHeight;
    }completion:^(BOOL finished) {
        [_dateControl removeFromSuperview];
        _dateControl=nil;
        [_dateBgView removeFromSuperview];
        _dateBgView = nil;
    }];
}
-(void)confirmButtonEvent:(UIButton *)button{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormate stringFromDate:_datePicker.date];
    if (_isStartTime) {
        [_starTimeButton setTitle:timeStr forState:UIControlStateNormal];
    }else{
        [_endTimeButton setTitle:timeStr forState:UIControlStateNormal];
    }
    [self dismissViewEvent];
    
    [self xiala];
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"奔跑里程";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
    UIButton *chooseTimeButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_VWidth - self.TitleLabel.height*2, self.TitleLabel.top, self.TitleLabel.height*2, self.TitleLabel.height)];
    [chooseTimeButton setTitleColor:blackTextColor forState:UIControlStateNormal];
    [chooseTimeButton setTitle:@"选择日期" forState:UIControlStateNormal];
    chooseTimeButton.titleLabel.font = Big15Font(self.scale);
    [chooseTimeButton addTarget:self action:@selector(chooseTimeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    chooseTimeButton.hidden = _chengJiutype == ChengJiuTypeToday;
    chooseTimeButton.hidden=NO;
    [self.NavImg addSubview:chooseTimeButton];
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
