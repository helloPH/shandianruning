//
//  orderDaoHangViewController.m
//  QQRunning
//
//  Created by 软盟 on 2016/12/24.
//  Copyright © 2016年 软盟. All rights reserved.
//

#import "orderDaoHangViewController.h"

#import "CellView.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPolyline.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <BaiduMapAPI_Base/BMKTypes.h>
#import <BaiduMapAPI_Search/BMKRouteSearchOption.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import "RouteAnnotation.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "BaiDuMapLocationManager.h"

@interface orderDaoHangViewController()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKRouteSearchDelegate>
@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) BMKLocationService *locationService;
@property (nonatomic,strong) BMKRouteSearch *routesearch;
@property (nonatomic,strong) BMKUserLocation *userLocation;
@end

@implementation orderDaoHangViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupNewNavi];
    [self setupMapView];
    [self startLocation];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    
    
//        _mapView.compassSize=CGSizeMake(50*self.scale, 50*self.scale);
    //    @property (nonatomic) CGPoint compassPosition;
    //    /// 指南针的宽高
    //    @property (nonatomic, readonly) CGSize compassSize;
}
#pragma mark -- 地图界面
-(void)setupMapView{
    if (_mapView) {
        return;
    }
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, self.NavImg.bottom, RM_VWidth, RM_VHeight - self.NavImg.bottom)];
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [_mapView setMapType:BMKMapTypeStandard];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    _mapView.zoomLevel=17;
    
    //地图定位按钮
    UIButton *mapLocationBtn = [[UIButton alloc] initWithFrame:CGRectMake(RM_Padding,_mapView.height - RM_Padding*2 - 82/2.25*self.scale, 82/2.25*self.scale, 82/2.25*self.scale)];
    [mapLocationBtn setImage:[UIImage imageNamed:@"dingwei_icon"] forState:UIControlStateNormal];
    [mapLocationBtn addTarget:self action:@selector(mapSuoFang) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:mapLocationBtn];


    
    //去除百度地图定位后的蓝色圆圈和定位蓝点(精度圈)
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    [_mapView updateLocationViewWithParam:displayParam];
    
    [self StratLuJingGuiHua];
    
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
    start.pt = CLLocationCoordinate2DMake(_startLatitude, _startLongitude);
    
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = CLLocationCoordinate2DMake(_endLatitude, _endLongitude);
    
    if (self.orderType==OrderTypeHelp || self.orderType==OrderTypeQueueUp) {
        start.pt=CLLocationCoordinate2DMake([[Stockpile sharedStockpile].latitude doubleValue], [[Stockpile sharedStockpile].longitude doubleValue]);
        end.pt=CLLocationCoordinate2DMake(_startLatitude, _startLongitude);
    }
    
    
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
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                item.title=transitStep.instruction;
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
                item.title=transitStep.instruction;
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            item.title=transitStep.entraceInstruction;
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
#pragma mark -- map delegate
-(void)mapViewDidFinishLoading:(BMKMapView *)mapView{
    [_mapView setCompassPosition:CGPointMake(180,200)];
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
}
-(void)viewWillDisappear:(BOOL)animated{
    _mapView.delegate = nil;
    _locationService.delegate = nil;
    _routesearch.delegate = nil;
}


@end
