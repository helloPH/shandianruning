//
//  ShouYeViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/23.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "ShouYeViewController.h"
#import "GeRenZhongXinViewController.h"
#import "OrderTableViewCell.h"
#import "CellView.h"
#import "UnFinishOrderDetailsViewController.h"
#import "TongSongShiShiOrderViewController.h"
#import "MessageViewController.h"
#import "BaiDuMapLocationManager.h"

#import "PHTabbar.h"
#import "orderDaoHangViewController.h"
#import "ShenFenRenZhengViewController.h"
#import "KuaiCheViewController.h"
#import "UILabel+Helper.h"

@interface ShouYeViewController()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,OrderTableViewCellDelegate,TongSongShiShiOrderViewControllerDelegate>


//视图
@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) UITableView *qiangDanTableView;
@property (nonatomic,strong) UITableView *unFinishTableView;

//@property (nonatomic,strong) NSMutableDictionary * userInfo;

@property (nonatomic,strong) NSMutableArray * qiangDanDatas;
@property (nonatomic,assign) NSInteger        qiangTypeIndex;
@property (nonatomic,assign) NSInteger        qiangDanYe;



@property (nonatomic,strong) NSMutableArray * unFinishDatas;
@property (nonatomic,assign) NSInteger        unFinishTypeIndex;
@property (nonatomic,assign) NSInteger        unFinishYe;

@property (nonatomic,strong) GeRenZhongXinViewController * personCenter;
//上方选择按钮
@property (nonatomic,strong) NSArray *menuTitleArray;
@property (nonatomic,strong) UIButton *selectButton;//选中按钮
@property (nonatomic,strong) UIImageView *selectLine;//选中按钮下边黄线
//当前日期
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *week;
@property (nonatomic,strong) NSArray *weekArray;
//地位地址
@property (nonatomic,strong) UIView * paoMa;

@property (nonatomic,assign) NSInteger scrollViewIndex;//3个订单状态视图的序号
@property (nonatomic,strong) TongSongShiShiOrderViewController *shiShiOrderVC;
//选择分类视图
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) UIControl *maskControl;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,assign) BOOL isZhanKai;//是否显示展开的数据
@property (nonatomic,strong) NSTimer * upLoadLocationTimer;


@property (nonatomic,strong) UIButton * unApproView;

@end

@implementation ShouYeViewController
-(NSArray *)menuTitleArray{
    if (!_menuTitleArray) {
        _menuTitleArray = @[@"实时订单",@"未抢订单",@"待完成"];
    }
    return _menuTitleArray;
}
-(NSArray *)weekArray{
    if (!_weekArray) {
        _weekArray = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    }
    return _weekArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self notificationResh];
    
//    [self panDuanRotation];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    [self setupNewNavi];
    [self setupMainScrollView];
    //实时订单界面
    [self currentTimeOrderView];
    //未抢单列表
    [self weiQiangDanListView];
    //待完成列表
    [self uncompleteOrderView];
    //获取当前日期和星期
    [self getCurrentDateAndWeek];
    //获取位置信息
    [self StartLocation];
    
    [self newView];
    [self reshRealOrderView];
    
    [self upLoadLocationTimerStart];
    
    
     [self.appdelegate chongZhiBadge];
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationResh) name:@"judgeStartRotation" object:nil];
}
-(void)notificationResh{
    [self reshRealOrderView];
    [self refreshAddressInfomation];
}
-(void)upLoadLocationTimerStart{
    _upLoadLocationTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(reshLocationData) userInfo:nil repeats:YES];
}
-(void)uploadLocation{ // 上传位置信息
    NSDictionary * dic = @{@"longtitude":[Stockpile sharedStockpile].longitude,
                           @"latitude":[Stockpile sharedStockpile].latitude,
                           @"PeiSongId":[Stockpile sharedStockpile].userID};
    if ([Stockpile sharedStockpile].isWork && [Stockpile sharedStockpile].userStatus==3) {
        [AnalyzeObject uploadLocationWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        }];
    }
}
-(void)jumpToRenZheng{ // 跳到认证界面
    [self ShowAlertTitle:@"提示" Message:@"您还未认证，请先认证" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            ShenFenRenZhengViewController * renzheng = [ShenFenRenZhengViewController new];
            renzheng.block=^(){
                [self reshRealData];
            };
            [self.navigationController pushViewController:renzheng animated:YES];
            [_unApproView removeFromSuperview];
        }
    }];

}
#pragma mark --  刷新数据
-(void)reshRealData{
    NSDictionary * dic=@{@"Phone":[Stockpile sharedStockpile].userAccount,@"Pwd":[Stockpile sharedStockpile].userPassword};
    
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject loginWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        
        if (CODE(ret)) {
            [self TapNextViewWith:model];
        }else{
            
        }
        [self reshRealOrderView];
        
    }];
}
-(void)TapNextViewWith:(id)models{
#pragma mark -------------------------------------- 账号信息
    //  用户 资料 和 地理资料
    
    
    [[Stockpile sharedStockpile] setIsRead:[[NSString stringWithFormat:@"%@",[models objectForKey:@"IsRead"]] isEqualToString:@"0"]];
    
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
-(void)reshDataIsQianged:(BOOL)isQianged{
    if (isQianged) {
        /// 加载待完成数据
        NSDictionary * dic = @{@"index":@(_unFinishYe),
                               @"Type":@(_unFinishTypeIndex),
                               @"PeiSongId":[Stockpile sharedStockpile].userID};
        [self startDownloadDataWithMessage:nil];
        [AnalyzeObject getunFinishOrderListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopDownloadData];
            
            [_unFinishTableView.mj_header endRefreshing];
            if ([model count]==0) {
                [_unFinishTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_unFinishTableView.mj_footer endRefreshing];
            }
            
            
            if (_unFinishYe==1) {
                [_unFinishDatas removeAllObjects];
            }
            if (CODE(ret)) {
                [_unFinishDatas addObjectsFromArray:model];
            }else{
                [CoreSVP showMessageInCenterWithMessage:msg];
            }
            [self kongShuJuWithSuperView:_unFinishTableView datas:_unFinishDatas];
            [_unFinishTableView reloadData];
        }];
    }else{
        ///// 加载未抢  数据
        
        NSDictionary * dic = @{@"index":@(_qiangDanYe),
                               @"Type":@(_qiangTypeIndex),
                               @"Flag":@"0"
                               };
        
        [self startDownloadDataWithMessage:nil];
        [AnalyzeObject getunQiangOrderListWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopDownloadData];
            
            
            [_qiangDanTableView.mj_header endRefreshing];
            if ([model count]==0) {
                [_qiangDanTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_qiangDanTableView.mj_footer endRefreshing];
            }
            
            
            if (_qiangDanYe==1) {
                [_qiangDanDatas removeAllObjects];
            }
            if (CODE(ret)) {
                [_qiangDanDatas addObjectsFromArray:model];
                NSLog(@"%@",_qiangDanDatas);
            }else{
                [CoreSVP showMessageInCenterWithMessage:msg];
            }
            [self kongShuJuWithSuperView:_qiangDanTableView datas:_qiangDanDatas];
            [_qiangDanTableView reloadData];
        }];
        
    }
}

