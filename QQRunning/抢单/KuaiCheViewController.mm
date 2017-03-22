//
//  KuaiCheViewController.m
//  QQRunning
//
//  Created by wdx on 2017/2/9.
//  Copyright © 2017年 软盟. All rights reserved.
//

#import "KuaiCheViewController.h"
#import "CellView.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPolyline.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduMapAPI_Base/BMKTypes.h>
#import <BaiduMapAPI_Search/BMKRouteSearchOption.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import "RouteAnnotation.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "orderDaoHangViewController.h"
#import "BaiDuMapLocationManager.h"
#import "KuaiCheSuccess.h"

@interface KuaiCheViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKRouteSearchDelegate>
@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) BMKLocationService *locationService;
@property (nonatomic,strong) BMKRouteSearch *routesearch;
@property (nonatomic,strong) BMKUserLocation *userLocation;

@property (nonatomic,strong) NSMutableDictionary * dataDic;
@property (nonatomic,assign)BOOL isShangChe;
@end

@implementation KuaiCheViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    
    [self setupNewNavi];
    [self setupMapView];
    [self startLocation];
    
    [self reshData];
}
-(void)initData{
    _dataDic = [NSMutableDictionary dictionary];
    _isShangChe=NO;
}
-(void)reshData{
    NSDictionary * dic = @{@"OrderId":_orderId};
    [self startDownloadDataWithMessage:nil];
    [AnalyzeObject getUnFinishOrderDetailWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopDownloadData];
        [_dataDic removeAllObjects];
        if (CODE(ret)) {
            [_dataDic addEntriesFromDictionary:model];
        }else{
            [CoreSVP showMessageInCenterWithMessage:msg];
        }
        [self reshView];
    }];
    
    
}
-(void)reshView{
    NSString * status = [NSString stringWithFormat:@"%@",_dataDic[@"Status"]];
    
    if ([status  isEqualToString:@"8"]) {
            [CoreSVP showMessageInCenterWithMessage:@"用户已取消该订单!"];
    }
    
    
    UIButton * bottomLeft = [self.view viewWithTag:200];
    bottomLeft.enabled=NO;
    
    UIButton * bottomRight = [self.view viewWithTag:201];
    bottomRight.enabled=NO;
    bottomRight.userInteractionEnabled=YES;
    
    if ([status isEqualToString:@"1"]) { //  订单未完成
        self.TitleLabel.text=@"去接乘客";
        _isShangChe=NO;
        bottomRight.enabled=YES;
        bottomRight.userInteractionEnabled=NO;
        
        bottomLeft.enabled=YES;
    }else if ([status isEqualToString:@"4"]){ // 乘客已上车
         self.TitleLabel.text=@"乘客已上车";
        _isShangChe=YES;
        bottomRight.enabled=YES;
    }else if ([status isEqualToString:@"7"]){ /// 订单已完成 到达目的地
        
        self.TitleLabel.text=@"完成行程";
        _isShangChe=YES;
//         self.TitleLabel.text=[NSString stringWithFormat:@"本行程入账%@元确定到达目的地",[[NSString stringWithFormat:@"%@",_dataDic[@""]] getValiedString]];
    }
    
    
//    [self StratLuJingGuiHua];
    
    UIImageView * beginImg = [self.view viewWithTag:40];
    
    UILabel * begin = [self.view viewWithTag:50];
    begin.text = [NSString stringWithFormat:@"%@",_dataDic[@"QIAddress"]];
//    [begin sizeToFit];
    begin.centerY=beginImg.centerY;
    
    
    UIImageView * endImg = [self.view viewWithTag:41];
    
    UILabel * end   = [self.view viewWithTag:51];
    end.text = [NSString stringWithFormat:@"%@",_dataDic[@"ZhongAddress"]];
//    [end sizeToFit];
    end.centerY=endImg.centerY;
    
}
#pragma mark -- 地图界面
-(void)setupMapView{
    if (_mapView) {
        return;
    }
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight - self.NavImg.bottom)];
    
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    _mapView.zoomLevel=17;
    
    //地图定位按钮
    UIButton *mapLocationBtn = [[UIButton alloc] initWithFrame:CGRectMake(RM_Padding,_mapView.height - RM_Padding*2 - 82/2.25*self.scale, 82/2.25*self.scale, 82/2.25*self.scale)];
    [mapLocationBtn setImage:[UIImage imageNamed:@"dingwei_icon"] forState:UIControlStateNormal];
    [mapLocationBtn addTarget:self action:@selector(mapSuoFang) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:mapLocationBtn];
    

        // 顶部的 view
        CellView * topView = [[CellView alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth, 80*self.scale)];
        topView.backgroundColor=[UIColor whiteColor];
        [_mapView addSubview:topView];
        topView.topline.hidden = NO;
        topView.bottomline.hidden = NO;
        [_mapView addSubview:topView];
        
        UIImageView * startPointImageView = [UIImageView new];
        startPointImageView.image = [UIImage imageNamed:@"qidian"];
        startPointImageView.contentMode = UIViewContentModeScaleAspectFit;
        [topView addSubview:startPointImageView];
        startPointImageView.tag=40;
    
        UILabel * startLabel = [UILabel new];
        startLabel.text = @"起";
        startLabel.textAlignment = NSTextAlignmentCenter;
        startLabel.textColor = whiteLineColore;
        startLabel.font = DefaultFont(self.scale);
        [startPointImageView addSubview:startLabel];

        
        UIImageView * endPointImageView = [UIImageView new];
        endPointImageView.image = [UIImage imageNamed:@"zhongdian"];
        endPointImageView.contentMode = UIViewContentModeScaleAspectFit;
        [topView addSubview:endPointImageView];
        endPointImageView.tag=41;
    
        UILabel * endLabel = [UILabel new];
        endLabel.text = @"终";
        endLabel.textAlignment = NSTextAlignmentCenter;
        endLabel.textColor = whiteLineColore;
        endLabel.font = DefaultFont(self.scale);
        [endPointImageView addSubview:endLabel];
        
        UILabel * beginPointLabel = [UILabel new];
        beginPointLabel.textColor = blackTextColor;
        beginPointLabel.numberOfLines = 1;
        beginPointLabel.font = DefaultFont(self.scale);
        [topView addSubview:beginPointLabel];
        beginPointLabel.tag=50;
    
        UILabel * endPointLabel = [UILabel new];
        endPointLabel.textColor = blackTextColor;
        endPointLabel.numberOfLines = 1;
        endPointLabel.font = DefaultFont(self.scale);
        [topView addSubview:endPointLabel];
        endPointLabel.tag=51;
    
        
        startPointImageView.frame = CGRectMake(RM_Padding, RM_Padding, 23*self.scale, 26.5*self.scale);
        startLabel.frame = CGRectMake(0, 2*self.scale, startPointImageView.width, 15*self.scale);
        beginPointLabel.frame = CGRectMake(startPointImageView.right+RM_Padding, 0, topView.width - startPointImageView.right - 2*RM_Padding-110*self.scale, 30*self.scale);
        if (beginPointLabel.height != 40*self.scale) {
            beginPointLabel.height = 40*self.scale;
        }
        endPointImageView.frame = CGRectMake(RM_Padding, startPointImageView.bottom, startPointImageView.width, startPointImageView.height);
        endLabel.frame = CGRectMake(0, endPointImageView.height - startLabel.height - 2*self.scale, endPointImageView.width, startLabel.height);
        endPointLabel.frame = CGRectMake(beginPointLabel.left, beginPointLabel.bottom, topView.width - endPointImageView.right - 2*RM_Padding-110*self.scale, beginPointLabel.height);
        if (endPointLabel.height != 40*self.scale) {
            endPointLabel.height = 40*self.scale;
        }
        
        
        
        for (int i = 0 ; i < 2; i ++) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40*self.scale, 40*self.scale)];
            [topView addSubview:btn];
            btn.tag=100+i;
            [btn addTarget:self action:@selector(topViewBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.centerY=topView.height/2;
            btn.right=i==0?topView.width-btn.width*2:topView.width-btn.width/2;
            [btn setBackgroundImage:[UIImage imageNamed:i==0?@"kc_dianhua":@"kc_diwei"] forState:UIControlStateNormal];
        }
        
        
        
    UIView * bottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth, 40*self.scale)];
    bottom.backgroundColor=[UIColor whiteColor];
    bottom.bottom=_mapView.height;
    [_mapView addSubview:bottom];
    
    for (int i =0; i < 2; i ++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(i==0?0:RM_VWidth/3, 0, i==0?RM_VWidth/3:RM_VWidth/3*2,bottom.height )];
        [bottom addSubview:btn];
        [btn setBackgroundImage:[UIImage ImageForColor:i==0?mainColor:matchColor] forState:UIControlStateNormal];
