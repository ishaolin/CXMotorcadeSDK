//
//  CXDissolveMotorcadeRequest.m
//  Pods
//
//  Created by wshaolin on 2019/4/8.
//

#import "CXDissolveMotorcadeRequest.h"

@implementation CXDissolveMotorcadeRequest

- (CXHTTPMethod)method{
    return CXHTTPMethod_POST;
}

- (NSString *)path{
    return @"/carlife/motorcade/dismissMotorcade";
}

@end
