//
//  CXMotorcadeUpdateNameRequest.m
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXMotorcadeUpdateNameRequest.h"

@implementation CXMotorcadeUpdateNameRequest

- (instancetype)initWithMotorcadeId:(NSString *)motorcadeId name:(NSString *)name{
    if(self = [super init]){
        [self addParam:motorcadeId forKey:@"motorcadeId"];
        [self addParam:name forKey:@"name"];
    }
    
    return self;
}

- (CXHTTPMethod)method{
    return CXHTTPMethod_POST;
}

- (NSString *)path{
    return @"/motorcadeServer/app/motorcadeManage/updateMotorcadeName";
}

@end
