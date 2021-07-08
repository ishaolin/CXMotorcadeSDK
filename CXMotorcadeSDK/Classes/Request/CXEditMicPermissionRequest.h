//
//  CXEditMicPermissionRequest.h
//  Pods
//
//  Created by wshaolin on 2019/4/8.
//

#import "CXBaseMotorcadeURLRequest.h"

@interface CXEditMicPermissionRequest : CXBaseMotorcadeURLRequest

- (instancetype)initWithMotorcadeId:(NSString *)motorcadeId
                         permission:(BOOL)permission
                          forUserId:(NSString *)userId;

@end
