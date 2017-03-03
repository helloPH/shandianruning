//
//  BaiDuMapLocationManager.h
//  BaiduMapDemo
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#define single_interface(class)  + (class *)shared##class;

typedef void(^GeoCodeResultBlock)(BMKReverseGeoCodeResult *result);
typedef void(^ManagerBlock)(CLLocationCoordinate2D locationCoordinate2D,NSString * country,NSString *province,NSString * city,NSString *area,NSString *road,NSString *place);

@interface BaiDuMapLocationManager : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

#pragma mark - 单例
single_interface(BaiDuMapLocationManager);

#pragma mark - 允许百度定位，并且获得位置信息
-(void)AllowLocationAndGetAddress:(ManagerBlock)block;

#pragma mark - 根据经纬度获得地理位置信息
-(void)getAddressByCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate GeoCodeResultBlock:(GeoCodeResultBlock)geocodeblock;

#pragma mark - 停止定位
-(void)ForbidLocation;

#pragma mark - 指定两点之间的距离
- (CLLocationDistance) getCLLocationDistance:(CLLocationCoordinate2D)coordinateA TheTowCoordinate:(CLLocationCoordinate2D )coordinateB;
@end
