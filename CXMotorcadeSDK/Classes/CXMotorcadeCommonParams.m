//
//  CXMotorcadeCommonParams.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeCommonParams.h"
#import <CXNetSDK/CXNetSDK.h>
#import <CXFoundation/CXFoundation.h>
#import <CXAntiSDK/CXAntiSDK.h>
#import <CXMapKit/CXLocationManager.h>
#import "CXMotorcadeManager.h"

@implementation CXMotorcadeCommonParams

+ (NSMutableDictionary<NSString *, id> *)commonParams{
    NSMutableDictionary<NSString *, id> *commonParams = [NSMutableDictionary dictionary];
    [commonParams cx_setString:[CXNetworkReachabilityManager networkReachabilityStatusString] forKey:@"netType"];
    [commonParams cx_setString:[UIDevice currentDevice].cx_hardwareString forKey:@"hardWareModel"];
    [commonParams cx_setString:[UIDevice currentDevice].systemName forKey:@"os"]; // iOS/iPhone OS
    [commonParams cx_setString:[UIDevice currentDevice].systemVersion forKey:@"osVersion"];
    [commonParams cx_setString:[UIDevice currentDevice].cx_identifier forKey:@"imei"];
    [commonParams cx_setString:[NSBundle mainBundle].cx_buildVersion forKey:@"appVersionCode"];
    [commonParams cx_setString:[NSBundle mainBundle].cx_appVersion forKey:@"appVersion"];
    [commonParams cx_setString:[CXMotorcadeManager sharedManager].token forKey:@"token"];
    [commonParams cx_setObject:@([CXLocationManager sharedManager].location.coordinate.latitude).stringValue forKey:@"lat"];
    [commonParams cx_setObject:@([CXLocationManager sharedManager].location.coordinate.longitude).stringValue forKey:@"lng"];
    [commonParams cx_setString:[CXLocationManager sharedManager].reverseGeoCodeResult.citycode forKey:@"cityCode"];
    [commonParams cx_setString:[CXLocationManager sharedManager].reverseGeoCodeResult.adcode forKey:@"adCode"];
    [commonParams cx_setObject:@(1) forKey:@"locType"]; // 固定是gps定位
    [commonParams cx_setObject:@(3) forKey:@"source"];
    [commonParams cx_setObject:@([NSDate cx_timeStampForMillisecond]) forKey:@"timestamp"];
    [commonParams addEntriesFromDictionary:[CXAntiFraudManager antiFraudDataParam]]; // 反作弊参数
    return commonParams;
}

@end
