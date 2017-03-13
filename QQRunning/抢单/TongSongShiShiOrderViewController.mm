//
//  TongSongShiShiOrderViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/27.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "TongSongShiShiOrderViewController.h"
#import "CellView.h"

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPolyline.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduMapAPI_Base/BMKTypes.h>
#import <BaiduMapAPI_Search/BMKRouteSearchOption.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import "RouteAnnotation.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
@interface TongSongShiShiOrderViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKRouteSearchDelegate>

@property (nonatomic,strong) UIView *maskView;//订单视图和地图的父视图
@property (nonatomic,strong) UIView *orderView;
@property (nonatomic,strong) UIButton *selectButton;

@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) BMKLocationService *locationService;
@property (nonatomic,strong) BMKRouteSearch *routesearch;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger time;



@end

@implementation TongSongShiShiOrderViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UILabel *qiangDanLabel = (UILabel *)[self.view viewWithTag:3334];
    NSInteger stamp =[[NSString stringWithFormat:@"%@",_dataDic[@"Ticks"]] integerValue];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:stamp];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
     NSInteger  daoJiShi= stamp - timeInterval;
    
    
    _time = [self getDaoJiShiWithStamp:daoJiShi];
//    _time = 5;
    qiangDanLabel.text = @"抢单";
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(readyQiangDan) userInfo:nil repeats:YES];

   
}
-(NSInteger)getDaoJiShiWithStamp:(NSInteger)stamp{
    return stamp - [self getNowTimeStamp];
}
-(NSTimeInterval)getNowTimeStamp{
    NSDate * date = [NSDate date];
    NSTimeInterval timeStamp = [date timeIntervalSince1970];
    return timeStamp;
}
-(NSString *)getTimeTextWithDaoJiShi:(NSInteger)daoJiShi{
    if (daoJiShi<1) {
        daoJiShi=0;
    }
    
    NSInteger second = daoJiShi % 60 ; // 整秒
    NSInteger minute = daoJiShi / 60 % 60 ;  /// 整分钟
    NSInteger hour   = daoJiShi / 60 / 60 % 24 ; // 整小时
    NSInteger day    = daoJiShi / 60 / 60 / 24 % 30 ;// 整天
    NSMutableArray * dateArray  = [NSMutableArray array];
    [dateArray addObjectsFromArray:@[@(day),@(hour),@(minute),@(second)]];
    if (day==0) {
        [dateArray removeObjectAtIndex:0];
        if (hour==0) {
            [dateArray removeObjectAtIndex:0];
            if (minute==0) {
                [dateArray removeObjectAtIndex:0];
            }
        }
    }
    
    NSString * timeText = [dateArray componentsJoinedByString:@":"];
    return timeText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.NavImg.backgroundColor = clearColor;
    self.Navline.backgroundColor = clearColor;
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self setupNewView];
    [self startLocation];
    
}
#pragma mark -- 界面
-(void)setupNewView{
    
    //接单按钮
    UIButton *qiangDanButton = [[UIButton alloc] initWithFrame:CGRectMake(RM_VWidth/2 - 270/2.25*self.scale/2, RM_VHeight - 270/2.25*self.scale, 270/2.25*self.scale, 270/2.25*self.scale)];
//    qiangDanButton.backgroundColor = redTextColor;
    [qiangDanButton setBackgroundImage:[UIImage imageNamed:@"sy_daojishi"] forState:UIControlStateNormal];
    [qiangDanButton setBackgroundImage:[UIImage imageNamed:@"sy_daojishi"] forState:UIControlStateHighlighted];
    qiangDanButton.tag = 3333;
    qiangDanButton.userInteractionEnabled = NO;
    qiangDanButton.layer.cornerRadius = qiangDanButton.width/2;
    qiangDanButton.clipsToBounds = YES;
    [qiangDanButton addTarget:self action:@selector(startQiangDanEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qiangDanButton];
    //抢单Label
    UILabel *qiangDanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, qiangDanButton.width, qiangDanButton.height)];
    qiangDanLabel.textAlignment = NSTextAlignmentCenter;
    qiangDanLabel.numberOfLines = 2;
    qiangDanLabel.tag = 3334;
    qiangDanLabel.textColor = whiteLineColore;
    qiangDanLabel.font = Big17Font(self.scale);
    [qiangDanButton addSubview:qiangDanLabel];
    
    //弹出视图
    [self setupPressentView];
}
-(void)readyQiangDan{
    UIButton *qiangDanButton = (UIButton *)[self.view viewWithTag:3333];
    UILabel *qiangDanLabel = (UILabel *)[self.view viewWithTag:3334];
    if (_time <  1) {
        [_timer invalidate];
        _timer = nil;
        qiangDanButton.userInteractionEnabled = YES;
        qiangDanLabel.text = @"抢单";
    }else{
        _time--;
        qiangDanButton.userInteractionEnabled = NO;
        qiangDanLabel.text = [self getTimeTextWithDaoJiShi:_time];
        
    }
}
#pragma mark -- 弹出视图
-(void)setupPressentView{
    
    //弹出的整个视图背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(RM_Padding, self.NavImg.bottom + RM_Padding, RM_VWidth - 2*RM_Padding, 80*self.scale)];
    bgView.backgroundColor = whiteLineColore;
    bgView.layer.cornerRadius = 5*self.scale;
    bgView.clipsToBounds = YES;
    [self.view addSubview:bgView];
    
    //关闭按钮
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 50*self.scale, bgView.top - 50*self.scale, 50*self.scale, 50*self.scale)];
    closeButton.backgroundColor = clearColor;
    [closeButton addTarget:self action:@selector(closeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    //关闭图片
    UIImageView *closeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(closeButton.width - 48/2.25*self.scale - RM_Padding, closeButton.height - 48/2.25*self.scale - RM_Padding, 48/2.25*self.scale, 48/2.25*self.scale)];
    closeImageView.image = [UIImage imageNamed:@"sy_delete"];
    closeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [closeButton addSubview:closeImageView];
    
    //头部视图
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgView.width, 60*self.scale)];
//    topView.backgroundColor = mainColor;
    [bgView addSubview:topView];
    
    //订单类型
    UIButton *orderTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(5*self.scale, topView.height/2 - 15*self.scale, 80*self.scale, 30*self.scale)];
    orderTypeButton.centerX=bgView.width/2;
