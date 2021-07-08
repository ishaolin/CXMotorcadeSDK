//
//  CXCmdEnterMotorcadeRequest.m
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXCmdEnterMotorcadeRequest.h"

@implementation CXCmdEnterMotorcadeRequest

- (instancetype)initWithCommand:(NSString *)command{
    if(self = [super init]){
        [self addParam:command forKey:@"code"];
    }
    return self;
}

- (CXHTTPMethod)method{
    return CXHTTPMethod_POST;
}

- (NSString *)path{
    return @"/carlife/motorcade/enterMotorcadeWithCode";
}

- (id)modelWithData:(id)data{
    return [CXMotorcadeOnlineModel cx_modelWithData:data];
}

@end