-(void)reshRealOrderView{

    UIImageView * tiShiImg = [self.NavImg viewWithTag:777];
    tiShiImg.hidden=[Stockpile sharedStockpile].isRead;
    
    [self getCurrentDateAndWeek];
    UIImageView * headImg = [self.view viewWithTag:201];
    
    [headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgDuanKou,[Stockpile sharedStockpile].userLogo]] placeholderImage:[UIImage imageNamed:@"sy_touxiang"]];
 
    
    UILabel * labelPhone = [self.view viewWithTag:202];
    labelPhone.text = [Stockpile sharedStockpile].userPhone;
    
    UILabel * labelTodayNum = [self.view viewWithTag:203];
    labelTodayNum.attributedText = [[NSString stringWithFormat:@"<main20>%@</main20>\n\n<black15>今日完成</black15>",[Stockpile sharedStockpile].userTodayOrderNum] attributedStringWithStyleBook:[self Style]];
    
    UILabel * labelTodayShouYi = [self.view viewWithTag:204];
    labelTodayShouYi.attributedText = [[NSString stringWithFormat:@"<main20>%.2f</main20>\n\n<black14>今日收益</black14>",[[Stockpile sharedStockpile].userTodayShouYi floatValue]] attributedStringWithStyleBook:[self Style]];
    
    NSDictionary * dic = @{@"Flag":@"7"};
    [AnalyzeObject getAppSetParamterWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        if (CODE(ret)) {
            UILabel * label =[_mainScrollView viewWithTag:110];
            label.text = [NSString stringWithFormat:@"推荐跑男可赚%@元",model[@"Value"]];
        }else{
            
        }
    }];
    dic =   @{@"Flag":@"8"};
    [AnalyzeObject getAppSetParamterWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        if (CODE(ret)) {
            UILabel * label =[_mainScrollView viewWithTag:111];
            label.text = [NSString stringWithFormat:@"推荐用户可赚%@元",model[@"Value"]];
        }else{
            
        }
    }];
    
    if ([Stockpile sharedStockpile].userStatus!=3) {
        return;
    }
//    if (![self judgeStatus]) {
//        return;
//    }
    if ([Stockpile sharedStockpile].isWork) {
        [self startQiangDan];
       
    }else{
        [self endQiangDan];
    }
    
}
-(void)initData{
//    _userInfo = [NSMutableDictionary dictionary];

    _qiangDanYe=1;
    _qiangTypeIndex=6;
    _qiangDanDatas=[NSMutableArray array];
    
    _unFinishYe=1;
    _unFinishTypeIndex=6;
    _unFinishDatas=[NSMutableArray array];

}
#pragma mark -------------------------------------------   界面    ---------------------
#pragma mark -- 主界面

-(void)newView{
    _personCenter = [GeRenZhongXinViewController new];
    [self addChildViewController:_personCenter];
    
    [self.view addSubview:_personCenter.view];
    _personCenter.view.right=0;
}

-(void)setupMainScrollView{
    _mainScrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight - self.NavImg.bottom)];
    _mainScrollView.tag = 1000;
    _mainScrollView.contentSize = CGSizeMake(RM_VWidth*3, RM_VHeight - self.NavImg.bottom);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_mainScrollView];
}
#pragma mark -- 实时订单界面
-(void)currentTimeOrderView{
    UIImageView * jianBianView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth, 20)];
    [_mainScrollView addSubview:jianBianView];

    
    
    CellView *topView = [[CellView alloc] initWithFrame:CGRectMake(0, 0, _mainScrollView.width, 40*self.scale)];
    topView.backgroundColor=clearColor;
    topView.bottomline.hidden=YES;
    [_mainScrollView addSubview:topView];
    //左边图片
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(RM_Padding, topView.height/2 - 40/2.25*self.scale/2, 40/2.25*self.scale, 40/2.25*self.scale)];
    leftImageView.image = [UIImage imageNamed:@"sy_rili"];
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [topView addSubview:leftImageView];
    //当前日期
    UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftImageView.right + RM_Padding, 0, topView.width - leftImageView.right - 2*RM_Padding, topView.height)];
    weekLabel.textColor = blackTextColor;
    weekLabel.font = Big14Font(self.scale);
    weekLabel.tag = 20;
    weekLabel.text = [NSString stringWithFormat:@"%@   %@",_date,_week];
    [topView addSubview:weekLabel];
    
    
    
    
    //中间完成订单视图
    CellView *middleView = [[CellView alloc] initWithFrame:CGRectMake(0, topView.bottom, _mainScrollView.width, 120*self.scale)];
    middleView.backgroundColor=clearColor;
    middleView.bottomline.hidden = YES;
    [_mainScrollView addSubview:middleView];
    //头像
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(middleView.width / 2 - 130/2.25*self.scale/2 , RM_Padding*2, 130/2.25*self.scale, 130/2.25*self.scale)];
    headImageView.layer.cornerRadius=headImageView.height/2;
    headImageView.layer.masksToBounds=YES;
//    [headImageView setImageWithURL:[NSURL URLWithString:[Stockpile sharedStockpile].userLogo] placeholderImage:[UIImage imageNamed:@"sy_touxiang"]];
    headImageView.tag=201;
    [middleView addSubview:headImageView];
    headImageView.layer.borderWidth=2*self.scale;
    headImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    

    //手机号
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(middleView.width / 2 - 45*self.scale, headImageView.bottom, 90*self.scale, 20*self.scale)];
    phoneLabel.text = [Stockpile sharedStockpile].userPhone;
    phoneLabel.textColor = blackTextColor;
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.font = SmallFont(self.scale);
    [middleView addSubview:phoneLabel];
    phoneLabel.tag=202;
    
    //今日完成label
    UILabel *todayNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(RM_Padding, 0, phoneLabel.left - 2*RM_Padding, middleView.height)];