//    [orderTypeButton setImage:[UIImage imageNamed:@"tingdan_icon01"] forState:UIControlStateNormal];
    
    
    NSString * orderType = [[NSString stringWithFormat:@"%@",_dataDic[@"Type"]]getValiedString];
    NSInteger orderTypeIndex = [orderType integerValue];
    NSString * orderTitle = @"其他";
    if (orderTypeIndex >= 0 && orderTypeIndex <6) {
         orderTitle = [NSString stringWithFormat:@"%@",self.orderTitles[orderTypeIndex]];
    }
    
    
    
    
    [orderTypeButton setTitle:orderTitle forState:UIControlStateNormal];
    [orderTypeButton setTitleColor:blackTextColor forState:UIControlStateNormal];
    orderTypeButton.titleLabel.font = Big17BoldFont(self.scale);
    orderTypeButton.userInteractionEnabled = NO;
    [orderTypeButton TiaoZhengButtonWithOffsit:5*self.scale TextImageSite:0];
    [topView addSubview:orderTypeButton];
    
    //实时状态button
    UIButton *shiShiButton = [[UIButton alloc] initWithFrame:CGRectMake(topView.width - 55, 0, 55, 20)];
    shiShiButton.centerY=orderTypeButton.centerY;
    [shiShiButton setBackgroundImage:[UIImage imageNamed:@"sy_shishi"] forState:UIControlStateNormal];
//    [shiShiButton setTitle:@"实时" forState:UIControlStateNormal];
//    [shiShiButton setTitleColor:mainColor forState:UIControlStateNormal];
//    shiShiButton.titleLabel.font = Big14Font(self.scale);
    shiShiButton.userInteractionEnabled = NO;
    [topView addSubview:shiShiButton];
    
