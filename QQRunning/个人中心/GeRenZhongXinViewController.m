//
//  GeRenZhongXinViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/20.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "GeRenZhongXinViewController.h"
#import "CenterTableViewCell.h"
#import "SettingViewContrller.h"
#import "YouJiangTuiJianViewController.h"
#import "ZhangHuYuEViewController.h"
#import "RongYuBangViewController.h"
#import "KeFuViewController.h"
#import "QQClassViewContoller.h"
#import "MessageViewController.h"
#import "XinYongJiFenViewController.h"
#import "TodayChengJiuViewController.h"
#import "ShenFenRenZhengViewController.h"
#import "MyBankCardViewController.h"
#import "CExpandHeader.h"
#import "CellView.h"
@interface GeRenZhongXinViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *pictureArray;
//所达成的成就
@property (nonatomic,strong) NSArray *achievementTitleArray;
@property (nonatomic,strong) NSArray *achievementPictureArray;
@property (nonatomic,assign) BOOL isFirstAppear;
@property (nonatomic,strong) CExpandHeader *expandHeader;


@property (nonatomic,assign)CGFloat ceWidth;
@property (nonatomic,strong)UIButton * ceView;
@end
@implementation GeRenZhongXinViewController
#pragma mark  ----  懒加载
-(NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"我的账户",@"银行卡",@"荣誉榜",@"闪电课堂",@"我要邀请",@"在线客服",@"系统设置"];
    }
    return _titleArray;
}
-(NSArray *)pictureArray{
    if (!_pictureArray) {
        _pictureArray = @[@"gr_01",@"gr_02",@"gr_03",@"gr_04",@"gr_05",@"gr_06",@"gr_07"];
    }
    return _pictureArray;
}
-(NSArray *)achievementTitleArray{
    if (!_achievementTitleArray) {
        
        _achievementTitleArray = @[[NSString stringWithFormat:@"今日成就\n%@",[Stockpile sharedStockpile].userTodayOrderNum],
                                   [NSString stringWithFormat:@"累计成就\n%@",[Stockpile sharedStockpile].userAllOrderNum],
                                   [NSString stringWithFormat:@"信用积分\n%@",[Stockpile sharedStockpile].userJiFen]
                                   ];
    }
    return _achievementTitleArray;
}
-(NSArray *)achievementPictureArray{
    if (!_achievementPictureArray) {
        _achievementPictureArray = @[@"personal_icon01",@"personal_icon02",@"personal_icon03"];
    }
    return _achievementPictureArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isFirstAppear) {
        _tableView.contentOffset = CGPointMake(0, -210*self.scale);
    }
    _isFirstAppear = YES;
   
}
#pragma mark --  刷新数据
-(void)reshData{
    NSDictionary * dic=@{@"Phone":[Stockpile sharedStockpile].userAccount,@"Pwd":[Stockpile sharedStockpile].userPassword};
    
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject loginWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        
        if (CODE(ret)) {
            [self TapNextViewWith:model];
        }else{
            
        }
        [self reshView];
        
    }];
}
-(void)TapNextViewWith:(id)models
{
#pragma mark -------------------------------------- 账号信息
    [[Stockpile sharedStockpile] setIsRead:[[NSString stringWithFormat:@"%@",[models objectForKey:@"IsRead"]] isEqualToString:@"0"]];
    
    //  用户 资料 和 地理资料
    [[Stockpile sharedStockpile] setDefaultAddressId:[NSString stringWithFormat:@"%@",[models objectForKey:@"CityId"]]];
    [[Stockpile sharedStockpile] setUserID:[NSString stringWithFormat:@"%@",[models objectForKey:@"PeiSongId"]]];
    [[Stockpile sharedStockpile] setUserRealName:[NSString stringWithFormat:@"%@",[models objectForKey:@"Name"]]];
    [[Stockpile sharedStockpile] setUserLogo:[NSString stringWithFormat:@"%@",[models objectForKey:@"Image"]]];
    [[Stockpile sharedStockpile] setUserPhone:[NSString stringWithFormat:@"%@",[models objectForKey:@"Phone"]]];
    
    
    //   账户 情况
    [[Stockpile sharedStockpile] setUserYuE:[NSString stringWithFormat:@"%@",[models objectForKey:@"AllMoney"]]];
    [[Stockpile sharedStockpile] setUserRank:[NSString stringWithFormat:@"%@",[models objectForKey:@"XingJi"]]];
    [[Stockpile sharedStockpile] setUserJiFen:[NSString stringWithFormat:@"%@",[models objectForKey:@"Jifen"]]];
    
    
    
    [[Stockpile sharedStockpile] setUserStatus:[[NSString stringWithFormat:@"%@",[models objectForKey:@"Status"]] integerValue]];
    [[Stockpile sharedStockpile] setIsWork:[[NSString stringWithFormat:@"%@",[models objectForKey:@"OnOff"]] boolValue]];
    
    //银行信息
    [[Stockpile sharedStockpile] setDefaultBankName:@""];
    [[Stockpile sharedStockpile] setDefaultBankCardNum:@""];
    [[Stockpile sharedStockpile] setDefaultBankCardKind:@""];
    
    // 订单情况
    // 总的
    [[Stockpile sharedStockpile] setUserAllOrderNum:[NSString stringWithFormat:@"%@",[models objectForKey:@"AllOrder"]]];
    [[Stockpile sharedStockpile] setUserAllTiCheng:[NSString stringWithFormat:@"%@",[models objectForKey:@"AllTiCheng"]]];
    [[Stockpile sharedStockpile] setUserAllJieDanJinE:[NSString stringWithFormat:@"%@",[models objectForKey:@"AllMoney"]]];
    [[Stockpile sharedStockpile] setUserAllJuLi:[NSString stringWithFormat:@"%@",[models objectForKey:@"AllJuLi"]]];
    
    // 今日
    [[Stockpile sharedStockpile] setUserTodayOrderNum:[NSString stringWithFormat:@"%@",[models objectForKey:@"DayOrderNum"]]];
    [[Stockpile sharedStockpile] setUserTodayShouYi:[NSString stringWithFormat:@"%@",[models objectForKey:@"DayOrderShouYi"]]];
    [[Stockpile sharedStockpile] setUserTodayLiCheng:[NSString stringWithFormat:@"%@",[models objectForKey:@"DayOrderLiCheng"]]];
    
    
}