//    todayNumLabel.attributedText = [[NSString stringWithFormat:@"<main20>%@</main20>\n\n<black15>今日完成</black15>",@"0"] attributedStringWithStyleBook:[self Style]];
//    self.Style
    todayNumLabel.textAlignment = NSTextAlignmentCenter;
    todayNumLabel.numberOfLines = 3;
    [middleView addSubview:todayNumLabel];
    todayNumLabel.tag=203;
    
    //今日收益label
    UILabel *todayShouYiLabel = [[UILabel alloc] initWithFrame:CGRectMake(RM_Padding+ phoneLabel.right, 0,middleView.width - phoneLabel.right - 2*RM_Padding, middleView.height)];
//    todayShouYiLabel.attributedText = [[NSString stringWithFormat:@"<main20>%@</main20>\n\n<black14>今日收益</black14>",@"0"] attributedStringWithStyleBook:[self Style]];
    todayShouYiLabel.textAlignment = NSTextAlignmentCenter;
    todayShouYiLabel.numberOfLines = 3;
    [middleView addSubview:todayShouYiLabel];
    todayShouYiLabel.tag=204;
    
    
    //定位视图
    CellView *addressView = [[CellView alloc] initWithFrame:CGRectMake(0, middleView.bottom, _mainScrollView.width, 40*self.scale)];
    
    UIImageView * leftImg=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 0, 30*self.scale, 30*self.scale)];
    leftImg.contentMode=UIViewContentModeCenter;
    leftImg.centerY=addressView.height/2;
    leftImg.image=[UIImage imageNamed:@"dangqianweizhi"];
    [addressView addSubview:leftImg];
    
    
    addressView.backgroundColor=clearColor;
    addressView.bottomline.hidden = NO;
    addressView.tag = 80;
    addressView.title = @"当前位置：";
    addressView.titleLabel.frame = CGRectMake(RM_Padding, 0, 70*self.scale, addressView.height);
      addressView.titleLabel.left=leftImg.right;
    
    
    
    [_mainScrollView addSubview:addressView];
    //刷新按钮
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(addressView.width - RM_Padding - 130/2.25*self.scale, addressView.height/2 - 46/2.25*self.scale/2, 130/2.25*self.scale, 46/2.25*self.scale)];
    refreshButton.tag = 90;
    [refreshButton setImage:[UIImage imageNamed:@"index_new_icon"] forState:UIControlStateNormal];
    [refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
    refreshButton.titleLabel.font = SmallFont(self.scale);
    [refreshButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"bg_shauxin"] forState:UIControlStateNormal];
    [refreshButton setImage:[UIImage imageNamed:@"shuaxin"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshAddressButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton TiaoZhengButtonWithOffsit:5*self.scale TextImageSite:0];
    [addressView addSubview:refreshButton];
    
    
    
    jianBianView.height=addressView.bottom;
    // 添加 渐变图层
    jianBianView.image=[UIImage imageNamed:@"bg_shouye"];
//    CAGradientLayer * gradidentLayer=[[CAGradientLayer alloc]init];
//    gradidentLayer.frame=CGRectMake(0, 0, RM_VWidth, jianBianView.height);
//    gradidentLayer.colors=[NSArray arrayWithObjects:(id)lightBlueTextColor.CGColor, (id)[UIColor whiteColor].CGColor,nil];
//    [jianBianView.layer addSublayer:gradidentLayer];
    
    
    
    //推荐用户视图
    float buttonWidth = 300/2.25*self.scale;
    float buttonHeight = 80/2.25*self.scale;
    float blankWidth = (RM_VWidth - buttonWidth*2)/3;
    float setX = blankWidth;
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(setX, addressView.bottom+30*self.scale, buttonWidth, buttonHeight)];
        NSString *titleStr = i ==0?@"推荐跑男":@"推荐用户";
        button.tag = 70 + i;
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:whiteLineColore forState:UIControlStateNormal];
        button.titleLabel.font = Big14Font(self.scale);
        [button setBackgroundImage:[UIImage imageNamed:@"bg_tuijian"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tuiJianYongHuEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:button];
        setX = blankWidth + button.right;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.left, button.bottom, button.width, 30*self.scale)];
        label.text = i == 0?@"推荐跑男可赚0元":@"推荐用户可赚0元";
        label.textColor = blackTextColor;
        label.font = SmallFont(self.scale);
        label.textAlignment = 1;
        [_mainScrollView addSubview:label];
        label.tag=110+i;
    }
    //接单按钮
    UIButton *qiangDanButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_VWidth/2 - 270/2.25*self.scale/2, _mainScrollView.height - 270/2.25*self.scale, 270/2.25*self.scale, 270/2.25*self.scale)];
    [qiangDanButton setBackgroundImage:[UIImage imageNamed:@"btn_tingdan"] forState:UIControlStateNormal];
    qiangDanButton.tag = 40;
    qiangDanButton.layer.cornerRadius = qiangDanButton.width/2;
    qiangDanButton.clipsToBounds = YES;
    [qiangDanButton addTarget:self action:@selector(changIsWorkBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:qiangDanButton];
    //抢单Label
    UILabel *qiangDanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, qiangDanButton.width, qiangDanButton.height)];
    qiangDanLabel.textAlignment = 1;
    qiangDanLabel.numberOfLines = 2;
    qiangDanLabel.tag = 50;
    qiangDanLabel.text = @"开始\n接单";
    qiangDanLabel.textColor = blueTextColor;
    qiangDanLabel.font = Big14Font(self.scale);
    
    qiangDanLabel.center=qiangDanButton.center;
    [_mainScrollView addSubview:qiangDanLabel];
    //抢单圆圈线
    UIImageView *qiangDanLine = [[UIImageView alloc] initWithFrame:CGRectMake(qiangDanButton.width/2 - 129/2.25*self.scale/2, qiangDanButton.height/2-138/2.25*self.scale/2-2*self.scale, 129/2.25*self.scale, 138/2.25*self.scale)];
    qiangDanLine.tag = 30;
//    qiangDanLine.image = [UIImage imageNamed:@"jiedan_btn01"];
//    [qiangDanButton addSubview:qiangDanLine];
    //收工按钮
    UIButton *endQiangDanButton = [[UIButton alloc] initWithFrame:CGRectMake((RM_VWidth - qiangDanButton.right)/2 - 130/2.25*self.scale/2 + qiangDanButton.right, qiangDanButton.top+qiangDanButton.height/2-130/2.25*self.scale/2, 130/2.25*self.scale, 130/2.25*self.scale)];
    [endQiangDanButton setBackgroundImage:[UIImage imageNamed:@"sy_shougong"] forState:UIControlStateNormal];
    endQiangDanButton.tag = 60;
    endQiangDanButton.hidden = YES;
