//
//  CXMotorcadeDestinationModel.m
//  Pods
//
//  Created by wshaolin on 2019/3/28.
//

#import "CXMotorcadeDestinationModel.h"

@implementation CXMotorcadeDestinationModel

- (CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.mclatitude, self.mclongitude);
}

@end