//        btn.userInteractionEnabled=NO;
        btn.enabled=NO;
        [btn setTitle:i==0?@"乘客已上车":@"乘客已到达目的地" forState:UIControlStateNormal];
        btn.tag=200+i;
        [btn addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
//    UIButton * bottomView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, RM_VWidth, 40*self.scale)];
//        bottomView.bottom=_mapView.height;
//        bottomView.tag=200;
//        [bottomView setBackgroundImage:[UIImage ImageForColor:mainColor] forState:UIControlStateNormal];
//        [_mapView addSubview:bottomView];
//        [bottomView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        mapLocationBtn.bottom=bottomView.top-10*self.scale;
//    [bottomView addTarget:self action:@selector(bottomAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    //去除百度地图定位后的蓝色圆圈和定位蓝点(精度圈)
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    [_mapView updateLocationViewWithParam:displayParam];
    
    [self StratLuJingGuiHua];
}
-(void)topViewBtn:(UIButton *)sender{
//    [CoreSVP showMessageInCenterWithMessage:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    
    if (sender.tag==100) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_dataDic[@"UserTel"]];
        if ([_dataDic[@"UserTel"] isEmptyString]) {
            [CoreSVP showMessageInCenterWithMessage:@"手机号不存在"];
            return;
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    if (sender.tag==101) {
        orderDaoHangViewController * daoHang = [orderDaoHangViewController new];
        
        daoHang.startLatitude=[[NSString stringWithFormat:@"%@",_dataDic[@"QILat"]] doubleValue];
        daoHang.startLongitude=[[NSString stringWithFormat:@"%@",_dataDic[@"QILng"]] doubleValue];
        
        
        daoHang.endLatitude=[[NSString stringWithFormat:@"%@",_dataDic[@"ZhongLat"]] doubleValue];
        daoHang.endLongitude=[[NSString stringWithFormat:@"%@",_dataDic[@"ZhongLng"]] doubleValue];
        
        [self.navigationController pushViewController:daoHang animated:YES];
    }
    
}
-(void)bottomAction:(UIButton *)sender{
    if (sender.tag==200) {
        _isShangChe=NO;
    }else{
        _isShangChe=YES;
    }
    if (!_isShangChe) {
        NSDictionary * dic = @{@"PeiSongId":[Stockpile sharedStockpile].userID,
                               @"OrderId":_dataDic[@"OrderId"]};
        [self startDownloadDataWithMessage:nil];
        [AnalyzeObject kuaiCheShangCheWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopDownloadData];
            if (CODE(ret)) {
                    [self reshData];
                [CoreSVP showMessageInCenterWithMessage:@"乘客以上车"];
            }else{
                [CoreSVP showMessageInCenterWithMessage:msg];
            }
            

        }];
    }else{
        BaiDuMapLocationManager * manager = [BaiDuMapLocationManager sharedBaiDuMapLocationManager];

        
        [manager AllowLocationAndGetAddress:^(CLLocationCoordinate2D locationCoordinate2D, NSString *country, NSString *province, NSString *city, NSString *area, NSString *road, NSString *place) {
         
            [[Stockpile sharedStockpile] setCity:city];
            [[Stockpile sharedStockpile] setArea:area];
            [[Stockpile sharedStockpile] setRode:road];
            [[Stockpile sharedStockpile] setPlace:place];
            [[Stockpile sharedStockpile] setLatitude:[NSString stringWithFormat:@"%@",@(locationCoordinate2D.latitude)]];
            [[Stockpile sharedStockpile] setLongitude:[NSString stringWithFormat:@"%@",@(locationCoordinate2D.longitude)]];
            
            
            NSDictionary * dic = @{@"PeiSongId":[Stockpile sharedStockpile].userID,
                                   @"OrderId":_dataDic[@"OrderId"],
                                   @"longtitude":[Stockpile sharedStockpile].longitude,
                                   @"latitude":[Stockpile sharedStockpile].latitude,
                                   };
            
            [self startDownloadDataWithMessage:nil];
            [AnalyzeObject kuaiCheDaoDaWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
                [self stopDownloadData];
                if (CODE(ret)) {
                    [self reshData];
                    [CoreSVP showMessageInCenterWithMessage:@"乘客已到达目的地"];
                }else{
                    [CoreSVP showMessageInCenterWithMessage:msg];

                }
            }];
        }];
        
        
    }
}
-(void)mapSuoFang{
    BMKCoordinateRegion region;
    region.center.longitude = _userLocation.location.coordinate.longitude;
    region.center.latitude = _userLocation.location.coordinate.latitude;
    region.span.longitudeDelta = 0.03;
    region.span.latitudeDelta = 0.03;
    _mapView.region = region;
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
    _userLocation = userLocation;
    [_mapView updateLocationData:userLocation];
}
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位失败");
}
#pragma mark -- 路径规划
-(void)StratLuJingGuiHua{
    _routesearch = [[BMKRouteSearch alloc]init];
    _routesearch.delegate = self;
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = CLLocationCoordinate2DMake([[Stockpile sharedStockpile].latitude floatValue], [[Stockpile sharedStockpile].longitude floatValue]);
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = CLLocationCoordinate2DMake([[NSString stringWithFormat:@"%@",_dataDic[@"ZhongLat"]] floatValue], [[NSString stringWithFormat:@"%@",_dataDic[@"ZhongLng"]] floatValue]);

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

#pragma mark -- 导航
-(void)setupNewNavi
{
    
    
    self.TitleLabel.text = @"订单地图";
    UIButton *popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateNormal];
    [popButton setImage:[UIImage imageNamed:@"personal_back"] forState:UIControlStateHighlighted];
    popButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [popButton addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popButton];
    
}
-(void)PopVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    if (_block && [[NSString stringWithFormat:@"%@",_dataDic[@"Status"]]isEqualToString:@"7"]) {
        _block();
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    _mapView.delegate = nil;
    _locationService.delegate = nil;
    _routesearch.delegate = nil;
}
@end
