//
//  CXMotrocadeMapNaviVC.h
//  Pods
//
//  Created by wshaolin on 2019/4/12.
//

#import <CXMapKit/CXMapKit.h>

@class CXMotorcadeOnlineResultModel, CXMotorcadeUserInfoModel;

@interface CXMotrocadeMapNaviVC : CXMapNaviViewController

- (instancetype)initWithEndCoordinate:(CLLocationCoordinate2D)endCoordinate;

@property (nonatomic, strong) CXMotorcadeOnlineResultModel *onlineModel;

- (void)reloadMembers:(NSArray<CXMotorcadeUserInfoModel *> *)members;

@end
