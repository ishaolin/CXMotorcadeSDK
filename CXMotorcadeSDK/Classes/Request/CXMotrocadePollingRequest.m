//
//  CXMotrocadePollingRequest.m
//  Pods
//
//  Created by wshaolin on 2019/4/1.
//

#import "CXMotrocadePollingRequest.h"

@implementation CXMotrocadePollingRequest

- (CXHTTPMethod)method{
    return CXHTTPMethod_POST;
}

- (NSString *)path{
    return @"/carlife/motorcade/pollOnline";
}

- (id)modelWithData:(id)data{
    return [CXMotrocadePollingModel cx_modelWithData:data];
}

@end
