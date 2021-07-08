//
//  CXMotorcadeOfflineRequest.m
//  Pods
//
//  Created by wshaolin on 2019/4/1.
//

#import "CXMotorcadeOfflineRequest.h"

@implementation CXMotorcadeOfflineRequest

- (CXHTTPMethod)method{
    return CXHTTPMethod_POST;
}

- (NSString *)path{
    return @"/carlife/motorcade/offline";
}

@end