-(void)reshView{ //  刷新界面 进行赋值
    UIImageView * tiShiImg = [self.view viewWithTag:777];
    tiShiImg.hidden=[Stockpile sharedStockpile].isRead;
    
    UIImageView * headImg;//  头像
    headImg=[self.view viewWithTag:100];
    [headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgDuanKou,[Stockpile sharedStockpile].userLogo]] placeholderImage:[UIImage imageNamed:@"sy_touxiang"]];
    
    UIView * starView; // 星星视图
    starView=[self.view viewWithTag:200];
    starView = [self yongHuPingJiaStarCount:[[Stockpile sharedStockpile].userRank intValue] WithSuperView:starView];
    starView.hidden=[Stockpile sharedStockpile].userStatus!=3;
    
    UILabel * labelGonghao; ///工号
    NSString * gongHao;
    
    switch ([Stockpile sharedStockpile].userStatus) {
        case 0://资料正在申请中
        {
            gongHao = @"(正在认证中)";
        }
            break;
        case 1://申请成功（请前往闪电培训课堂）
        {
            gongHao = @"认证成功（请前往闪电培训课堂）";
        }
            break;
        case 2://资料申请失败
        {
            gongHao = @"认证失败";
        }
            break;
        case 3://培训签约成功（可以正常接单）
        {
            gongHao = [NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].userID];
        }
            break;
        case 4:// 注册成功,还未提交申请
        {
            gongHao = @"(未提交认证)";
        }
            break;
        default:
            break;
    }

    
    
    labelGonghao=[self.view viewWithTag:300];
    labelGonghao.text=[NSString stringWithFormat:@"工号：%@",gongHao];
    UIButton * btnJiRi; /// 今日成就
    btnJiRi=[self.view viewWithTag:10];
    [btnJiRi setTitle:[NSString stringWithFormat:@"今日成就\n%@",[Stockpile sharedStockpile].userTodayOrderNum] forState:UIControlStateNormal];
    
    
    UIButton * btnLeiJi;  /// 累积成就
    btnLeiJi=[self.view viewWithTag:11];
    [btnLeiJi setTitle:[NSString stringWithFormat:@"累计成就\n%@",[Stockpile sharedStockpile].userAllOrderNum] forState:UIControlStateNormal];
    
    
    UIButton * btnJiFen; // 信用积分
    btnJiFen=[self.view viewWithTag:12];
    [btnJiFen setTitle:[NSString stringWithFormat:@"信用积分\n%@",[Stockpile sharedStockpile].userJiFen] forState:UIControlStateNormal];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newView];
    [self setupNewNavi];
    [self newTableView];
    [self newTableHeaderV];
    [self reshView];
}
#pragma mark -- 界面
-(void)initData{
    _ceWidth=RM_VWidth - 60*self.scale;
}
-(void)activeChange{
    if (self.view.left==0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.left=-RM_VWidth;
            _ceView.alpha=0.0;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.view.left=0;
            _ceView.alpha=1;
        }completion:^(BOOL finished) {
            [self reshData];
        }];
    }
}
-(void)newView{
    _ceView=[[UIButton alloc]initWithFrame:CGRectMake(_ceWidth, 0, RM_VWidth-_ceWidth, RM_VHeight)];
    self.view.backgroundColor=clearColor;
    [self.view addSubview:_ceView];
    _ceView.backgroundColor=[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.5];

    [_ceView addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)newTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, _ceWidth, RM_VHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor = superBackgroundColor;
    [self.view addSubview:_tableView];
}
//-(void)xiala{
////    [self reshData];
//}
- (void)newTableHeaderV{
    UIButton *messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(_ceWidth - self.TitleLabel.height , self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [messageBtn setImage:[UIImage imageNamed:@"sy_xiaoxi"] forState:UIControlStateNormal];
    //    [settingButton setImage:[UIImage imageNamed:@"personal_shezhi"] forState:UIControlStateHighlighted];
    [messageBtn addTarget:self action:@selector(settingButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:messageBtn];
    
    
    
    UIImageView *yellowPoint = [[UIImageView alloc] initWithFrame:CGRectMake(messageBtn.right - RM_Padding, messageBtn.top+RM_Padding, 6*self.scale, 6*self.scale)];
    yellowPoint.backgroundColor = [UIColor whiteColor];
    yellowPoint.layer.cornerRadius = 3*self.scale;
    yellowPoint.clipsToBounds = YES;
    [self.view addSubview:yellowPoint];
    yellowPoint.tag=777;

    //顶部视图
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _ceWidth, 240*self.scale)];
//    topImageView.image = [UIImage imageNamed:@"xinyong_bj"];
    topImageView.image=[UIImage ImageForColor:mainColor];
    topImageView.tag = 1000;
    topImageView.userInteractionEnabled = YES;
    //头像视图
    UIImageView *touXiangImgV = [[UIImageView alloc] initWithFrame:CGRectMake(_ceWidth/2 - 30*self.scale, messageBtn.bottom+RM_Padding, 60*self.scale, 60*self.scale)];
//    NSString * logo=[NSString stringWithFormat:@"%@%@",ImgDuanKou,[Stockpile sharedStockpile].userLogo];
    
//    [touXiangImgV setImageWithURL:[NSURL URLWithString:logo] placeholderImage:[UIImage imageNamed:@"sy_touxiang"]];
    touXiangImgV.tag = 100;
    touXiangImgV.clipsToBounds = YES;
    touXiangImgV.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    touXiangImgV.layer.cornerRadius = touXiangImgV.width/2;
    touXiangImgV.userInteractionEnabled = YES;
    touXiangImgV.layer.borderWidth=2*self.scale;
    touXiangImgV.layer.borderColor=[UIColor whiteColor].CGColor;
    
    //添加点击事件
    UITapGestureRecognizer *tapGsp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoGeRenZiLiao:)];
    tapGsp.numberOfTouchesRequired = 1;//出发时需要的触点数
    tapGsp.numberOfTapsRequired = 1;//需要点击的次数
    [touXiangImgV addGestureRecognizer:tapGsp];
    [topImageView addSubview:touXiangImgV];
