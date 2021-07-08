//
//  CXUpdateMotorcadeInfoRequest.m
//  Pods
//
//  Created by wshaolin on 2019/4/8.
//

#import "CXUpdateMotorcadeInfoRequest.h"

@implementation CXUpdateMotorcadeInfoRequest

- (instancetype)initWithMotorcadeInfo:(NSDictionary<NSString *, id> *)info{
    if(self = [super init]){
        NSString *json = [NSJSONSerialization cx_stringWithJSONObject:info];
        [self addParam:json forKey:@"motorCade"];
    }
    
    return self;
}

- (CXHTTPMethod)method{
    return CXHTTPMethod_POST;
}

- (NSString *)path{
    return @"/carlife/motorcade/updateMotorcade";
}

@end
