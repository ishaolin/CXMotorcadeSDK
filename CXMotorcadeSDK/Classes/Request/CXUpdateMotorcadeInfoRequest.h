//
//  CXUpdateMotorcadeInfoRequest.h
//  Pods
//
//  Created by wshaolin on 2019/4/8.
//

#import "CXBaseMotorcadeURLRequest.h"

@interface CXUpdateMotorcadeInfoRequest : CXBaseMotorcadeURLRequest

- (instancetype)initWithMotorcadeInfo:(NSDictionary<NSString *, id> *)info;

@end
