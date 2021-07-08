//
//  CXUserMicPermissionRequest.m
//  Pods
//
//  Created by wshaolin on 2019/4/11.
//

#import "CXUserMicPermissionRequest.h"

@implementation CXUserMicPermissionRequest

- (NSString *)path{
    return @"/motorcadeServer/app/motorcade/user/getMicUserPermission";
}

- (id)modelWithData:(id)data{
    return [CXUserMicPermissionModel cx_modelWithData:data];
}

@end