//    [endQiangDanButton setTitle:@"收工" forState:UIControlStateNormal];
    [endQiangDanButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
    endQiangDanButton.titleLabel.font = SmallFont(self.scale);
    [endQiangDanButton addTarget:self action:@selector(changIsWorkBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:endQiangDanButton];
}

#pragma mark -- 未抢单列表视图
-(void)weiQiangDanListView{
    CellView *topView = [[CellView alloc] initWithFrame:CGRectMake(RM_VWidth, 0, RM_VWidth, 40*self.scale)];
    topView.bottomline.hidden = NO;
    [_mainScrollView addSubview:topView];
    
    UIButton *chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_VWidth - 70*self.scale, topView.height/2 - 15*self.scale, 60*self.scale, 30*self.scale)];
    [chooseButton setImage:[UIImage imageNamed:@"shuaixuan@2x"] forState:UIControlStateNormal];
    [chooseButton setTitle:@"筛选" forState:UIControlStateNormal];
    chooseButton.titleLabel.font = Big14Font(self.scale);
    [chooseButton TiaoZhengButtonWithOffsit:7*self.scale TextImageSite:0];
    [chooseButton addTarget:self action:@selector(chooseButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [chooseButton setTitleColor:blackTextColor forState:UIControlStateNormal];
    [topView addSubview:chooseButton];
    
    
    
    _qiangDanTableView = [[UITableView alloc] initWithFrame:CGRectMake(RM_VWidth, topView.bottom, RM_VWidth, _mainScrollView.height-topView.height) style:UITableViewStyleGrouped];
    _qiangDanTableView.tag = 2000;
    _qiangDanTableView.delegate = self;
    _qiangDanTableView.dataSource = self;
    _qiangDanTableView.backgroundColor = superBackgroundColor;
    [_qiangDanTableView registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"qiangDanCell"];
    _qiangDanTableView.separatorStyle = 0;
    [_mainScrollView addSubview:_qiangDanTableView];
    [_qiangDanTableView addHeardTarget:self Action:@selector(qiangXiala)];
    [_qiangDanTableView addFooterTarget:self Action:@selector(qiangShangla)];
}
-(void)qiangXiala{
    _qiangDanYe=1;
    [self reshDataIsQianged:NO];
}
-(void)qiangShangla{
    _qiangDanYe++;
    [self reshDataIsQianged:NO];
}
#pragma mark -- 未完成订单列表视图
-(void)uncompleteOrderView{
    CellView *topView = [[CellView alloc] initWithFrame:CGRectMake(RM_VWidth*2, 0, RM_VWidth, 40*self.scale)];
    topView.bottomline.hidden = NO;
    [_mainScrollView addSubview:topView];
    //全部订单
//    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(RM_Padding, topView.height/2 - 31/2.25/2*self.scale, 27/2.25*self.scale, 31/2.25*self.scale)];
//    leftImageView.image = [UIImage imageNamed:@"personal_dingdan_icon01"];
//    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [topView addSubview:leftImageView];
    
//    UILabel *allOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftImageView.right+RM_Padding, 0, 100*self.scale, topView.height)];
//    allOrderLabel.text = @"全部订单";
//    allOrderLabel.tag = 20;
//    allOrderLabel.font = Big14Font(self.scale);
//    [topView addSubview:allOrderLabel];
    
    UIButton *chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_VWidth - 70*self.scale, topView.height/2 - 15*self.scale, 60*self.scale, 30*self.scale)];
    [chooseButton setImage:[UIImage imageNamed:@"shuaixuan@2x"] forState:UIControlStateNormal];
    [chooseButton setTitle:@"筛选" forState:UIControlStateNormal];
    chooseButton.titleLabel.font = Big14Font(self.scale);
    [chooseButton TiaoZhengButtonWithOffsit:7*self.scale TextImageSite:0];
    [chooseButton addTarget:self action:@selector(chooseButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [chooseButton setTitleColor:blackTextColor forState:UIControlStateNormal];
    [topView addSubview:chooseButton];
    
    
    
    _unFinishTableView = [[UITableView alloc] initWithFrame:CGRectMake(RM_VWidth*2, topView.bottom, RM_VWidth, _mainScrollView.height-topView.height) style:UITableViewStyleGrouped];
    _unFinishTableView.tag = 3000;
    _unFinishTableView.delegate = self;
    _unFinishTableView.dataSource = self;
    _unFinishTableView.backgroundColor = superBackgroundColor;
    [_unFinishTableView registerClass:[OrderTableViewCell class] forCellReuseIdentifier:@"unFinishCell"];
    _unFinishTableView.separatorStyle = 0;
    [_mainScrollView addSubview:_unFinishTableView];
    [_unFinishTableView addHeardTarget:self Action:@selector(unXiala)];
    [_unFinishTableView addFooterTarget:self Action:@selector(unShangla)];
//    _unFinishTableView.tableHeaderView.height=40*self.scale;
    
//    _unFinishTableView.tableHeaderView=[self unFinishHeaderView];
}
-(void)unXiala{
    _unFinishYe=1;
    [self reshDataIsQianged:YES];
}
-(void)unShangla{
    _unFinishYe++;
    [self reshDataIsQianged:YES];
}
#pragma mark -- 筛选事件
-(void)chooseButtonEvent:(UIButton *)button{
    if (_isZhanKai) {
        [self dismissViewEvent];
        return;
    }
    _maskControl = [[UIControl alloc] initWithFrame:CGRectMake(0,self.NavImg.bottom + 40*self.scale, RM_VWidth, RM_VHeight - (self.NavImg.bottom + 40*self.scale))];
    _maskControl.clipsToBounds = YES;
    _maskControl.backgroundColor = clearColor;
    [_maskControl addTarget:self action:@selector(dismissViewEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_maskControl];

    _titleArray=[NSMutableArray arrayWithArray:@[@"全部订单"]];
    [_titleArray addObjectsFromArray:self.orderTitles];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, -40*self.scale*self.titleArray.count, _maskControl.width, 40*self.scale*self.titleArray.count)];
    [_maskControl addSubview:_maskView];
    float setY = 0;
    for (int i = 0; i < self.titleArray.count; i ++ ) {
        // 待 完成订单的类型
        CellView *cellView = [[CellView alloc] initWithFrame:CGRectMake(0, setY, _maskControl.width, 40*self.scale)];
        cellView.titleLabel.text = self.titleArray[i];
        [cellView setShotLine:i != self.titleArray.count - 1 ];
        [_maskView addSubview:cellView];
        
        UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, cellView.width, cellView.height)];
        button.backgroundColor = clearColor;
        button.tag = 10 + i;
        if (_scrollViewIndex==1) {// 未抢订单
            if (i == [self serverToViewType:_qiangTypeIndex]) {
                cellView.titleLabel.textColor=mainColor;
            }
        }
        if (_scrollViewIndex==2) {// 待完成订单
            if (i == [self serverToViewType:_unFinishTypeIndex]) {
                cellView.titleLabel.textColor=mainColor;
            }
        }
        
       
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
//    UILabel *orderLabel = (UILabel *)[self.view viewWithTag:300];
//    orderLabel.text = self.titleArray[button.tag - 10];
  
    if (_scrollViewIndex==1) {// 未抢订单
        _qiangTypeIndex=[self viewToServerType:button.tag - 10];
        [self reshDataIsQianged:NO];
    }
    if (_scrollViewIndex==2) {// 待完成订单
        _unFinishTypeIndex=[self viewToServerType:button.tag - 10];
        [self reshDataIsQianged:YES];
    }
    
    

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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [self dismissViewEvent];
}