//    //认证状态
//    UIButton *renZhengStatusButton = [[UIButton alloc] initWithFrame:CGRectMake(_ceWidth/2 - touXiangImgV.width/2, touXiangImgV.bottom + RM_Padding, touXiangImgV.width, 20*self.scale)];
//    [renZhengStatusButton setTitle:@"预约培训" forState:UIControlStateNormal];
//    [renZhengStatusButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
//    renZhengStatusButton.titleLabel.font = SmallFont(self.scale);
//    renZhengStatusButton.backgroundColor = orangeTextColor;
//    renZhengStatusButton.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
//    renZhengStatusButton.layer.cornerRadius = 3*self.scale;
//    renZhengStatusButton.clipsToBounds = YES;
//    [renZhengStatusButton addTarget:self action:@selector(renZhengStausButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [topImageView addSubview:renZhengStatusButton];
    //星级
    UIView *starView = [[UIView alloc] initWithFrame:CGRectMake(0, touXiangImgV.bottom + RM_Padding, topImageView.width, 20*self.scale)];
    starView.backgroundColor = clearColor;
    starView.tag=200;
    starView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
//    [self yongHuPingJiaStarCount:[[Stockpile sharedStockpile].userRank intValue] WithSuperView:starView];
    [topImageView addSubview:starView];
    
    
    //工号
    UILabel *gongHaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, starView.bottom, _ceWidth, 20*self.scale)];
