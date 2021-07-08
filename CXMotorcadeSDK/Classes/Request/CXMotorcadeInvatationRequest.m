//
//  CXMotorcadeInvatationRequest.m
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXMotorcadeInvatationRequest.h"

@implementation CXMotorcadeInvatationRequest

- (instancetype)initWithInviteType:(CXMotorcadeInviteType)inviteType{
    if(self = [super init]){
        [self addParam:@(inviteType) forKey:@"type"];
    }
    
    return self;
}

- (NSString *)path{
    return @"/carlife/motorcade/getMotorcadeInvitation";
}

- (id)modelWithData:(id)data{
    return [CXMotorcadeInvatationModel cx_modelWithData:data];
}

@end