#pragma mark -------------------------------------------   刷新视图数据    ---------------
//刷新日期
-(void)refreshWeek{
    UILabel *weekLabel = (UILabel *)[_mainScrollView viewWithTag:20];
    weekLabel.text = [NSString stringWithFormat:@"%@   %@",_date,_week];
}
//刷新位置信息
-(void)reshLocationData{
    if (![Stockpile sharedStockpile].isWork) {
        return;
    }
    
    BaiDuMapLocationManager * manager = [BaiDuMapLocationManager sharedBaiDuMapLocationManager];
    [manager AllowLocationAndGetAddress:^(CLLocationCoordinate2D locationCoordinate2D, NSString *country, NSString *province, NSString *city, NSString *area, NSString *road, NSString *place) {
        [[Stockpile sharedStockpile] setCity:city];
        [[Stockpile sharedStockpile] setArea:area];
        [[Stockpile sharedStockpile] setRode:road];
        [[Stockpile sharedStockpile] setPlace:place];
        [[Stockpile sharedStockpile] setLatitude:[NSString stringWithFormat:@"%f",locationCoordinate2D.latitude]];
        [[Stockpile sharedStockpile] setLongitude:[NSString stringWithFormat:@"%f",locationCoordinate2D.longitude]];
        [self refreshAddressInfomation];
        
        [self uploadLocation];
    }];
}
-(void)refreshAddressInfomation{
    CellView *addressView = (CellView *)[self.view viewWithTag:80];
    UIButton *refreshButton = (UIButton *)[addressView viewWithTag:90];
    //地址Label
    NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@",[Stockpile sharedStockpile].city,[Stockpile sharedStockpile].area,[Stockpile sharedStockpile].rode,[Stockpile sharedStockpile].place];
   
    
    if (_paoMa) {
        [_paoMa removeFromSuperview];
        _paoMa=nil;
    }
    _paoMa = [self createMarqueeWithFrame:CGRectMake(addressView.titleLabel.right, 0, refreshButton.left - RM_Padding - addressView.titleLabel.right, addressView.height) text:addressStr];
    [addressView addSubview:_paoMa];

    
}
-(UIView *)createMarqueeWithFrame:(CGRect)frame text:(NSString *)string{
    UIView * bgView=[[UILabel alloc]initWithFrame:frame];
    bgView.layer.masksToBounds=YES;
    UILabel * label= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
    [bgView addSubview:label];
    label.numberOfLines=1;
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor blackColor];
    label.text=[NSString stringWithFormat:@" %@ ",string];
    label.textAlignment=NSTextAlignmentCenter;
    CGFloat w=[UILabel Text:label.text Size:CGSizeMake(2000, frame.size.height) Font:13].width;
    if (w>frame.size.width) {
        NSString * stringD=[label.text stringByAppendingString:label.text];
        label.width=w*2;
        label.text=stringD;
        [UIView animateWithDuration:string.length/4 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionRepeat animations:^{
            label.transform=CGAffineTransformMakeTranslation(-w, 0);
        } completion:^(BOOL finished) {
            label.left=0;
        }];
    }
    return bgView;
}
#pragma mark -------------------------------------------   视图的代理事件    --------------
#pragma mark -- tableView视图的代理事件
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 2000) {
        return _qiangDanDatas.count;
    }
    if (tableView.tag==3000) {
        return _unFinishDatas.count;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic=@{};
    //抢单列表
   
    
    if (tableView.tag == 2000) {
      
        // 抢订单
        dic=_qiangDanDatas[indexPath.section];
//        NSLog(@"orderID；    %@",dic[@"OrderId"]);
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"qiangDanCell"];
        cell.orderType=[[NSString stringWithFormat:@"%@",dic[@"Type"]] integerValue];
        cell.timeLabel.text = [[NSString stringWithFormat:@"%@",dic[@"DownOrderTime"]] getValiedString];
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
        

        
//        if (orderTypeIndex==0 || orderTypeIndex==1 || orderTypeIndex==2) {
//              cell.goodsLabel.hidden=YES;
//        }else{
//              cell.goodsLabel.hidden=YES;
//        }
        
        
        
        cell.orderDecLabel.attributedText = [[NSString stringWithFormat:@"<gray12>路程大约%.2f公里，费用</gray12><orang14>%.2f</orang14><gray12>元，加价</gray12><orang14>%.2f</orang14><gray12>元</gray12>",[xingCheng floatValue],[price floatValue],[addPrice floatValue]] attributedStringWithStyleBook:[self Style]];
        cell.goodsLabel.attributedText = [[NSString stringWithFormat:@"<gray12>购买商品：</gray12><blue12>%@</blue12>",[[NSString stringWithFormat:@"%@",dic[@"GoodsName"]] getValiedString]] attributedStringWithStyleBook:[self Style]];
        if (orderTypeIndex==OrderTypeHelp || orderTypeIndex==OrderTypeQueueUp) {
            cell.goodsLabel.attributedText =  [[NSString stringWithFormat:@"<gray12>预约时间：</gray12><blue12>%@</blue12>",[[NSString stringWithFormat:@"%@",dic[@"YuYueTime"]] getValiedString]] attributedStringWithStyleBook:[self Style]];
        }
        
        cell.beiZhuLabel.text = [[NSString stringWithFormat:@"备注:%@",dic[@"Desc"]] getValiedString];
        cell.isQiangDan = YES;
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.backgroundColor = superBackgroundColor;
        cell.selectionStyle = 0;
        return cell;

    }else{
        //待 完成 列表
        dic=_unFinishDatas[indexPath.section];

        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"unFinishCell"];
        cell.timeLabel.text = [[NSString stringWithFormat:@"%@",dic[@"DownOrderTime"]] getValiedString];
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
        
