//
//  CXMotorcadeCoordinateResponse.m
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXMotorcadeCoordinateResponse.h"

@implementation CXMotorcadeCoordinateResponse

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"members" : [CXMotorcadeCoordinateMember class]};
}

@end

@implementation CXMotorcadeCoordinateMember

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"coordinates" : [CXMotorcadeCoordinate class]};
}

@end

@implementation CXMotorcadeCoordinate

- (CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.lat, self.lng);
}

@end
