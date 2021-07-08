//
//  CXMotorcadeKickOutRequest.m
//  Pods
//
//  Created by wshaolin on 2019/4/17.
//

#import "CXMotorcadeKickOutRequest.h"

@implementation CXMotorcadeKickOutRequest

- (instancetype)initWithMotorcadeId:(NSString *)motorcadeId userIds:(NSString *)userIds{
    if(self = [super init]){
        [self addParam:userIds forKey:@"kickedUserIds"];
        [self addParam:motorcadeId forKey:@"motorcadeId"];
    }
    
    return self;
}

- (CXHTTPMethod)method{
    return CXHTTPMethod_POST;
}

- (NSString *)path{
    return @"/carlife/motorcade/kickOutMotorcade";
}

@end
