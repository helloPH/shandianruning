//
//  BaiDuMapLocationManager.m
//  BaiduMapDemo
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BaiDuMapLocationManager.h"

#define single_implementation(class) \
static class *_instance; \
\
+ (class *)shared##class \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}

@interface BaiDuMapLocationManager()
@property(nonatomic,strong)BMKUserLocation *userLocation;
@property(nonatomic,strong)ManagerBlock block;
@property(nonatomic,strong)GeoCodeResultBlock geocodeblock;
@property(nonatomic,strong)BMKLocationService* locService;
@property(nonatomic,strong) BMKGeoCodeSearch* geocodesearch;
@end
@implementation BaiDuMapLocationManager
single_implementation(BaiDuMapLocationManager);
-(id)init{
    self=[super init];
    if (self) {
        
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        _geocodesearch=[[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate=self;
        
    }
    return self;
}
-(void)dealloc{
    
}
-(void)AllowLocationAndGetAddress:(ManagerBlock)block{
    _block=block;
    _locService.delegate = self;
    _geocodesearch.delegate=self;
    [_locService startUserLocationService];
}
#pragma mark - 停止定位
-(void)ForbidLocation{
    [_locService stopUserLocationService];
    _locService.delegate=nil;
    _geocodesearch.delegate=nil;
}
#pragma mark - 定位
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    _userLocation=userLocation;
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _userLocation=userLocation;
    [self getAddressByCLLocationCoordinate2D:userLocation.location.coordinate GeoCodeResultBlock:^(BMKReverseGeoCodeResult *result) {
        if (_block) {
            NSString *country = result.addressDetail.country;//国家
            NSString *province=result.addressDetail.province;//省
            NSString *city = result.addressDetail.city;//市
            NSString *area = result.addressDetail.district;//区
            NSString *road = result.addressDetail.streetName;//路
            NSString *place = result.addressDetail.streetNumber;//位置
//            if (result.poiList.count>0) {
//                BMKPoiInfo *info = [result.poiList firstObject];
//                place = info.name;
//            }
            _block(_userLocation.location.coordinate,country,province,city,area,road,place);
        }
    }];
}
#pragma mark - 根据经纬度获得地理位置信息
-(void)getAddressByCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate GeoCodeResultBlock:(GeoCodeResultBlock)geocodeblock{
    _geocodeblock=geocodeblock;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        NSLog(@"获取地理信息成功");
    }else{
        NSLog(@"获取地理信息失败");
    }
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (_geocodeblock) {
        if (error == BMK_SEARCH_NO_ERROR){
            _geocodeblock(result);
            if (result.address.length>0) {
                [self ForbidLocation];
            }
        }else{
            _geocodeblock(nil);
        }
        
    }
}
#pragma mark - 指定两点之间的距离
- (CLLocationDistance) getCLLocationDistance:(CLLocationCoordinate2D)coordinateA TheTowCoordinate:(CLLocationCoordinate2D )coordinateB{
    CLLocationDistance dis;
    dis = BMKMetersBetweenMapPoints(BMKMapPointForCoordinate(coordinateA), BMKMapPointForCoordinate(coordinateB)) ;
    return dis;
}
@end
