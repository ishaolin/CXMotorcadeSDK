//
//  CXEnterMotorcadeRequest.m
//  Pods
//
//  Created by wshaolin on 2019/3/29.
//

#import "CXEnterMotorcadeRequest.h"

@implementation CXEnterMotorcadeRequest

- (CXHTTPMethod)method{
    return CXHTTPMethod_POST;
}

- (NSString *)path{
    return @"/motorcadeServer/app/motorcade/user/v2/enterMotorcade";
}

- (id)modelWithData:(id)data{
    return [CXMotorcadeOnlineModel cx_modelWithData:data];
}

@end
