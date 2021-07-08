//
//  CXEditMicPermissionRequest.m
//  Pods
//
//  Created by wshaolin on 2019/4/8.
//

#import "CXEditMicPermissionRequest.h"

@interface CXEditMicPermissionRequest () {
    NSString *_userId;
}

@end

@implementation CXEditMicPermissionRequest

- (instancetype)initWithMotorcadeId:(NSString *)motorcadeId
                         permission:(BOOL)permission
                          forUserId:(NSString *)userId{
    if(self = [super initWithMotorcadeId:motorcadeId]){
        _userId = userId;
        [self addParam:@(permission) forKey:@"permission"];
        [self addParam:userId forKey:@"changeUserId"];
    }
    
    return self;
}

- (CXHTTPMethod)method{
    return CXHTTPMethod_POST;
}

- (NSString *)path{
    if(_userId){
        return @"/motorcadeServer/app/motorcade/user/setMicUserPermission";
    }
    
    return @"/motorcadeServer/app/motorcade/user/setMicAllPermission";
}

@end
