//
//  CXExitMotorcadeRequest.m
//  Pods
//
//  Created by wshaolin on 2019/4/8.
//

#import "CXExitMotorcadeRequest.h"

@implementation CXExitMotorcadeRequest

- (CXHTTPMethod)method{
    return CXHTTPMethod_POST;
}

- (NSString *)path{
    return @"/carlife/motorcade/exitMotorcade";
}

@end
