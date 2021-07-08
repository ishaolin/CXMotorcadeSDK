//
//  CXMotrocadeOnlineRequest.m
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXMotrocadeOnlineRequest.h"

@implementation CXMotrocadeOnlineRequest

- (CXHTTPMethod)method{
    return CXHTTPMethod_POST;
}

- (NSString *)path{
    return @"/carlife/motorcade/online";
}

- (id)modelWithData:(id)data{
    return [CXMotorcadeOnlineModel cx_modelWithData:data];
}

@end