//    gongHaoLabel.text = [NSString stringWithFormat:@"工号：%@",[Stockpile sharedStockpile].userID];
    gongHaoLabel.font = DefaultFont(self.scale);
    gongHaoLabel.textAlignment = 1;
    gongHaoLabel.textColor = whiteLineColore;
    gongHaoLabel.backgroundColor = clearColor;
    gongHaoLabel.tag = 300;
    gongHaoLabel.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [topImageView addSubview:gongHaoLabel];
//    if (![Stockpile sharedStockpile].isApprove) {
//        gongHaoLabel.top=starView.top;
//        starView.hidden=YES;
//        gongHaoLabel.text= @"工号：(未提交认证)";
//    }
    
    
    //底部按钮
    CellView *whiteBgView = [[CellView alloc] initWithFrame:CGRectMake(0, topImageView.bottom-40*self.scale, _ceWidth, 40*self.scale)];
    whiteBgView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    whiteBgView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [topImageView addSubview:whiteBgView];
    float setX = 0;
    float buttonWidth = (_ceWidth - 0.5*(self.achievementTitleArray.count-1))/self.achievementTitleArray.count;
    for (int i = 0; i < self.achievementTitleArray.count; i ++) {
        //成就按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(setX, 0, buttonWidth, whiteBgView.height-0.5)];
        [button setTitle:self.achievementTitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:whiteLineColore forState:UIControlStateNormal];
         button.titleLabel.font = SmallFont(self.scale);
        button.titleLabel.numberOfLines=2;
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
//        [button setImage:[UIImage imageNamed:self.achievementPictureArray[i]] forState:UIControlStateNormal];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(achievementButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [button TiaoZhengButtonWithOffsit:5*self.scale TextImageSite:0];
        [whiteBgView addSubview:button];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(button.right, RM_Padding, 0.5, whiteBgView.height - 0.5-RM_Padding*2)];
        line.backgroundColor = blackLineColore;
        [whiteBgView addSubview:line];
        setX = button.right + 0.5;
        
    }
//        whiteBgView.hidden=NO;
    topImageView.height=whiteBgView.bottom;//
    _expandHeader = [CExpandHeader expandWithScrollView:self.tableView expandView:topImageView];
}
#pragma mark -- 星星
/**
 *  这个方法是返回的星星视图
 *
 *  @param count     星星数量
 *  @param superView 星星视图所在的父视图
 *
 *  @return 返回星星视图
 */