//        if (orderTypeIndex==0 || orderTypeIndex==1 || orderTypeIndex==2) {  /// 买送取
//            cell.goodsLabel.hidden=YES;
//        }else{
//            cell.goodsLabel.hidden=YES;
//        }
//        if (orderTypeIndex==3) {
//            cell.beiZhuLabel.hidden=YES;
//        }else{
//            cell.beiZhuLabel.hidden=NO;
//        }
//        if (orderTypeIndex==1 || orderTypeIndex==2) { //  易碎 以及 保温箱
//            
//        }
  
        
        
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
        
        
        cell.isQiangDan = NO;
        cell.backgroundColor = superBackgroundColor;
        cell.selectionStyle = 0;

        return cell;

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *  dic = @{};
    if (tableView.tag == 3000) {
         dic=_unFinishDatas[indexPath.section];
        NSInteger orderType = [[NSString stringWithFormat:@"%@",dic[@"Type"]] integerValue];
        if (orderType==3) { // 闪电摩的
            KuaiCheViewController * kuaiChe = [KuaiCheViewController new];
            kuaiChe.block=^(){
                [self unXiala];
            };
            kuaiChe.orderId=[[NSString stringWithFormat:@"%@",dic[@"OrderId"]] getValiedString];
            [self.navigationController pushViewController:kuaiChe animated:YES];
            
        }else{
            UnFinishOrderDetailsViewController *unFinishVC = [UnFinishOrderDetailsViewController new];
            unFinishVC.orderType= orderType;
            unFinishVC.block=^(){
                [self unXiala];
            };
            unFinishVC.orderId=[[NSString stringWithFormat:@"%@",dic[@"OrderId"]] getValiedString];
            [self.navigationController pushViewController:unFinishVC animated:YES];
        }
        
        
        


    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic;
    float baseH = 190*self.scale;
    NSInteger typeIndex;
    
    if (tableView.tag == 2000) {
        dic = _qiangDanDatas[indexPath.section];
    }else{
        dic = _unFinishDatas[indexPath.section];
    }
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

    
    
    if (tableView.tag == 2000) {
        return baseH + RM_ButtonHeight+15*self.scale;
    }else{
        return baseH;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, RM_Padding)];
    headerView.backgroundColor = superBackgroundColor;
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return RM_Padding;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
#pragma mark -- 抢单列表Cell的代理事件
-(void)OrderTableViewCellQiangDanWithIndex:(NSIndexPath *)indexPath{
    if (![self judgeStatus]) {
        return;
    };
    if (![Stockpile sharedStockpile].isWork) {
        [self ShowOKAlertWithTitle:@"您还未开工" Message:nil WithButtonTitle:@"确定" Blcok:^{
        }];
        return;
    }

    
    NSString * orderId = [NSString stringWithFormat:@"%@",_qiangDanDatas[indexPath.section][@"OrderId"]];
    NSString * orderType = [NSString stringWithFormat:@"%@",_qiangDanDatas[indexPath.section][@"Type"]];
    NSDictionary * dic = @{@"PeiSongId":[Stockpile sharedStockpile].userID,
                           @"OrderId":orderId};
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject qingdanWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        if (CODE(ret)) {
          [self TongSongShiShiOrderViewControllerQiangDanResultWithOrderId:orderId isTexi:[orderType isEqualToString:@"3"]];
        }else{
            [self ShowQiangDanResultMessage:@"抢单失败" WithCode:tanChuViewWithQiangDanFaile WithBlock:^{
            }];
        }
    }];
    
    
//    NSString *str = [NSString stringWithFormat:@"抢的是第  %ld  个订单",indexPath.section+1];
//    [CoreSVP showMessageInCenterWithMessage:str];
}
#pragma mark -- 滚动视图的代理事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 1000) {
      
        PHTabbar * tabbar=[self.NavImg viewWithTag:1010];
        // 前翻 还是 后翻
        CGFloat currentOfset = scrollView.width*_scrollViewIndex;
        float percent = (scrollView.contentOffset.x-currentOfset)/scrollView.width;
        NSLog(@"%.2f",percent);
        [tabbar changeUnderLineOffSet:percent];
    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //判断是否是滚动视图 排除tableView的滚动
    if (scrollView.tag == 1000) {
 
        _selectButton.selected = NO;

        int num = scrollView.contentOffset.x/RM_VWidth;
        UIButton *menuButton = (UIButton *)[self.view viewWithTag:10+num];
        if (_selectButton != menuButton) {
            _selectButton = menuButton;
        }
        [UIView animateWithDuration:.3 animations:^{
            _selectButton.selected = YES;
            _selectLine.frame = CGRectMake(_selectButton.left, _selectButton.bottom - 1, _selectButton.width, 1);
        }];
        if (_scrollViewIndex != num) {
            if (num == 1) {
                [self reshDataIsQianged:NO];
            }
            else if (num == 2){
                [self reshDataIsQianged:YES];
            }
            if (num == 0) {
                [self reshRealData];
            }
            PHTabbar * tabbar=[self.NavImg viewWithTag:1010];
            _scrollViewIndex = num;
            tabbar.index=_scrollViewIndex;
            
        }
        
    }
    
}

#pragma mark -- 实时订单弹出界面的代理事件
//删除事件
-(void)TongSongShiShiOrderViewControllerDelete{
    _shiShiOrderVC.delegate = nil;
    [UIView animateWithDuration:0.3 animations:^{
        _shiShiOrderVC.view.top = self.view.bottom;
        [_shiShiOrderVC.view removeFromSuperview];
        _shiShiOrderVC = nil;
    }];
}
-(void)TongSongShiShiOrderViewControllerQiangDanResultWithOrderId:(NSString *)orderId isTexi:(BOOL)isTexi{
    [UIView animateWithDuration:0.3 animations:^{
        _shiShiOrderVC.view.top = self.view.bottom;
        [self ShowQiangDanResultMessage:@"抢单成功" WithCode:tanChuViewWithQiangDanSucess WithBlock:^{
            if (isTexi) {
                KuaiCheViewController * kuaiChe = [KuaiCheViewController new];
                kuaiChe.orderId = orderId;
                kuaiChe.block=^(){
                    [self reshDataIsQianged:NO];
                };
                [self.navigationController pushViewController:kuaiChe animated:YES];
            }else{
                UnFinishOrderDetailsViewController *unFinishVC = [UnFinishOrderDetailsViewController new];
                unFinishVC.orderId=orderId;
                unFinishVC.block=^(){
                    [self reshDataIsQianged:NO];
                };
                
                [self.navigationController pushViewController:unFinishVC animated:YES];
            }
        }];
    }];
}
//#pragma mark -------------------------------------------   通知事件   --------------------
//#pragma mark -- 抢单成功
//-(void)qiangDanSuccess:(NSNotification *)notification{
//    
//}
//#pragma mark -- 抢单失败
//-(void)qiangDanFaile:(NSNotification *)notification{
//    
//}
#pragma mark -------------------------------------------   点击事件    ---------------------

