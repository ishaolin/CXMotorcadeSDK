//
//  CXMotorcadeDestinationModel.h
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import <CoreLocation/CoreLocation.h>

@interface CXMotorcadeDestinationModel : NSObject

@property (nonatomic, assign) double mclatitude;
@property (nonatomic, assign) double mclongitude;
@property (nonatomic, copy) NSString *destinationName;

- (CLLocationCoordinate2D)coordinate;

@end