-(UIView *)yongHuPingJiaStarCount:(int)count WithSuperView:(UIView *)superView
{
    float starImageWith = 24/2.25*self.scale;//星星图片的宽度
    float starViewWidth = starImageWith*count + 5*self.scale*(count - 1);//所有星星视图的宽度
    UIView *starView = [[UIView alloc] initWithFrame:CGRectMake((superView.width - starViewWidth)/2, 0, starViewWidth, superView.height)];
    starView.backgroundColor = clearColor;
    [superView addSubview:starView];
    for (int i = 0; i < count; i ++) {
        UIImageView *starImage = [[UIImageView alloc] initWithFrame:CGRectMake((starImageWith+5*self.scale) * i, (starView.height - starImageWith)/2, starImageWith, starImageWith)];
        starImage.image = [UIImage imageNamed:@"gr_xingjipng"];
        [starView addSubview:starImage];
    }
    return starView;
}
#pragma mark -- tableView的代理事件
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CenterTableViewCell *cell = [[CenterTableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.RigthImage.right=_ceWidth-10*self.scale;
    cell.shortLine.hidden = indexPath.row == [self.titleArray count]-1;
    cell.BottomLine.hidden = !cell.shortLine.hidden;
    if (indexPath.row == 0) {
        cell.TopLine.hidden = NO;
    }
//    CellView
    cell.HeaderImage.image = [UIImage imageNamed:[self.pictureArray objectAtIndex:indexPath.row]];
    cell.NameLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            //账户余额
            ZhangHuYuEViewController *accountVC = [ZhangHuYuEViewController new];
            [self.navigationController pushViewController:accountVC animated:YES];
            break;
        }
        case 1:
        {
            //银行卡
            MyBankCardViewController *bankcardVC = [MyBankCardViewController new];
            [self.navigationController pushViewController:bankcardVC animated:YES];
            break;
        }
        case 2:
        {
            //荣誉榜
            RongYuBangViewController *rongYuVC = [RongYuBangViewController new];
            [self.navigationController pushViewController:rongYuVC animated:YES];
            break;
        }
        case 3:
        {
            //秋秋课堂
            QQClassViewContoller *qqClassVC = [QQClassViewContoller new];
            [self.navigationController pushViewController:qqClassVC animated:YES];
            break;
        }
        case 4:
        {
            //有奖推荐
            YouJiangTuiJianViewController *tuiJianVC = [YouJiangTuiJianViewController new];
            [self.navigationController pushViewController:tuiJianVC animated:YES];
            break;

        }
        case 5:
        {
            
            
            //在线客服
            
          
            
      
//                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqString]]];
                    NSDictionary * dic = @{@"Flag":@"3"};
                    [self startDownloadDataWithMessage:nil];
                    [AnalyzeObject getAppSetParamterWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                        [self stopDownloadData];
                        if (CODE(ret)) {
                            NSString * qqString = [NSString stringWithFormat:@"%@",model[@"Value"]];
                            [self ShowAlertTitle:@"是否联系在线客服?" Message:qqString Delegate:self OKText:@"确定" CancelText:@"取消" Block:^(NSInteger index) {
                                if (index == 1) {
                                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqString]] options:@{} completionHandler:^(BOOL success) {
                                        if (!success) {
                                            [CoreSVP showMessageInCenterWithMessage:@"打开QQ失败"];
                                        }
                                    }];
                                }
                            }];
                        }else{
                            [CoreSVP showMessageInCenterWithMessage:msg];
                        };
                        
                
                    
                    
             
                
            }];


            break;

        }
        case 6:
        {
//            //消息通知
//            MessageViewController *messageVC = [MessageViewController new];
//            [self.navigationController pushViewController:messageVC animated:YES];
            SettingViewContrller *settingVC = [[SettingViewContrller alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
            
            
            
            break;
        }
        
        default:
            break;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RM_VWidth, RM_Padding)];
    view.backgroundColor = superBackgroundColor;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RM_CellHeigth;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return RM_Padding;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
