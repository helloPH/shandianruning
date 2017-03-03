//
//  XinYongJiFenViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/22.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "XinYongJiFenViewController.h"
#import "XinYongJiFenTableViewCell.h"
#import "CellView.h"
@interface XinYongJiFenViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *selectButton;
@property (nonatomic,strong) UIImageView *selectLine;


@property (nonatomic,strong) NSMutableArray * datas;
@property (nonatomic,assign) NSInteger        yeIndex;

@end

@implementation XinYongJiFenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupNewNavi];
    [self setupNewTopView];
    [self newTableView];
    [self reshData];
    
//    [self.view bringSubviewToFront:self.NavImg];
}
-(void)initData{
    _yeIndex=1;
    _datas=[NSMutableArray array];
}
-(void)reshData{
    if (_selectButton.tag-10 == 0) {// 信用明细
        NSDictionary * dic = @{@"index":@(_yeIndex),
                               @"PeiSongId":[Stockpile sharedStockpile].userID};
        
        [self startDownloadDataWithMessage:nil];
        [AnalyzeObject getJiFenDicWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopDownloadData];
            [_tableView.mj_header endRefreshing];
            if ([model count]==0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshing];
            }

            if (_yeIndex==1) {
                [_datas  removeAllObjects];
            }
            if (CODE(ret)) {
                [_datas addObject:model];
            }else{
                [CoreSVP showMessageInBottomWithMessage:msg];
            }
            [self kongShuJuWithSuperView:_tableView datas:_datas];
            [self reshView];
        }];
        
        
    }else{// 惩罚规则
        NSDictionary * dic = @{@"Flag":@"4"};
        [self startDownloadDataWithMessage:nil];

        [AnalyzeObject getAppTextWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopDownloadData];
            [_datas removeAllObjects];
            [_tableView.mj_header endRefreshing];
            if ([model count]==0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshing];
            }
            
            
            if (CODE(ret)) {
                [_datas addObjectsFromArray:@[@{@"ChengFa":model[@"Text"]}]];
            }else{
                [CoreSVP showMessageInBottomWithMessage:msg];
            }
            [self kongShuJuWithSuperView:_tableView datas:_datas];
            [self reshView];
        }];
        
        
    }
    
    

    
    
}
#pragma mark -- 界面
-(void)setupNewTopView{
    
    
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popButton];
    
    
    CellView *topBgView = [[CellView alloc] initWithFrame:CGRectMake(0,self.NavImg.bottom, RM_VWidth, 115*self.scale)];
    topBgView.bottomline.hidden = NO;
    [self.view addSubview:topBgView];
    [self.view bringSubviewToFront:popButton];
    

    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, topBgView.width, topBgView.width*0.4)];
    bgImageView.image = [UIImage imageNamed:@"bg_xinyong"];
