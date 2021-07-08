//
//  CXMotorcadeUpdateNameRequest.h
//  Pods
//
//  Created by wshaolin on 2019/4/16.
//

#import "CXBaseMotorcadeURLRequest.h"

@interface CXMotorcadeUpdateNameRequest : CXBaseMotorcadeURLRequest

- (instancetype)initWithMotorcadeId:(NSString *)motorcadeId name:(NSString *)name;

@end