#pragma mark -- 按钮点击事件
//身份认证
-(void)renZhengStausButtonEvent:(UIButton *)button{
    ShenFenRenZhengViewController *personCenter = [ShenFenRenZhengViewController new];
    [self.navigationController pushViewController:personCenter animated:YES];
}
//设置
-(void)settingButtonEvent:(UIButton *)button{
    //消息通知
    MessageViewController *messageVC = [MessageViewController new];
    messageVC.block=^(){
        [self reshData];
    };
    [self.navigationController pushViewController:messageVC animated:YES];
}
//个人资料
- (void)gotoGeRenZiLiao:(UITapGestureRecognizer *)ShouShi{
   [self judgeStatus];
    
}
-(BOOL)judgeStatus{
    if ([Stockpile sharedStockpile].userStatus==0) {//可以正常接单
        [self ShowOKAlertWithTitle:@"提示" Message:@"资料正在审核中！" WithButtonTitle:@"确定" Blcok:^{
        }];
        return NO;
    };
    if([Stockpile sharedStockpile].userStatus==1){
        [self ShowOKAlertWithTitle:@"提示" Message:@"资料审核通过（请前往闪电培训课堂）！" WithButtonTitle:@"确定" Blcok:^{
        }];
        return NO;
    }
    
    if ([Stockpile sharedStockpile].userStatus==2) {//资料申请失败
        [self ShowAlertTitle:@"提示" Message:@"资料审核失败，是否重新申请" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                ShenFenRenZhengViewController * renZheng = [[ShenFenRenZhengViewController alloc]init];
                renZheng.ID=[Stockpile sharedStockpile].userID;
                renZheng.biaoJi=1;
                self.navigationController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:renZheng animated:YES];
                self.navigationController.hidesBottomBarWhenPushed=NO;
            };
        }];
        return NO;
    }
    if ([Stockpile sharedStockpile].userStatus==4) {//注册成功，未申请
        [self ShowAlertTitle:@"提示" Message:@"还未提交资料，是否申请？" Delegate:self Block:^(NSInteger index) {
            if (index==1) {
                ShenFenRenZhengViewController * renZheng = [[ShenFenRenZhengViewController alloc]init];
                renZheng.ID=[Stockpile sharedStockpile].userID;
                renZheng.biaoJi=1;
                self.navigationController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:renZheng animated:YES];
                self.navigationController.hidesBottomBarWhenPushed=NO;
            };
        }];
        return NO;
    }
    if ([Stockpile sharedStockpile].userStatus==3) {
            return YES;
    }
    return NO;
}

-(void)achievementButtonEvent:(UIButton *)button{
    if (![self judgeStatus]) {
        return;
    }
    
    if (button.tag == 10) {
        //今日成就
        TodayChengJiuViewController *todayVC = [TodayChengJiuViewController new];
        todayVC.type = ChengJiuTypeToday;
        [self.navigationController pushViewController:todayVC animated:YES];
    }else if (button.tag == 11){
        //累计成就
        TodayChengJiuViewController *todayVC = [TodayChengJiuViewController new];
        todayVC.type = ChengJiuTypeAll;
        [self.navigationController pushViewController:todayVC animated:YES];
    }else{
        //信用积分
        XinYongJiFenViewController *jiFenVC = [XinYongJiFenViewController new];
        [self.navigationController pushViewController:jiFenVC animated:YES];
    }
}
#pragma mark -- 导航
-(void)setupNewNavi
{
//    self.NavImg.width=_ceWidth;
    self.NavImg.height=0;
    self.TitleLabel.text = @"个人中心";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_VWidth - self.TitleLabel.height , self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [settingButton setImage:[UIImage imageNamed:@"personal_shezhi"] forState:UIControlStateNormal];
    [settingButton setImage:[UIImage imageNamed:@"personal_shezhi"] forState:UIControlStateHighlighted];
    [settingButton addTarget:self action:@selector(settingButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:settingButton];
    

}
-(void)PopVC:(id)sender{
    [self activeChange];
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