#pragma  mark -- 开工 或者 收工
-(void)changIsWorkBtn:(UIButton *)sender{//  收工与开工的弹出方式不同 所以单独写了这个方法
    if (![self judgeStatus]) {
        return;
    }
    
    if ([Stockpile sharedStockpile].isWork) {  //// 收工
        [self commitKnockOffBlock:^(NSInteger index) {
            if (index==1) {
                [self changIsWork:sender];
            }
        }];
    }else{  /// 开工
         [self changIsWork:sender];
    }
    
    
}
-(void)changIsWork:(UIButton *)sender{
    
    NSString * isWork;
    isWork=[Stockpile sharedStockpile].isWork?@"0":@"1";
        NSDictionary * dic=@{@"PeiSongId":[Stockpile sharedStockpile].userID,
                             @"type":isWork};
        [self startDownloadDataWithMessage:nil];
        [AnalyzeObject changeToShougongOrKaigongWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopDownloadData];
            if (CODE(ret)) {
                if ([Stockpile sharedStockpile].isWork) {// 收工成功
                    [[Stockpile sharedStockpile] setIsWork:NO];
                    [self.appdelegate turnOffNotification];// 关闭 推送
                    [self endQiangDan];
                    //  界面
                }else{                                   //开工成功
                    // 界面
                    [[Stockpile sharedStockpile] setIsWork:YES];
                    [self.appdelegate turnOnNotification];// 打开 推送
                    [self startQiangDan];
                }
            }else{
                if ([Stockpile sharedStockpile].isWork) {
                    [CoreSVP showMessageInBottomWithMessage:@"收工失败"];
                }else{
                    [CoreSVP showMessageInBottomWithMessage:@"开工失败"];
                }
                
            }
        }];
}

#pragma mark -- 开始抢单
-(void)startQiangDan{
     //  加载 订单数据的事件 放到 外部

    
    UIButton * button = [self.view viewWithTag:40];
    
    button.userInteractionEnabled = NO;
    UILabel *qianDanLabel = (UILabel *)[self.view viewWithTag:50];
    qianDanLabel.text = @"听单中";
    qianDanLabel.numberOfLines = 1;
    
    UIButton *endQiangDanButton = (UIButton *)[self.view viewWithTag:60];
    endQiangDanButton.hidden = NO;
    [self startRotation];    
}
-(void)valiteNoti{
    [self TongSongShiShiOrderViewControllerDelete];
    [self.appdelegate turnOnNotification];
}
-(void)receiveOrder:(NSString *)orderId{ ///

    
    
    NSDictionary * dic = @{@"OrderId":orderId};
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getRealTimeOrderWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        if (CODE(ret)) {
            /// 加载订单信息成功 1！！！！！！
            
            if (_shiShiOrderVC) {
                [_shiShiOrderVC.view removeFromSuperview];
                _shiShiOrderVC.delegate = nil;
                _shiShiOrderVC = nil;
            }
            [self.appdelegate   turnOffNotification];
            [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(valiteNoti) userInfo:nil repeats:NO];
            
            _shiShiOrderVC = [[TongSongShiShiOrderViewController alloc] init];
            _shiShiOrderVC.dataDic =model;
            _shiShiOrderVC.orderId=orderId;
            _shiShiOrderVC.delegate = self;
            _shiShiOrderVC.view.top = self.view.bottom;
            [self.appdelegate.window addSubview:_shiShiOrderVC.view];
            [UIView animateWithDuration:0.5 animations:^{
                _shiShiOrderVC.view.top = self.view.top;
            }];
        }else{
            [CoreSVP showMessageInCenterWithMessage:msg];
        }
    }];
}

#pragma mark --  结束抢单
-(void)endQiangDan{
    UIButton *qiangDanButton = (UIButton *)[self.view viewWithTag:30];
    qiangDanButton.userInteractionEnabled = YES;
    
    UIButton *endBtn = (UIButton *)[self.view viewWithTag:60];
    endBtn.hidden = YES;
    
    UILabel *qianDanLabel = (UILabel *)[self.view viewWithTag:50];
    qianDanLabel.text = @"开始\n接单";
    qianDanLabel.numberOfLines = 2;
    [self stopRotation];

}