//    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(RM_Padding, shiShiButton.bottom, topView.width - 2*RM_Padding, 20*self.scale)];
//    timeLabel.textAlignment = NSTextAlignmentRight;
//    timeLabel.text = @"今天10：00";
//    timeLabel.font = SmallFont(self.scale);
//    timeLabel.textColor = whiteLineColore;
//    timeLabel.backgroundColor = clearColor;
//    [topView addSubview:timeLabel];
    
    //订单视图和地图的父视图
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom, bgView.width, bgView.width-RM_Padding*3)];
    _maskView.backgroundColor = whiteLineColore;
    [bgView addSubview:_maskView];
    [self setupOrderView];

    //底部两个选择按钮
    CellView *bottomCellView = [[CellView alloc] initWithFrame:CGRectMake(0, _maskView.bottom, bgView.width, 35*self.scale)];
    bottomCellView.topline.hidden = NO;
    bottomCellView.bottomline.hidden = YES;
    [bgView addSubview:bottomCellView];
    
    bgView.height = bottomCellView.bottom;
    
    float buttonWidth = (bottomCellView.width - 0.5)/2;
    for (int i = 0 ; i < 2; i ++) {
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake((buttonWidth + 0.5)*i, 0, buttonWidth, bottomCellView.height)];
        NSString *titleStr = i == 0?@"订单详情":@"订单地图";
        [menuButton setTitle:titleStr forState:UIControlStateNormal];
        menuButton.titleLabel.font = Big14Font(self.scale);
        [menuButton setTitleColor:blackTextColor forState:UIControlStateNormal];
        [menuButton setTitleColor:matchColor forState:UIControlStateSelected];
        [menuButton addTarget:self action:@selector(menuButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        menuButton.tag = 30 + i;
        if (i == 0) {
            menuButton.selected = YES;
            _selectButton = menuButton;
        }
        UIImageView *middleLine = [[UIImageView alloc] initWithFrame:CGRectMake(menuButton.right, RM_Padding, 0.5, bottomCellView.height - 2*RM_Padding)];
        middleLine.backgroundColor = blackLineColore;
        [bottomCellView addSubview:middleLine];
        [bottomCellView addSubview:menuButton];
    }
}
-(void)setupOrderView{
    NSString * orderType = [[NSString stringWithFormat:@"%@",_dataDic[@"Type"]]getValiedString];
    NSInteger orderTypeIndex = [orderType integerValue];
    
    _orderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _maskView.width, _maskView.height)];
    _orderView.backgroundColor = clearColor;
    [_maskView addSubview:_orderView];
    
    CellView *addressCellView = [[CellView alloc] initWithFrame:CGRectMake(0, 0, _orderView.width, 85*self.scale)];
    addressCellView.bottomline.hidden = NO;
    [_orderView addSubview:addressCellView];
    //起点图片
    UIImageView *startImageView = [[UIImageView alloc] initWithFrame:CGRectMake(RM_Padding, RM_Padding, 46/2.25*self.scale, 71/2.25*self.scale)];
    startImageView.image = [UIImage imageNamed:@"sy_qidian"];
    startImageView.contentMode = UIViewContentModeScaleAspectFit;
    [addressCellView addSubview:startImageView];
    
    
    //起点文字
//    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2*self.scale, startImageView.width, 15*self.scale)];
//    startLabel.text = @"起";
//    startLabel.textAlignment = NSTextAlignmentCenter;
//    startLabel.textColor = whiteLineColore;
//    startLabel.font = DefaultFont(self.scale);
//    [startImageView addSubview:startLabel];
    //起点地址
    UILabel *startAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(startImageView.right+RM_Padding, 2*self.scale, _orderView.width - startImageView.right - 2*RM_Padding, 20*self.scale)];
    startAddressLabel.textColor = blackTextColor;
    startAddressLabel.numberOfLines = 1;
    startAddressLabel.font = DefaultFont(self.scale);
    [addressCellView addSubview:startAddressLabel];
    
    startAddressLabel.text = [[NSString stringWithFormat:@"%@",_dataDic[@"QIAddress"]] getValiedString];
    [startAddressLabel sizeToFit];
    //    if (startAddressLabel.height!=40*self.scale) {
    //        startAddressLabel.height=40*self.scale;
    //    }
    startAddressLabel.centerY=startImageView.centerY;
    
    
    //终点图片
    UIImageView *endImageView = [[UIImageView alloc] initWithFrame:CGRectMake(RM_Padding, startImageView.bottom, startImageView.width, startImageView.height)];
    endImageView.image = [UIImage imageNamed:@"sy_zhongdian"];
    endImageView.contentMode = UIViewContentModeScaleAspectFit;
    [addressCellView addSubview:endImageView];
