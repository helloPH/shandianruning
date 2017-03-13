//
//  RongYuBangViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/21.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "RongYuBangViewController.h"
#import "CellView.h"
#import "RongYuBangTableViewCell.h"
@interface RongYuBangViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *selectButton;
@property (nonatomic,strong) UIButton *selectTimeButton;//按时间筛选
@property (nonatomic,strong) UIImageView *selectLine;


@property (nonatomic,strong)UIImageView * headImg;
@property (nonatomic,strong)UILabel     * labelName;
@property (nonatomic,strong)UILabel     * labelContent;



@property (nonatomic,strong)NSMutableArray * datas;
@property (nonatomic,strong)NSMutableDictionary * dataDic;
@end

@implementation RongYuBangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    [self setupNewNavi];
    [self setupNewTableView];
//    [self reshView];
    [self reshData];
}
-(void)initData{
    _datas=[NSMutableArray array];
    _dataDic=[NSMutableDictionary dictionary];
}
-(void)reshData{
    NSDictionary * dic = @{@"PeiSongId":[Stockpile sharedStockpile].userID};
    
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getRongYuBangListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        [_dataDic removeAllObjects];
        [_datas removeAllObjects];
        if (CODE(ret)) {
            _dataDic = model;
            _datas = _dataDic[@"List"];
         }else{
             msg = @"没有更多数据!";
             [CoreSVP showMessageInCenterWithMessage:msg];
        }
        [self reshView];
    }];
}
-(void)reshView{
       [_headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgDuanKou,_dataDic[@"Image"]]] placeholderImage:[UIImage imageNamed:@"sy_touxiang"]];
    _labelName.text=[Stockpile sharedStockpile].userPhone;
        _labelContent.attributedText = [[NSString stringWithFormat:@"<white12>当前排名：</white12><white14>%@</white14><white12>名</white12>      <white12>累计订单：</white12><white14>%@</white14><white12>个</white12>",[NSString stringWithFormat:@"%@",_dataDic[@"PaiMing"]],[NSString stringWithFormat:@"%@",_dataDic[@"AllOrder"]]] attributedStringWithStyleBook:[self Style]];
       [_tableView reloadData];
}
#pragma mark -- 界面
//-(void)setupNewView{
//    
//    //排行规则
//    CellView *topView = [[CellView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, 40*self.scale)];
//    topView.bottomline.hidden = NO;
//    [self.view addSubview:topView];
//    
//    float buttonWidth = (RM_VWidth -0.5)/2;
//    for (int i = 0; i < 2; i ++) {
//        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake((buttonWidth + 0.5)*i, 0, buttonWidth, topView.height)];
//        NSString *titleStr = i == 0?@"好友排行榜":@"收入排行榜";
//        [menuButton setTitle:titleStr forState:UIControlStateNormal];
//        menuButton.titleLabel.font = Big14Font(self.scale);
//        [menuButton setTitleColor:blackTextColor forState:UIControlStateNormal];
//        [menuButton setTitleColor:matchColor forState:UIControlStateSelected];
//        [menuButton addTarget:self action:@selector(menuButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//        if (i == 0) {
//            menuButton.selected = YES;
//            _selectButton = menuButton;
//        }
//        UIImageView *middleLine = [[UIImageView alloc] initWithFrame:CGRectMake(menuButton.right, RM_Padding, 0.5, topView.height - 2*RM_Padding)];
//        middleLine.backgroundColor = blackLineColore;
//        [topView addSubview:middleLine];
//        [topView addSubview:menuButton];
//    }
//    float lineWidth = buttonWidth-90*self.scale;
//    _selectLine=[[UIImageView alloc]initWithFrame:CGRectMake(_selectButton.width/2 - lineWidth/2 , topView.height - 1, lineWidth, 1)];
//    _selectLine.backgroundColor=matchColor;
//    [topView addSubview:_selectLine];
//    
//    //按时间排行
//    float timeButtonWidth = 260/2.25*self.scale;
//    float blankWidth = (RM_VWidth - 2*timeButtonWidth)/3;
//    float setX = blankWidth;
//    for (int i = 0; i < 2; i ++) {
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(setX, topView.bottom + RM_Padding, timeButtonWidth, 60/2.25*self.scale)];
//        [button setBackgroundImage:[UIImage imageNamed:@"rongyu_btn02"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"rongyu_btn01"] forState:UIControlStateSelected];
//        NSString *titleStr = i == 0?@"近7天排行":@"近30天排行";
//        [button setTitle:titleStr forState:UIControlStateNormal];
//        button.titleLabel.font = Big14Font(self.scale);
//        [button setTitleColor:whiteLineColore forState:UIControlStateSelected];
//        [button setTitleColor:grayTextColor forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(timeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:button];
//        if (i == 0) {
//            button.selected = YES;
//            _selectTimeButton = button;
//        }
//        setX = button.right + blankWidth;
//    }
//    
//    topView.height=0;
//    _selectTimeButton.height=0;
//    //创建表格
//
//}
-(void)setupNewTableView{
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom + RM_Padding, RM_VWidth, 160/2.25*self.scale)];
    bgImageView.image = [UIImage imageNamed:@"zhanghu_bg"];
    [self.view addSubview:bgImageView];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(RM_Padding, RM_Padding, bgImageView.height - RM_Padding*2, bgImageView.height - RM_Padding*2)];
