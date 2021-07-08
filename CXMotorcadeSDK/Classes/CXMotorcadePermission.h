//
//  CXMotorcadePermission.h
//  Pods
//
//  Created by wshaolin on 2019/4/11.
//

#import <Foundation/Foundation.h>

typedef void(^CXMotorcadePermissionBlock)(BOOL granted, BOOL first);

@interface CXMotorcadePermission : NSObject

+ (void)checkMicPermission:(CXMotorcadePermissionBlock)block;

@end