//    //终点文字
//    UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, endImageView.height - startLabel.height - 2*self.scale, startLabel.width, startLabel.height)];
//    endLabel.text = @"终";
//    endLabel.textAlignment = NSTextAlignmentCenter;
//    endLabel.textColor = whiteLineColore;
//    endLabel.font = DefaultFont(self.scale);
//    [endImageView addSubview:endLabel];
    //终点地址
    UILabel *endAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(startAddressLabel.left, startAddressLabel.bottom, _orderView.width - endImageView.right - 2*RM_Padding, 20*self.scale)];
    endAddressLabel.textColor = blackTextColor;
    endAddressLabel.numberOfLines = 1;
    endAddressLabel.font = DefaultFont(self.scale);
    [addressCellView addSubview:endAddressLabel];
    endAddressLabel.text = [[NSString stringWithFormat:@"%@",_dataDic[@"ZhongAddress"]] getValiedString];
    [endAddressLabel sizeToFit];
//    if (endAddressLabel.height!=40*self.scale) {
//        endAddressLabel.height=40*self.scale;
//    }
    endAddressLabel.centerY=endImageView.centerY;
    
    
    //订单价格信息
    UILabel *orderDecLabel = [[UILabel alloc] initWithFrame:CGRectMake(RM_Padding, addressCellView.bottom, _orderView.width - 2*RM_Padding, 25*self.scale)];
    
    NSString * xingCheng = @"";
    NSString * price = [[NSString stringWithFormat:@"%@",_dataDic[@"Money"]] getValiedString];
    NSString * addPrice = [[NSString stringWithFormat:@"%@",_dataDic[@"AddMoney"]] getValiedString];
    if (orderTypeIndex==0 || orderTypeIndex==1 || orderTypeIndex==2 || orderTypeIndex==3) {  /// 买送取
       xingCheng = [[NSString stringWithFormat:@"%@",_dataDic[@"SongJuLi"]] getValiedString];
    }else{
       xingCheng = [[NSString stringWithFormat:@"%@",_dataDic[@"QuJuLi"]] getValiedString];
    }
    if (orderTypeIndex==OrderTypeHelp || orderTypeIndex==OrderTypeQueueUp) {
        startImageView.image=[UIImage imageNamed:@"sy_paiduixinxi"];
        endImageView.image=[UIImage imageNamed:@"sy_paiduishichang"];
        NSString * bangShi = [[NSString stringWithFormat:@"%@",_dataDic[@"BangShiChang"]]getValiedString];
        NSString * bangXinXi = [[NSString stringWithFormat:@"%@",_dataDic[@"BangXinxi"]] getValiedString];
        
        startAddressLabel.text=[NSString stringWithFormat:@"帮忙信息:%@",bangXinXi];
        endAddressLabel.text=[NSString stringWithFormat:@"帮忙时长:%@分钟",bangShi];
        if(orderTypeIndex==OrderTypeQueueUp){
            
            startAddressLabel.text=[NSString stringWithFormat:@"排队信息:%@",bangXinXi];
            
            
            endAddressLabel.text=[NSString stringWithFormat:@"排队时长:%@分钟",bangShi];
        }
        [startAddressLabel sizeToFit];
        [endAddressLabel sizeToFit];
    }

    
    
    orderDecLabel.attributedText = [[NSString stringWithFormat:@"<gray13>路程大约</gray13><orang20>%@</orang20><gray13>公里，费用</gray13><orang20>%@</orang20><gray13>元，加价</gray13><orang20>%@</orang20><gray13>元</gray13>",
                                     xingCheng,
                                     price,
                                     addPrice]
                                    attributedStringWithStyleBook:[self Style]];
    [addressCellView addSubview:orderDecLabel];
    
    
    //商品价格
    UILabel *goodsPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(RM_Padding, orderDecLabel.bottom, _orderView.width - 2*RM_Padding, 25*self.scale)];
    goodsPriceLabel.attributedText = [[NSString stringWithFormat:@"<gray13>商品价格：%@元</gray13><blue13>(用户已付)</blue13>",[[NSString stringWithFormat:@"%@",_dataDic[@"GoodsMoney"]] getValiedString]] attributedStringWithStyleBook:[self Style]];
    [addressCellView addSubview:goodsPriceLabel];
    //购买商品
    UILabel *goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(RM_Padding, goodsPriceLabel.bottom, _orderView.width - 2*RM_Padding, goodsPriceLabel.height)];
    goodsNameLabel.attributedText = [[NSString stringWithFormat:@"<gray13>购买商品：</gray13><blue13>%@</blue13>",[[NSString stringWithFormat:@"%@",_dataDic[@"GoodsName"]] getValiedString]] attributedStringWithStyleBook:[self Style]];
    [addressCellView addSubview:goodsNameLabel];
    
    
    
    //订单备注信息信息
    UILabel *orderBeiZhuLabel = [[UILabel alloc] initWithFrame:CGRectMake(RM_Padding, goodsNameLabel.bottom, _orderView.width - 2*RM_Padding, 25*self.scale)];

  

    orderBeiZhuLabel.text = [[NSString stringWithFormat:@"备注：%@",_dataDic[@"Desc"]] getValiedString];
    orderBeiZhuLabel.textColor = grayTextColor;
    orderBeiZhuLabel.font = DefaultFont(self.scale);
    [addressCellView addSubview:orderBeiZhuLabel];
    
    goodsNameLabel.hidden=orderTypeIndex != 0;
    goodsPriceLabel.hidden=orderTypeIndex != 0;
    orderBeiZhuLabel.top=orderTypeIndex==0?goodsNameLabel.bottom:orderDecLabel.bottom;
    orderBeiZhuLabel.hidden=orderTypeIndex == 3;
    
    if (orderTypeIndex == OrderTypeBring || orderTypeIndex == OrderTypeTake) {
        
        
        UILabel * labelYiSui = [[UILabel alloc]initWithFrame:orderDecLabel.frame];
        [addressCellView addSubview:labelYiSui];
        labelYiSui.top=orderDecLabel.bottom;
        labelYiSui.font=DefaultFont(self.scale);
        labelYiSui.textColor=grayTextColor;
        NSString * isShui =[NSString stringWithFormat:@"%@",_dataDic[@"IsYiSui"]];
        labelYiSui.text=[NSString stringWithFormat:@"是否易碎:%@",[isShui isEqualToString:@"0"]?@"否":@"是"];
        [labelYiSui sizeToFit];
        
        UILabel * labelBaoWen = [[UILabel alloc]initWithFrame:labelYiSui.frame];
        [addressCellView addSubview:labelBaoWen];
        labelBaoWen.font=DefaultFont(self.scale);
        labelBaoWen.textColor=grayTextColor;
        NSString * isBaoWen =[NSString stringWithFormat:@"%@",_dataDic[@"BaoWenBox"]];
        labelBaoWen.text=[NSString stringWithFormat:@"是否保温:%@",isBaoWen];
        [labelBaoWen sizeToFit];
        labelBaoWen.left=labelYiSui.right+10*self.scale;
        
        orderBeiZhuLabel.top=labelBaoWen.bottom;
        
    }
    
    
}
#pragma mark -- 关闭按钮事件
-(void)closeButtonEvent:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(TongSongShiShiOrderViewControllerDelete)]) {
        [_delegate TongSongShiShiOrderViewControllerDelete];
    }
}
#pragma mark -- 选择按钮事件
-(void)menuButtonEvent:(UIButton *)button{
    _selectButton.selected = NO;
    if (_selectButton != button) {
        _selectButton = button;
    }
    _selectButton.selected = YES;
    
    if (button.tag == 30) {
        _orderView.alpha = 1;
        _mapView.alpha = 0;
    }else{
        _orderView.alpha = 0;
        [self setupMapView];
        _mapView.alpha = 1;
    }
}
#pragma mark -- 抢单事件
-(void)startQiangDanEvent:(UIButton *)button{
    NSDictionary * dic = @{@"PeiSongId":[Stockpile sharedStockpile].userID,
                           @"OrderId":_orderId};
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject qingdanWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        if (CODE(ret)) {
            if (_delegate && [_delegate respondsToSelector:@selector(TongSongShiShiOrderViewControllerQiangDanResultWithOrderId:isTexi:)]) {
                NSInteger type =[[NSString stringWithFormat:@"%@",_dataDic[@"Type"]] integerValue];
                NSString * orderId = [NSString stringWithFormat:@"%@",_dataDic[@"OrderId"]];
                [_delegate TongSongShiShiOrderViewControllerQiangDanResultWithOrderId:orderId isTexi:type==3];
            }else{
                [CoreSVP showMessageInCenterWithMessage:@"代理设置失败"];
            }
        }else{
            [self ShowQiangDanResultMessage:@"抢单失败" WithCode:tanChuViewWithQiangDanFaile WithBlock:^{
                
            }];
        }
    }];
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -------------------------------------------------- 有关地图
#pragma mark -- 地图界面
-(void)setupMapView{
    if (_mapView) {
        return;
    }
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, _maskView.width, _maskView.height)];
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [_maskView addSubview:_mapView];
    
    //去除百度地图定位后的蓝色圆圈和定位蓝点(精度圈)
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    [_mapView updateLocationViewWithParam:displayParam];
    
    [self StratLuJingGuiHua];
}
#pragma mark -- 开始定位
-(void)startLocation{
    _locationService = [[BMKLocationService alloc] init];
    [_locationService startUserLocationService];
    _locationService.delegate =self;
    [_locationService startUserLocationService];
    
}
#pragma mark -- 已经得到定位
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [_mapView updateLocationData:userLocation];
}
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位失败");
}
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    [_mapView updateLocationData:userLocation];
//}