//    headImageView.layer.cornerRadius = headImageView.width/2;
//    headImageView.clipsToBounds = YES;
    [bgImageView addSubview:headImageView];
    _headImg=headImageView;
     [_headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgDuanKou,_dataDic[@"Image"]]] placeholderImage:[UIImage imageNamed:@"sy_touxiang"]];
    
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.right + RM_Padding, RM_Padding, bgImageView.width - headImageView.right - RM_Padding, headImageView.height/2.0)];
    phoneLabel.text = [Stockpile sharedStockpile].userPhone;
    phoneLabel.tag = 10;
    phoneLabel.textColor = whiteLineColore;
    phoneLabel.font = SmallFont(self.scale);
    [bgImageView addSubview:phoneLabel];
    _labelName=phoneLabel;
    
    
    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(phoneLabel.left, phoneLabel.bottom, phoneLabel.width, phoneLabel.height)];
    contentlabel.tag = 20;
    contentlabel.attributedText = [[NSString stringWithFormat:@"<white12>当前排名：</white12><white14>%@</white14><white12>名</white12>      <white12>累计好评：</white12><white14>%@</white14><white12>个</white12>",@"35",@"3"] attributedStringWithStyleBook:[self Style]];
    [bgImageView addSubview:contentlabel];
    _labelContent=contentlabel;
    
    
    

    
    CellView * bottomCell=[[CellView alloc]initWithFrame:CGRectMake(0, bgImageView.bottom+10*self.scale, RM_VWidth, 40*self.scale)];
    [self.view addSubview:bottomCell];
    
    
    
    UIImageView * letfSep=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 2, bottomCell.height)];
    letfSep.backgroundColor=mainColor;
    [bottomCell addSubview:letfSep];
    
    bottomCell.titleLabel.text=@"跑男订单排行榜";
    [bottomCell.titleLabel sizeToFit];
    bottomCell.titleLabel.left=10*self.scale;
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, bottomCell.bottom, self.view.width, RM_VHeight - bottomCell.bottom) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = superBackgroundColor;
    [_tableView registerClass:[RongYuBangTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    

    
}
#pragma mark -- tableView的代理事件
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _datas[indexPath.row];
    RongYuBangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = 0;
    [cell.headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgDuanKou,dic[@"Image"]]] placeholderImage:[UIImage imageNamed:@"sy_touxiang"]];
    cell.nickNamelabel.text = [[NSString stringWithFormat:@"%@",dic[@"Name"]] getValiedString];
    
    NSString * peiid=[[NSString stringWithFormat:@"%@",dic[@"PeiSongId"]] getValiedString];
    cell.contentLabel.text = [NSString stringWithFormat:@"工号：%@",peiid];
    cell.rankLabel.textColor = grayTextColor;
    cell.rankLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    
    NSString * allOrder=[[NSString stringWithFormat:@"%@",dic[@"AllOrder"]] getValiedString];
    cell.moneyLabel.attributedText = [[NSString stringWithFormat:@"<main20>%@</main20><gray13>个</gray13>",allOrder] attributedStringWithStyleBook:[self Style]];
    if ([cell.rankLabel.text integerValue] < 4) {
   
        cell.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"no%ld",[cell.rankLabel.text integerValue]]];
        cell.rankLabel.text=@"";
    }else{
        cell.leftImageView.image=[UIImage ImageForColor:clearColor];
    }
    cell.topLine.hidden = indexPath.row != 0;
    cell.shortLine.hidden = indexPath.row == 9;
    cell.bottomLine.hidden = !cell.shortLine.hidden;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*self.scale;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RM_VWidth, RM_Padding)];
    view.backgroundColor = superBackgroundColor;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
#pragma mark -- 点击事件
-(void)menuButtonEvent:(UIButton *)button{
    _selectButton.selected = NO;
    if (_selectButton != button) {
        _selectButton = button;
    }
    _selectButton.selected = YES;
    [UIView animateWithDuration:.3 animations:^{
         _selectLine.frame = CGRectMake(_selectButton.left + 90/2*self.scale, _selectButton.bottom - 1, _selectButton.width - 90*self.scale, 1);
    }];

}
-(void)timeButtonEvent:(UIButton *)button{
    _selectTimeButton.selected = NO;
    if (_selectTimeButton != button) {
        _selectTimeButton = button;
    }
    _selectTimeButton.selected = YES;
}
#pragma mark -- 导航
-(void)setupNewNavi
{
    self.TitleLabel.text = @"荣誉榜";
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