#pragma mark -- 刷新自己的位置
-(void)refreshAddressButtonEvent:(UIButton *)button{
    [self StartLocation];
}
#pragma mark -- 导航栏订单菜单按钮事件
//-(void)menuButtonEvent:(UIButton *)button{
////    _selectButton.selected = NO;
////    if (_selectButton != button) {
////        _selectButton = button;
////    }
////    _selectButton.selected = YES;
////    [UIView animateWithDuration:.3 animations:^{
////        _selectLine.frame = CGRectMake(_selectButton.left, _selectButton.bottom - 1, _selectButton.width, 1);
////        _mainScrollView.contentOffset = CGPointMake(RM_VWidth*(_selectButton.tag%10), 0);
////        
////    }];
//    
//}
#pragma mark -- 推荐用户事件
-(void)tuiJianYongHuEvent:(UIButton *)button{
    if (button.tag==70) {
        [self ShowQiangDanResultMessage:@"" WithCode:tanChuViewWithErWeiMa1 WithBlock:^{
        }];
    }else{
        [self ShowQiangDanResultMessage:@"" WithCode:tanChuViewWithErWeiMa2 WithBlock:^{
        }];
    }
    

//    if (button.tag == 70) {
//    
//    }else{
//        [self ShowQiangDanResultMessage:@"1300" WithCode:tanChuViewWithGetShouYi WithBlock:^{
//            NSLog(@"点击了立即配送按钮");
//        }];
//    }
}
#pragma mark -- 开始定位
-(void)StartLocation{
    
    
    [self startDownloadDataWithMessage:@"正在获取当前位置"];
    [[BaiDuMapLocationManager sharedBaiDuMapLocationManager] AllowLocationAndGetAddress:^(CLLocationCoordinate2D locationCoordinate2D, NSString *country, NSString *province, NSString *city, NSString *area, NSString *road, NSString *place) {
        [self stopDownloadData];
        
        [[Stockpile sharedStockpile] setLongitude:[NSString stringWithFormat:@"%f",locationCoordinate2D.longitude]];
        [[Stockpile sharedStockpile] setLatitude:[NSString stringWithFormat:@"%f",locationCoordinate2D.latitude]];
        [[Stockpile sharedStockpile] setProvince:province];
        [[Stockpile sharedStockpile] setCity:city];
        [[Stockpile sharedStockpile] setArea:area];
        [[Stockpile sharedStockpile] setRode:road];
        [[Stockpile sharedStockpile] setPlace:place];
        [self refreshAddressInfomation];
    }];
    
    
    
}
#pragma mark -- 导航按钮事件
//个人中心事件
-(void)gotoGeRenZhongXinEvent:(UIButton *)button{
    [self dismissViewEvent];
    [_personCenter activeChange];
}
//个人中心事件
-(void)gotoMyMessageEvent:(UIButton *)button{
    MessageViewController *personCenter = [MessageViewController new];
    personCenter.block=^(){
        [self reshRealData];
    };
    [self.navigationController pushViewController:personCenter animated:YES];
}
#pragma mark -------------------------------------------   其他    ---------------------
//-(void)panDuanRotation{
//    UIButton *endQiangDanButton = (UIButton *)[self.view viewWithTag:60];
//    if (endQiangDanButton.hidden) {
//        [self stopRotation];
//    }else{
//        [self startRotation];
//    }
//}
#pragma mark -- 开始旋转
-(void)startRotation{
    UIButton *imageView = [self.view viewWithTag:40];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
#pragma mark -- 停止旋转
-(void)stopRotation{
    UIButton *imageView = [self.view viewWithTag:40];
    [imageView.layer removeAllAnimations];
    
    imageView.userInteractionEnabled=YES;
    [imageView addTarget:self action:@selector(startQiangDan) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark -- 获取当前的日期和星期
-(void)getCurrentDateAndWeek
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitSecond | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:date];
    long week = [comps weekday];
    long month = [comps month];
    long day = [comps day];
    _date = [NSString stringWithFormat:@"%ld月%ld日",month,day];
    _week = [NSString stringWithFormat:@"%@",[self.weekArray objectAtIndex:week-1]];
    [self refreshWeek];
}
#pragma mark -------------------------------------------   导航    ----------------------
-(void)setupNewNavi{
    //个人中心
    UIButton *personCenterButton = [[UIButton alloc] initWithFrame:CGRectMake(0,self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [personCenterButton setImage:[UIImage imageNamed:@"sy-toux"] forState:UIControlStateNormal];
//    [personCenterButton setImage:[UIImage imageNamed:@"index_top_icon01"] forState:UIControlStateHighlighted];
    [personCenterButton addTarget:self action:@selector(gotoGeRenZhongXinEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:personCenterButton];
    
    UIButton *MessageButton = [[UIButton alloc] initWithFrame:CGRectMake(self.TitleLabel.right,self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [MessageButton setImage:[UIImage imageNamed:@"sy_xiaoxi"] forState:UIControlStateNormal];
//    [MessageButton setImage:[UIImage imageNamed:@"index_top_icon02"] forState:UIControlStateHighlighted];
    [MessageButton addTarget:self action:@selector(gotoMyMessageEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:MessageButton];
    
    UIImageView *yellowPoint = [[UIImageView alloc] initWithFrame:CGRectMake(MessageButton.right - RM_Padding, MessageButton.top+RM_Padding, 6*self.scale, 6*self.scale)];
    yellowPoint.backgroundColor = mainColor;
    yellowPoint.layer.cornerRadius = 3*self.scale;
    yellowPoint.clipsToBounds = YES;
    [self.NavImg addSubview:yellowPoint];
    yellowPoint.tag=777;
    [self newMenuButtonView];
}
-(void)newMenuButtonView{
    
//    self.menuTitleArray=@[@"积分的拉萨开发",@"发",@"fds",@"fdsafdsafdsafsadfdsadfasdf"];
    
    PHTabbar * bar=[PHTabbar insWithTitles:self.menuTitleArray type:0 themeColor:mainColor frame:CGRectMake(50*self.scale, self.TitleLabel.top, RM_VWidth-100*self.scale, self.TitleLabel.height)];
     /// 顶部的 标题导航
    
    
    bar.block=^(NSInteger index){
        
        _mainScrollView.contentOffset=CGPointMake(RM_VWidth*index, 0);
        if (index==1) {
            [self reshDataIsQianged:NO];
        }
        if (index==2) {// // 待完成
            [self reshDataIsQianged:YES];
       
        }
        if (index==0) {
            [self reshRealData];
            
        }
        if (index != _scrollViewIndex) {
            [self dismissViewEvent];
        }
        _scrollViewIndex=index;
       
    };
    bar.tag=1010;
    [self.NavImg addSubview:bar];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"judgeStartRotation" object:nil];
}
-(BOOL)judgeStatus{
//    [CoreSVP showMessageInCenterWithMessage:[NSString stringWithFormat:@"%d",[Stockpile sharedStockpile].userStatus]];
    
    if ([Stockpile sharedStockpile].userStatus==0) {//可以正常接单
        [self ShowOKAlertWithTitle:@"提示" Message:@"资料正在审核中！" WithButtonTitle:@"确定" Blcok:^{
        }];
        return NO;
    };
    if([Stockpile sharedStockpile].userStatus==1){
        [self ShowOKAlertWithTitle:nil Message:@"资料审核通过（请前往闪电培训课堂）！" WithButtonTitle:@"确定" Blcok:^{
        }];
        return NO;
    }
    
    if ([Stockpile sharedStockpile].userStatus==2) {//资料申请失败
        [self ShowAlertTitle:nil Message:@"资料审核失败，是否重新申请" Delegate:self Block:^(NSInteger index) {
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
        [self ShowAlertTitle:nil Message:@"还未提交资料，是否申请？" Delegate:self Block:^(NSInteger index) {
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
    if ([[Stockpile sharedStockpile].userJiFen integerValue]<=0) {
        [self ShowOKAlertWithTitle:nil Message:@"你的积分不够,不能进行此操作！" WithButtonTitle:@"确定" Blcok:^{
        }];
        return NO;
    }
    
    if ([Stockpile sharedStockpile].userStatus==3) {
        return YES;
    }
    return NO;
}

@end