#pragma mark -- 路径规划
-(void)StratLuJingGuiHua{
    _routesearch = [[BMKRouteSearch alloc]init];
    _routesearch.delegate = self;
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    
    NSString * startLongitude = [[NSString stringWithFormat:@"%@",_dataDic[@"QILng"]]getValiedString];
    NSString * startLatitude = [[NSString stringWithFormat:@"%@",_dataDic[@"QILat"]] getValiedString];
    start.pt = CLLocationCoordinate2DMake([startLatitude floatValue], [startLongitude floatValue]);
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    
    
    NSString * endLongitude = [[NSString stringWithFormat:@"%@",_dataDic[@"ZhongLng"]]getValiedString];
    NSString * endLatitude = [[NSString stringWithFormat:@"%@",_dataDic[@"ZhongLat"]] getValiedString];
    end.pt = CLLocationCoordinate2DMake([endLongitude floatValue], [endLatitude floatValue]);
    
    BMKRidingRoutePlanOption *option = [[BMKRidingRoutePlanOption alloc]init];
    option.from = start;
    option.to = end;
    BOOL flag = [_routesearch ridingSearch:option];
    if (flag)
    {
        NSLog(@"骑行规划检索发送成功");
    }
    else
    {
        NSLog(@"骑行规划检索发送失败");
    }

}

/**
 *返回骑行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKRidingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetRidingRouteResult:(BMKRouteSearch *)searcher result:(BMKRidingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
   
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKRidingRouteLine* plan = (BMKRidingRouteLine*)[result.routes objectAtIndex:0];
        
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"招银大厦";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"不知道是哪里了";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation*)annotation getRouteAnnotationView:view];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = mainColor;
        polylineView.strokeColor = mainColor;
        polylineView.lineWidth = 2.0;
        return polylineView;
    }
    return nil;
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}
-(void)dealloc{
    _mapView.delegate = nil;
    _locationService.delegate = nil;
}
@end
