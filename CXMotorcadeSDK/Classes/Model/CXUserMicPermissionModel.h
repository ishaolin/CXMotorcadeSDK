//
//  CXUserMicPermissionModel.h
//  Pods
//
//  Created by wshaolin on 2019/4/11.
//

#import "CXBaseMotorcadeModel.h"

@class CXUserMicPermissionResultModel;

@interface CXUserMicPermissionModel : CXBaseMotorcadeModel

@property (nonatomic, strong) CXUserMicPermissionResultModel *result;

@end

@interface CXUserMicPermissionResultModel : NSObject

@property (nonatomic, assign) BOOL permission;
@property (nonatomic, copy) NSString *msg;

@end
