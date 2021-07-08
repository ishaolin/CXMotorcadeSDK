//
//  CXMotorcadeCoordinateResponse.h
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import <CoreLocation/CoreLocation.h>
#import "CXBaseUserJSONModel.h"

@class CXMotorcadeCoordinateMember;
@class CXMotorcadeCoordinate;

@interface CXMotorcadeCoordinateResponse : NSObject

@property (nonatomic, assign) long timestamp;
@property (nonatomic, assign) NSInteger gmeChannelId;
@property (nonatomic, copy) NSString *carTeamId;
@property (nonatomic, copy) NSArray<CXMotorcadeCoordinateMember *> *members;

@end

@interface CXMotorcadeCoordinateMember : CXBaseUserJSONModel

@property (nonatomic, copy) NSArray<CXMotorcadeCoordinate *> *coordinates;

@end

@interface CXMotorcadeCoordinate : NSObject

@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;

- (CLLocationCoordinate2D)coordinate;

@end