//    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.clipsToBounds = YES;
    [topBgView addSubview:bgImageView];
    topBgView.height=bgImageView.height+40*self.scale;
    
    
    
    UILabel *xinYongZhiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, bgImageView.width, bgImageView.height)];
    xinYongZhiLabel.numberOfLines = 5;
    xinYongZhiLabel.attributedText = [[NSString stringWithFormat:@"<white18>信用值</white18>\n\n\n\n<main20>10</main20>"] attributedStringWithStyleBook:[self Style]];
    xinYongZhiLabel.textAlignment = 1;
    [bgImageView addSubview:xinYongZhiLabel];
    
    
    
    //排行规则
    CellView *cellView = [[CellView alloc] initWithFrame:CGRectMake(0, bgImageView.bottom, topBgView.width, topBgView.height - bgImageView.bottom)];
    cellView.bottomline.hidden = NO;
    [topBgView addSubview:cellView];
    
    

    float buttonWidth = (RM_VWidth -0.5)/2;
    for (int i = 0; i < 2; i ++) {
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake((buttonWidth + 0.5)*i, 0, buttonWidth, cellView.height)];
        NSString *titleStr = i == 0?@"信用值明细":@"惩罚规则";
        menuButton.tag = 10+i;
        [menuButton setTitle:titleStr forState:UIControlStateNormal];
        menuButton.titleLabel.font = Big14Font(self.scale);
        [menuButton setTitleColor:blackTextColor forState:UIControlStateNormal];
        [menuButton setTitleColor:mainColor forState:UIControlStateSelected];
        [menuButton addTarget:self action:@selector(menuButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            menuButton.selected = YES;
            _selectButton = menuButton;
        }
        UIImageView *middleLine = [[UIImageView alloc] initWithFrame:CGRectMake(menuButton.right, RM_Padding, 0.5, cellView.height - 2*RM_Padding)];
        middleLine.backgroundColor = blackLineColore;
        [cellView addSubview:middleLine];
        [cellView addSubview:menuButton];
    }
    float lineWidth = buttonWidth-90*self.scale;
    _selectLine=[[UIImageView alloc]initWithFrame:CGRectMake(_selectButton.width/2 - lineWidth/2 , cellView.height - 1, lineWidth, 1)];
    _selectLine.backgroundColor=mainColor;
    [cellView addSubview:_selectLine];
}
-(void)newTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _selectLine.superview.superview.bottom+self.NavImg.bottom, RM_VWidth, RM_VHeight - self.NavImg.bottom-115*self.scale) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = superBackgroundColor;
    _tableView.backgroundColor=clearColor;
    [_tableView registerClass:[XinYongJiFenTableViewCell class] forCellReuseIdentifier:@"cell"];
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
-(void)reshView{
    [_tableView reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
         return _datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = _datas[indexPath.row];
    
    XinYongJiFenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    cell.timeLabel.text = @"";
    cell.reasonLabel.text = [[NSString stringWithFormat:@"%@",dic[@"ChengFa"]] getValiedString];
    cell.jiFenLabel.text = [[NSString stringWithFormat:@"%@",dic[@"XiYong"]] getValiedString];
    cell.isGuiZe=_selectButton.tag-10==1?true:false;
    cell.topLine.hidden = indexPath.row != 0;
    cell.shortLine.hidden = indexPath.row == _datas.count-1;
    cell.bottomLine.hidden = !cell.shortLine.hidden;
    cell.selectionStyle = 0;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*self.scale;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RM_VWidth, RM_Padding)];
    view.backgroundColor = superBackgroundColor;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return RM_Padding;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
#pragma mark -- 点击事件
-(void)menuButtonEvent:(UIButton *)button{
    _selectButton.selected = NO;
    if (_selectButton != button) {
        _selectButton = button;
        _selectButton.selected = YES;
    }else{
       _selectButton.selected = YES;
        return;
    }

//    if (_selectButton.tag-10 == 0) {// 信用明细
//          [_tableView addHeardTarget:self Action:@selector(xiala)];
//          [_tableView addFooterTarget:self Action:@selector(shangla)];
//    }else{
//        
//        if (_tableView.mj_header) {
//            [_tableView.mj_header removeFromSuperview];
//        }
//        if (_tableView.mj_footer) {
//            [_tableView.mj_footer removeFromSuperview];
//        }
//
//
//    }
    
    
    [self xiala];
    
    
    
    
    if(button.tag == 10){
        [UIView animateWithDuration:.3 animations:^{
            _selectLine.frame = CGRectMake(_selectButton.left + 90/2*self.scale, _selectButton.bottom - 1, _selectButton.width - 90*self.scale, 1);
        }];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            _selectLine.frame = CGRectMake(_selectButton.left + 100/2*self.scale, _selectButton.bottom - 1, _selectButton.width - 100*self.scale, 1);
        }];
    }
    
    
}

#pragma mark -- 导航
-(void)setupNewNavi
{

//    self.TitleLabel.text = @"信用积分";
    self.NavImg.height=0;
    
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
